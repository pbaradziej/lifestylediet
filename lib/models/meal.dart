import 'models.dart';

class Meal {
  final String name;
  bool isExpanded;
  final List<DatabaseProduct> mealList;

  Meal(this.name, this.isExpanded, this.mealList);
}
