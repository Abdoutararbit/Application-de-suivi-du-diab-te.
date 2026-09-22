import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/meal_repository.dart';
import '../datasources/vision_remote_datasource.dart';
import '../../../meal_log/data/datasources/meal_local_datasource.dart';

/// Implémentation concrète de MealRepository
class MealRepositoryImpl implements MealRepository {
  MealRepositoryImpl({
    required this.visionRemoteDataSource,
    required this.openFoodFactsDataSource,
    required this.localDataSource,
  });

  final VisionRemoteDataSource visionRemoteDataSource;
  final OpenFoodFactsDataSource openFoodFactsDataSource;
  final MealLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Meal>> analyzeMealPhoto(String imagePath) async {
    try {
      final meal = await visionRemoteDataSource.analyzeMealPhoto(imagePath);
      return Right(meal);
    } catch (e) {
      return Left(VisionApiFailure('Erreur lors de l\'analyse de l\'image : $e'));
    }
  }

  @override
  Future<Either<Failure, Meal>> analyzeMealBarcode(String barcode) async {
    try {
      final meal = await openFoodFactsDataSource.analyzeMealBarcode(barcode);
      return Right(meal);
    } catch (e) {
      return Left(FoodDatabaseFailure('Code-barres introuvable ou erreur réseau : $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveMeal(Meal meal) async {
    try {
      await localDataSource.saveMeal(meal);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure('Impossible d\'enregistrer le repas : $e'));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> getAllMeals() async {
    try {
      final meals = await localDataSource.getAllMeals();
      return Right(meals);
    } catch (e) {
      return Left(LocalDatabaseFailure('Impossible de charger l\'historique : $e'));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> getMealsByDate(DateTime date) async {
    try {
      final meals = await localDataSource.getMealsByDate(date);
      return Right(meals);
    } catch (e) {
      return Left(LocalDatabaseFailure('Impossible de charger les repas de la journée : $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMeal(String mealId) async {
    try {
      await localDataSource.deleteMeal(mealId);
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseFailure('Impossible de supprimer le repas : $e'));
    }
  }
}
