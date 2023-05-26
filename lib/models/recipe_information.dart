import 'package:lifestylediet/models/extended_ingredients.dart';

class RecipeInformation {
  final String title;
  final String image;
  final int servings;
  final int readyInMinutes;
  final double spoonacularScore;
  final bool dairyFree;
  final bool glutenFree;
  final bool vegan;
  final bool vegetarian;
  final bool veryHealthy;
  final bool veryPopular;
  final List<Object> dishTypes;
  final List<ExtendedIngredients> extendedIngredients;

  RecipeInformation({
    required this.title,
    required this.image,
    required this.servings,
    required this.readyInMinutes,
    required this.spoonacularScore,
    required this.dairyFree,
    required this.glutenFree,
    required this.vegan,
    required this.vegetarian,
    required this.veryHealthy,
    required this.veryPopular,
    required this.dishTypes,
    required this.extendedIngredients,
  });

  factory RecipeInformation.fromJson(final Map<String, dynamic> json) {
    final List<Object> extendedIngredients = json['extendedIngredients'] as List<Object>;
    final Iterable<ExtendedIngredients> parsedExtendedIngredients = _getExtendedIngredients(extendedIngredients);

    return RecipeInformation(
      title: json['title'] as String,
      image: json['image'] as String,
      servings: json['servings'] as int,
      readyInMinutes: json['readyInMinutes'] as int,
      spoonacularScore: json['spoonacularScore'] as double,
      dairyFree: json['dairyFree'] as bool,
      glutenFree: json['glutenFree'] as bool,
      vegan: json['vegan'] as bool,
      vegetarian: json['vegetarian'] as bool,
      veryHealthy: json['veryHealthy'] as bool,
      veryPopular: json['veryPopular'] as bool,
      dishTypes: json['dishTypes'] as List<Object>,
      extendedIngredients: parsedExtendedIngredients.toList(),
    );
  }

  static Iterable<ExtendedIngredients> _getExtendedIngredients(final List<Object> extendedIngredients) sync* {
    for (final Object ingredient in extendedIngredients) {
      yield ExtendedIngredients.fromJson(ingredient as Map<String, Object?>);
    }
  }
}
