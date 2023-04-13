class Nutriments {
  final double caloriesPer100g;
  final double caloriesPerServing;
  final double carbs;
  final double carbsPerServing;
  final double fiber;
  final double fiberPerServing;
  final double sugars;
  final double sugarsPerServing;
  final double protein;
  final double proteinPerServing;
  final double fats;
  final double fatsPerServing;
  final double saturatedFats;
  final double saturatedFatsPerServing;
  final double cholesterol;
  final double cholesterolPerServing;
  final double sodium;
  final double sodiumPerServing;
  final double potassium;
  final double potassiumPerServing;

  Nutriments({
    this.caloriesPer100g = 0,
    this.caloriesPerServing = 0,
    this.carbs = 0,
    this.carbsPerServing = 0,
    this.fiber = 0,
    this.fiberPerServing = 0,
    this.sugars = 0,
    this.sugarsPerServing = 0,
    this.protein = 0,
    this.proteinPerServing = 0,
    this.fats = 0,
    this.fatsPerServing = 0,
    this.saturatedFats = 0,
    this.saturatedFatsPerServing = 0,
    this.cholesterol = 0,
    this.cholesterolPerServing = 0,
    this.sodium = 0,
    this.sodiumPerServing = 0,
    this.potassium = 0,
    this.potassiumPerServing = 0,
  });

  factory Nutriments.fromJson(Map<String, Object?> json) {
    return Nutriments(
      caloriesPer100g: json['caloriesPer100g'] as double,
      caloriesPerServing: json['caloriesPerServing'] as double,
      carbs: json['carbs'] as double,
      carbsPerServing: json['carbsPerServing'] as double,
      fiber: json['fiber'] as double,
      fiberPerServing: json['fiberPerServing'] as double,
      sugars: json['sugars'] as double,
      sugarsPerServing: json['sugarsPerServing'] as double,
      protein: json['protein'] as double,
      proteinPerServing: json['proteinPerServing'] as double,
      fats: json['fats'] as double,
      fatsPerServing: json['fatsPerServing'] as double,
      saturatedFats: json['saturatedFats'] as double,
      saturatedFatsPerServing: json['saturatedFatsPerServing'] as double,
      cholesterol: json['cholesterol'] as double,
      cholesterolPerServing: json['cholesterolPerServing'] as double,
      sodium: json['sodium'] as double,
      sodiumPerServing: json['sodiumPerServing'] as double,
      potassium: json['potassium'] as double,
      potassiumPerServing: json['potassiumPerServing'] as double,
    );
  }
}
