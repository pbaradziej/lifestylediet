class ExtendedIngredients {
  final String name;
  final double amount;
  final String unit;

  ExtendedIngredients({
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory ExtendedIngredients.fromJson(Map<String, Object?> json) {
    return ExtendedIngredients(
      name: json['name'] as String,
      amount: json['amount'] as double,
      unit: json['unit'] as String,
    );
  }
}
