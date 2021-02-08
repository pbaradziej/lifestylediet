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
  final List dishTypes;
  final List extendedIngredients;

  RecipeInformation({
    this.title,
    this.image,
    this.servings,
    this.readyInMinutes,
    this.spoonacularScore,
    this.dairyFree,
    this.glutenFree,
    this.vegan,
    this.vegetarian,
    this.veryHealthy,
    this.veryPopular,
    this.dishTypes,
    this.extendedIngredients,
  });

  factory RecipeInformation.fromJson(Map<String, dynamic> json) {
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
      dishTypes: json['dishTypes'] as List,
      extendedIngredients: json['extendedIngredients'] as List,
    );
  }
}

class ExtendedIngredients {
  final String name;
  final double amount;
  final String unit;

  ExtendedIngredients({this.name, this.amount, this.unit});

  factory ExtendedIngredients.fromJson(Map<String, dynamic> json) {
    return ExtendedIngredients(
      name: json['name'] as String,
      amount: json['amount'] as double,
      unit: json['unit'] as String,
    );
  }
}
