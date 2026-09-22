import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../meal_scanner/data/models/meal_models.dart';
import '../../../meal_scanner/domain/entities/meal.dart';

/// Source de données locale pour la persistance des repas enregistrés
abstract class MealLocalDataSource {
  Future<void> saveMeal(Meal meal);
  Future<List<Meal>> getAllMeals();
  Future<List<Meal>> getMealsByDate(DateTime date);
  Future<void> deleteMeal(String mealId);
}

/// Implémentation basée sur un fichier JSON local (robuste, offline-first)
class MealLocalDataSourceImpl implements MealLocalDataSource {
  MealLocalDataSourceImpl({List<Meal>? inMemoryInitial}) {
    if (inMemoryInitial != null) {
      _inMemoryCache.addAll(inMemoryInitial);
    }
  }

  static const String _fileName = 'meals_log.json';
  final List<Meal> _inMemoryCache = [];
  bool _initialized = false;

  Future<File?> _getLocalFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return File('${dir.path}/$_fileName');
    } catch (_) {
      // Cas de test unitaire où path_provider n'a pas de mock platform
      return null;
    }
  }

  Future<void> _ensureLoaded() async {
    if (_initialized) return;
    _initialized = true;

    final file = await _getLocalFile();
    if (file != null && await file.exists()) {
      try {
        final content = await file.readAsString();
        final List<dynamic> list = jsonDecode(content);
        _inMemoryCache.clear();
        for (final item in list) {
          _inMemoryCache.add(MealModel.fromJson(item as Map<String, dynamic>));
        }
      } catch (_) {
        // En cas de corruption, garder le cache mémoire
      }
    }
  }

  Future<void> _persist() async {
    final file = await _getLocalFile();
    if (file != null) {
      try {
        final jsonList = _inMemoryCache.map((m) {
          if (m is MealModel) return m.toJson();
          return MealModel(
            id: m.id,
            items: m.items
                .map((it) => FoodItemModel(
                      id: it.id,
                      name: it.name,
                      portionGrams: it.portionGrams,
                      carbsPer100g: it.carbsPer100g,
                      confidence: it.confidence,
                      imagePath: it.imagePath,
                      barcode: it.barcode,
                    ))
                .toList(),
            timestamp: m.timestamp,
            photoPath: m.photoPath,
            notes: m.notes,
            childName: m.childName,
          ).toJson();
        }).toList();
        await file.writeAsString(jsonEncode(jsonList));
      } catch (_) {}
    }
  }

  @override
  Future<void> saveMeal(Meal meal) async {
    await _ensureLoaded();
    _inMemoryCache.removeWhere((m) => m.id == meal.id);
    _inMemoryCache.insert(0, meal);
    await _persist();
  }

  @override
  Future<List<Meal>> getAllMeals() async {
    await _ensureLoaded();
    return List.unmodifiable(_inMemoryCache);
  }

  @override
  Future<List<Meal>> getMealsByDate(DateTime date) async {
    await _ensureLoaded();
    return _inMemoryCache.where((m) {
      return m.timestamp.year == date.year &&
          m.timestamp.month == date.month &&
          m.timestamp.day == date.day;
    }).toList();
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    await _ensureLoaded();
    _inMemoryCache.removeWhere((m) => m.id == mealId);
    await _persist();
  }
}
