class NutrimentsData {
  final double calories;
  final double carbs;
  final double fiber;
  final double sugars;
  final double protein;
  final double fats;
  final double saturatedFats;
  final double cholesterol;
  final double sodium;
  final double potassium;

  NutrimentsData({
    required this.calories,
    required this.carbs,
    required this.fiber,
    required this.sugars,
    required this.protein,
    required this.fats,
    required this.saturatedFats,
    required this.cholesterol,
    required this.sodium,
    required this.potassium,
  });

  factory NutrimentsData.empty() {
    return NutrimentsData(
      calories: 0,
      carbs: 0,
      fiber: 0,
      sugars: 0,
      protein: 0,
      fats: 0,
      saturatedFats: 0,
      cholesterol: 0,
      sodium: 0,
      potassium: 0,
    );
  }
}
