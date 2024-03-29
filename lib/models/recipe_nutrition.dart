class RecipeNutrition {
  final String calories;
  final String carbs;
  final String fat;
  final String protein;

  RecipeNutrition({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  factory RecipeNutrition.fromJson(final Map<String, dynamic> json) {
    return RecipeNutrition(
      calories: json['calories'] as String,
      carbs: json['carbs'] as String,
      fat: json['fat'] as String,
      protein: json['protein'] as String,
    );
  }
}
