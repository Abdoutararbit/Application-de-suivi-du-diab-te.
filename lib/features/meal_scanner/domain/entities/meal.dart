import 'food_item.dart';

/// Résultat complet d'une analyse de repas
class Meal {
  const Meal({
    required this.id,
    required this.items,
    required this.timestamp,
    this.photoPath,
    this.notes,
    this.childName,
  });

  final String id;
  final List<FoodItem> items;
  final DateTime timestamp;
  final String? photoPath;
  final String? notes;
  final String? childName;

  /// Total de glucides du repas en grammes
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.totalCarbs);

  /// Équivalent en morceaux de sucre (1 morceau = 5g glucides)
  double get totalSugarCubes => totalCarbs / 5;

  /// Estimation de l'unité d'insuline à injecter (nécessite le ratio carb/insuline)
  double insulinDose(double carbRatio) => totalCarbs / carbRatio;

  /// Niveau de glucides (pour les couleurs)
  CarbLevel get carbLevel {
    if (totalCarbs < 20) return CarbLevel.low;
    if (totalCarbs < 50) return CarbLevel.medium;
    return CarbLevel.high;
  }

  Meal copyWith({
    String? id,
    List<FoodItem>? items,
    DateTime? timestamp,
    String? photoPath,
    String? notes,
    String? childName,
  }) {
    return Meal(
      id: id ?? this.id,
      items: items ?? this.items,
      timestamp: timestamp ?? this.timestamp,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      childName: childName ?? this.childName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum CarbLevel {
  low,    // < 20g
  medium, // 20–50g
  high,   // > 50g
}

extension CarbLevelExt on CarbLevel {
  String get label {
    switch (this) {
      case CarbLevel.low: return 'Peu de glucides 🟢';
      case CarbLevel.medium: return 'Glucides modérés 🟡';
      case CarbLevel.high: return 'Beaucoup de glucides 🔴';
    }
  }
}
