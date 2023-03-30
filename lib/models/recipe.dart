import 'package:lifestylediet/models/recipe_information.dart';
import 'package:lifestylediet/models/recipe_instruction.dart';
import 'package:lifestylediet/models/recipe_nutrition.dart';

class Recipe {
  final RecipeInstruction recipeInstruction;
  final RecipeNutrition recipeNutrition;
  final RecipeInformation recipeInformation;

  Recipe({
    required this.recipeInstruction,
    required this.recipeNutrition,
    required this.recipeInformation,
  });
}
