class DatabaseProduct {
  final String id;
  final String meal;
  final String image;
  final String name;
  final Nutriments nutriments;
  double amount;
  String value;
  String servingUnit;

  DatabaseProduct(this.id, this.meal, this.amount, this.image, this.name,
      this.value, this.servingUnit, this.nutriments);

  factory DatabaseProduct.fromJson(Map<String, dynamic> json) {
    return DatabaseProduct(
      json['id'] as String,
      json['meal'] as String,
      json['amount'] as double,
      json['image'] as String,
      json['name'] as String,
      json['value'] as String,
      json['servingUnit'] as String,
      Nutriments.fromJson(json['nutriments']),
    );
  }
}

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

  Nutriments(
    this.caloriesPer100g,
    this.caloriesPerServing,
    this.carbs,
    this.carbsPerServing,
    this.fiber,
    this.fiberPerServing,
    this.sugars,
    this.sugarsPerServing,
    this.protein,
    this.proteinPerServing,
    this.fats,
    this.fatsPerServing,
    this.saturatedFats,
    this.saturatedFatsPerServing,
    this.cholesterol,
    this.cholesterolPerServing,
    this.sodium,
    this.sodiumPerServing,
    this.potassium,
    this.potassiumPerServing,
  );

  factory Nutriments.fromJson(Map<String, dynamic> json) {
    return Nutriments(
        json['caloriesPer100g'] as double,
        json['caloriesPerServing'] as double,
        json['carbs'] as double,
        json['carbsPerServing'] as double,
        json['fiber'] as double,
        json['fiberPerServing'] as double,
        json['sugars'] as double,
        json['sugarsPerServing'] as double,
        json['protein'] as double,
        json['proteinPerServing'] as double,
        json['fats'] as double,
        json['fatsPerServing'] as double,
        json['saturatedFats'] as double,
        json['saturatedFatsPerServing'] as double,
        json['cholesterol'] as double,
        json['cholesterolPerServing'] as double,
        json['sodium'] as double,
        json['sodiumPerServing'] as double,
        json['potassium'] as double,
        json['potassiumPerServing'] as double);
  }
}
