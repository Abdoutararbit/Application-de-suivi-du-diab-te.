import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/meal.dart';
import '../repositories/meal_repository.dart';

/// Use case : Analyser une photo de repas avec l'IA Vision
class AnalyzeMealPhotoUseCase {
  const AnalyzeMealPhotoUseCase(this._repository);
  final MealRepository _repository;

  Future<Either<Failure, Meal>> call(String imagePath) async {
    if (imagePath.isEmpty) {
      return const Left(CameraFailure('Chemin d\'image invalide.'));
    }
    return _repository.analyzeMealPhoto(imagePath);
  }
}

/// Use case : Scanner un code-barres alimentaire
class ScanBarcodeUseCase {
  const ScanBarcodeUseCase(this._repository);
  final MealRepository _repository;

  Future<Either<Failure, Meal>> call(String barcode) async {
    if (barcode.isEmpty) {
      return const Left(FoodDatabaseFailure('Code-barres invalide.'));
    }
    return _repository.analyzeMealBarcode(barcode);
  }
}

/// Use case : Sauvegarder un repas validé
class SaveMealUseCase {
  const SaveMealUseCase(this._repository);
  final MealRepository _repository;

  Future<Either<Failure, void>> call(Meal meal) async {
    return _repository.saveMeal(meal);
  }
}

/// Use case : Obtenir tous les repas du journal
class GetAllMealsUseCase {
  const GetAllMealsUseCase(this._repository);
  final MealRepository _repository;

  Future<Either<Failure, List<Meal>>> call() async {
    return _repository.getAllMeals();
  }
}

/// Use case : Obtenir les repas d'une journée spécifique
class GetMealsByDateUseCase {
  const GetMealsByDateUseCase(this._repository);
  final MealRepository _repository;

  Future<Either<Failure, List<Meal>>> call(DateTime date) async {
    return _repository.getMealsByDate(date);
  }
}

/// Use case : Supprimer un repas
class DeleteMealUseCase {
  const DeleteMealUseCase(this._repository);
  final MealRepository _repository;

  Future<Either<Failure, void>> call(String mealId) async {
    if (mealId.isEmpty) {
      return const Left(UnexpectedFailure('ID de repas invalide.'));
    }
    return _repository.deleteMeal(mealId);
  }
}
