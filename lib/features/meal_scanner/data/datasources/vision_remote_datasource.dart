import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/meal_models.dart';
import '../../domain/entities/meal.dart';

/// Source de données distante — Analyse IA via Gemini Vision API
class VisionRemoteDataSource {
  VisionRemoteDataSource(this._dio);
  final Dio _dio;

  /// Clé API Gemini — À configurer dans un fichier .env ou via dart-define
  /// flutter run --dart-define=GEMINI_API_KEY=votre_clé
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'REMPLACER_PAR_VOTRE_CLE_GEMINI',
  );
  static const String _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  /// Système de prompt optimisé pour la détection alimentaire
  static const String _systemPrompt = '''
Tu es un expert en nutrition et en alimentation pour enfants diabétiques.
Analyse cette image d'un repas et retourne une liste JSON des aliments détectés.

Format de réponse OBLIGATOIRE (JSON uniquement, pas de texte) :
{
  "foods": [
    {
      "name": "Nom de l'aliment en français",
      "portion_grams": 150,
      "carbs_per_100g": 30,
      "confidence": 0.9
    }
  ],
  "total_carbs_g": 45.5,
  "notes": "Commentaire optionnel pour l'enfant"
}

Règles :
- Estime les portions visuellement (en grammes)
- Donne les glucides pour 100g (valeur référence standard)
- La confiance va de 0.0 à 1.0
- Sois conservateur dans tes estimations de portions
- Si tu ne reconnais pas un aliment, indique confidence: 0.5
''';

  /// Analyse une photo de repas en base64
  Future<Meal> analyzeMealPhoto(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final extension = imagePath.split('.').last.toLowerCase();
    final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

    final response = await _dio.post(
      '$_geminiUrl?key=$_apiKey',
      data: {
        'contents': [
          {
            'parts': [
              {'text': _systemPrompt},
              {
                'inline_data': {
                  'mime_type': mimeType,
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.1,
          'response_mime_type': 'application/json',
        },
      },
    );

    final content = response.data['candidates'][0]['content']['parts'][0]['text'];
    final Map<String, dynamic> parsed = jsonDecode(content as String);
    
    final foods = (parsed['foods'] as List<dynamic>)
        .map((f) => FoodItemModel.fromGeminiResponse(f as Map<String, dynamic>))
        .toList();

    return MealModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: foods,
      timestamp: DateTime.now(),
      photoPath: imagePath,
    );
  }
}

/// Source de données — Open Food Facts (codes-barres)
class OpenFoodFactsDataSource {
  OpenFoodFactsDataSource(this._dio);
  final Dio _dio;

  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2/product';

  Future<Meal> analyzeMealBarcode(String barcode) async {
    final response = await _dio.get(
      '$_baseUrl/$barcode.json',
      queryParameters: {
        'fields': 'product_name,nutriments,image_url,brands',
      },
    );

    if (response.data['status'] != 1) {
      throw Exception('Produit non trouvé pour le code-barres : $barcode');
    }

    final product = response.data['product'] as Map<String, dynamic>;
    final foodItem = FoodItemModel.fromOpenFoodFacts(product, barcode);

    return MealModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: [foodItem],
      timestamp: DateTime.now(),
    );
  }
}
