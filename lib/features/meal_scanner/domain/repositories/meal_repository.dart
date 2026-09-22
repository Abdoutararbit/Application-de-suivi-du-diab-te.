import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/meal.dart';

/// Contrat du repository de repas — agnostique de la source de données
abstract class MealRepository {
  /// Analyse une photo de repas avec l'IA Vision
  Future<Either<Failure, Meal>> analyzeMealPhoto(String imagePath);

  /// Analyse un aliment via son code-barres (Open Food Facts)
  Future<Either<Failure, Meal>> analyzeMealBarcode(String barcode);

  /// Sauvegarde un repas validé par l'enfant
  Future<Either<Failure, void>> saveMeal(Meal meal);

  /// Récupère tous les repas enregistrés (du plus récent au plus ancien)
  Future<Either<Failure, List<Meal>>> getAllMeals();

  /// Récupère les repas d'une journée spécifique
  Future<Either<Failure, List<Meal>>> getMealsByDate(DateTime date);

  /// Supprime un repas par son ID
  Future<Either<Failure, void>> deleteMeal(String mealId);
}
