/// Représentation d'un aliment détecté avec ses informations nutritionnelles
class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.portionGrams,
    required this.carbsPer100g,
    this.confidence = 1.0,
    this.imagePath,
    this.barcode,
  });

  final String id;
  final String name;
  final double portionGrams;     // Portion estimée en grammes
  final double carbsPer100g;     // Glucides pour 100g
  final double confidence;       // Niveau de confiance de l'IA (0.0 à 1.0)
  final String? imagePath;       // URL ou path local de l'image
  final String? barcode;         // Code EAN si issu d'un scan

  /// Calcule les glucides pour la portion actuelle
  double get totalCarbs => (portionGrams * carbsPer100g) / 100;

  /// Équivalent en morceaux de sucre (1 morceau ≈ 5g de glucides)
  double get sugarCubes => totalCarbs / 5;

  FoodItem copyWith({
    String? id,
    String? name,
    double? portionGrams,
    double? carbsPer100g,
    double? confidence,
    String? imagePath,
    String? barcode,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      portionGrams: portionGrams ?? this.portionGrams,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      confidence: confidence ?? this.confidence,
      imagePath: imagePath ?? this.imagePath,
      barcode: barcode ?? this.barcode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FoodItem($name, ${totalCarbs.toStringAsFixed(1)}g glucides)';
}
