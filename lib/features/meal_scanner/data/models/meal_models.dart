import '../../domain/entities/food_item.dart';
import '../../domain/entities/meal.dart';

/// Modèle de données JSON pour un aliment
class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.portionGrams,
    required super.carbsPer100g,
    super.confidence,
    super.imagePath,
    super.barcode,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Aliment inconnu',
      portionGrams: (json['portionGrams'] as num?)?.toDouble() ?? 100.0,
      carbsPer100g: (json['carbsPer100g'] as num?)?.toDouble() ?? 0.0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      imagePath: json['imagePath'] as String?,
      barcode: json['barcode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'portionGrams': portionGrams,
    'carbsPer100g': carbsPer100g,
    'confidence': confidence,
    'imagePath': imagePath,
    'barcode': barcode,
  };

  /// Construit depuis la réponse Gemini/Vision IA
  factory FoodItemModel.fromGeminiResponse(Map<String, dynamic> data) {
    return FoodItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: data['name'] as String? ?? 'Aliment',
      portionGrams: (data['portion_grams'] as num?)?.toDouble() ?? 100.0,
      carbsPer100g: (data['carbs_per_100g'] as num?)?.toDouble() ?? 0.0,
      confidence: (data['confidence'] as num?)?.toDouble() ?? 0.8,
    );
  }

  /// Construit depuis la réponse Open Food Facts
  factory FoodItemModel.fromOpenFoodFacts(Map<String, dynamic> product, String barcode) {
    final nutriments = product['nutriments'] as Map<String, dynamic>? ?? {};
    return FoodItemModel(
      id: barcode,
      name: product['product_name'] as String? ?? 'Produit $barcode',
      portionGrams: 100.0,
      carbsPer100g: (nutriments['carbohydrates_100g'] as num?)?.toDouble() ?? 0.0,
      confidence: 1.0,
      imagePath: product['image_url'] as String?,
      barcode: barcode,
    );
  }
}

/// Modèle de données JSON pour un repas
class MealModel extends Meal {
  const MealModel({
    required super.id,
    required super.items,
    required super.timestamp,
    super.photoPath,
    super.notes,
    super.childName,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      photoPath: json['photoPath'] as String?,
      notes: json['notes'] as String?,
      childName: json['childName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items
        .map((e) => (e as FoodItemModel).toJson())
        .toList(),
    'timestamp': timestamp.toIso8601String(),
    'photoPath': photoPath,
    'notes': notes,
    'childName': childName,
  };

  factory MealModel.fromDomain(Meal meal) {
    return MealModel(
      id: meal.id,
      items: meal.items,
      timestamp: meal.timestamp,
      photoPath: meal.photoPath,
      notes: meal.notes,
      childName: meal.childName,
    );
  }
}
