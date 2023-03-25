import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/meal.dart';

class MealBuilder {
  final List<DatabaseProduct> _breakfastProducts;
  final List<DatabaseProduct> _dinnerProducts;
  final List<DatabaseProduct> _supperProducts;

  MealBuilder(List<DatabaseProduct> products)
      : _breakfastProducts = <DatabaseProduct>[],
        _dinnerProducts = <DatabaseProduct>[],
        _supperProducts = <DatabaseProduct>[] {
    _prepareProducts(products);
  }

  List<Meal> createMeals() {
    final Meal breakfast = Meal(
      name: 'Breakfast',
      isExpanded: true,
      meals: _breakfastProducts,
    );
    final Meal dinner = Meal(
      name: 'Dinner',
      isExpanded: false,
      meals: _dinnerProducts,
    );
    final Meal supper = Meal(
      name: 'Supper',
      isExpanded: false,
      meals: _supperProducts,
    );

    return <Meal>[
      breakfast,
      dinner,
      supper,
    ];
  }

  void _prepareProducts(List<DatabaseProduct> products) {
    for (final DatabaseProduct product in products) {
      switch (product.meal) {
        case 'Breakfast':
          _breakfastProducts.add(product);
          break;
        case 'Dinner':
          _dinnerProducts.add(product);
          break;
        case 'Supper':
          _supperProducts.add(product);
          break;
      }
    }
  }
}
