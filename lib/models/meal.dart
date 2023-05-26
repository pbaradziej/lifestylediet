import 'package:lifestylediet/models/database_product.dart';

class Meal {
  final String name;
  final bool isExpanded;
  final List<DatabaseProduct> meals;

  Meal({
    required this.name,
    required this.isExpanded,
    required this.meals,
  });

  Meal copyWith({
    final String? name,
    final bool? isExpanded,
    final List<DatabaseProduct>? meals,
  }) {
    return Meal(
      name: name ?? this.name,
      isExpanded: isExpanded ?? this.isExpanded,
      meals: meals ?? this.meals,
    );
  }
}
