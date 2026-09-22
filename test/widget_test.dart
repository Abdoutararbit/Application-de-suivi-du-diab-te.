import 'package:flutter_test/flutter_test.dart';
import 'package:gluco_pote/features/meal_scanner/domain/entities/food_item.dart';
import 'package:gluco_pote/features/meal_scanner/domain/entities/meal.dart';
import 'package:gluco_pote/features/meal_scanner/data/models/meal_models.dart';

void main() {
  group('FoodItem Entity & Calculations', () {
    test('calculates total carbs and sugar cubes correctly', () {
      // 150g of food with 20g carbs / 100g = 30g total carbs
      const item = FoodItem(
        id: 'apple',
        name: 'Pomme',
        portionGrams: 150.0,
        carbsPer100g: 20.0,
      );

      expect(item.totalCarbs, equals(30.0));
      // 30g / 5g per cube = 6 cubes
      expect(item.sugarCubes, equals(6.0));
    });

    test('copyWith updates fields properly', () {
      const item = FoodItem(
        id: '1',
        name: 'Pain',
        portionGrams: 50.0,
        carbsPer100g: 50.0,
      );
      final updated = item.copyWith(portionGrams: 100.0);

      expect(updated.portionGrams, equals(100.0));
      expect(updated.totalCarbs, equals(50.0));
      expect(updated.name, equals('Pain'));
    });
  });

  group('Meal Entity & Insulin Calculations', () {
    test('calculates total carbs across multiple items and insulin dose', () {
      final meal = Meal(
        id: 'meal-1',
        timestamp: DateTime.now(),
        items: const [
          FoodItem(
            id: 'item-1',
            name: 'Pâtes',
            portionGrams: 100.0,
            carbsPer100g: 30.0, // 30g carbs
          ),
          FoodItem(
            id: 'item-2',
            name: 'Yaourt sucré',
            portionGrams: 100.0,
            carbsPer100g: 15.0, // 15g carbs
          ),
        ],
      );

      expect(meal.totalCarbs, equals(45.0));
      expect(meal.totalSugarCubes, equals(9.0));
      expect(meal.carbLevel, equals(CarbLevel.medium));

      // With ratio of 10g carb per 1 unit of insulin: 45 / 10 = 4.5 units
      expect(meal.insulinDose(10.0), equals(4.5));
    });

    test('categorizes carb levels correctly', () {
      final lowMeal = Meal(
        id: 'low',
        timestamp: DateTime.now(),
        items: const [
          FoodItem(id: '1', name: 'Salade', portionGrams: 100, carbsPer100g: 5),
        ],
      );
      expect(lowMeal.carbLevel, equals(CarbLevel.low));

      final highMeal = Meal(
        id: 'high',
        timestamp: DateTime.now(),
        items: const [
          FoodItem(id: '1', name: 'Pizza', portionGrams: 200, carbsPer100g: 35),
        ],
      );
      expect(highMeal.carbLevel, equals(CarbLevel.high));
    });
  });

  group('FoodItemModel parsing', () {
    test('parses Gemini AI JSON correctly', () {
      final geminiJson = {
        'name': 'Frites',
        'portion_grams': 120,
        'carbs_per_100g': 35.5,
        'confidence': 0.95,
      };

      final model = FoodItemModel.fromGeminiResponse(geminiJson);
      expect(model.name, equals('Frites'));
      expect(model.portionGrams, equals(120.0));
      expect(model.carbsPer100g, equals(35.5));
      expect(model.confidence, equals(0.95));
    });

    test('parses OpenFoodFacts JSON correctly', () {
      final offJson = {
        'product_name': 'Biscuits Chocolat',
        'image_url': 'https://example.com/biscuit.jpg',
        'nutriments': {
          'carbohydrates_100g': 62.0,
        },
      };

      final model = FoodItemModel.fromOpenFoodFacts(offJson, '3017620422003');
      expect(model.name, equals('Biscuits Chocolat'));
      expect(model.carbsPer100g, equals(62.0));
      expect(model.barcode, equals('3017620422003'));
      expect(model.confidence, equals(1.0));
    });
  });
}
