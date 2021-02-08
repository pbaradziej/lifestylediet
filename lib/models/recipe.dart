import 'package:lifestylediet/models/models.dart';

class Recipe {
  final RecipeInstruction recipeInstruction;
  final RecipeNutrition recipeNutrition;
  final RecipeInformation recipeInformation;

  Recipe(
      {this.recipeInstruction, this.recipeNutrition, this.recipeInformation});
}
