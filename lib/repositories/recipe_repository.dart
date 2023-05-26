import 'dart:async';
import 'dart:convert';

import 'package:lifestylediet/models/recipe.dart';
import 'package:lifestylediet/models/recipe_information.dart';
import 'package:lifestylediet/models/recipe_instruction.dart';
import 'package:lifestylediet/models/recipe_meal.dart';
import 'package:lifestylediet/models/recipe_nutrition.dart';
import 'package:lifestylediet/providers/recipe_provider.dart';

class RecipeRepository {
  final RecipeProvider _recipeProvider;

  RecipeRepository() : _recipeProvider = RecipeProvider();

  Future<List<RecipeMeal>> getRecipes(final String name) async {
    final String body = await _recipeProvider.getRecipes(name);
    final Map<String, Object?> recipesList = jsonDecode(body) as Map<String, Object?>;
    final List<Object?> recipes = recipesList['results'] as List<Object?>;
    final Iterable<RecipeMeal> recipeMeals = _getRecipeMeals(recipes);

    return recipeMeals.toList();
  }

  Future<List<RecipeMeal>> getInitialRecipes() async {
    final String body = await _recipeProvider.getInitialRecipes();
    final Map<String, Object?> recipesList = jsonDecode(body) as Map<String, Object?>;
    final List<Object?> recipes = recipesList['recipes'] as List<Object?>;
    final Iterable<RecipeMeal> recipeMeals = _getRecipeMeals(recipes);

    return recipeMeals.toList();
  }

  static Iterable<RecipeMeal> _getRecipeMeals(final List<Object?> recipes) sync* {
    for (final Object? recipe in recipes) {
      yield RecipeMeal.fromJson(recipe as Map<String, Object?>);
    }
  }

  Future<Recipe> getRecipe(final int id) async {
    final RecipeInformation recipeInformation = await _getRecipeInformation(id);
    final RecipeNutrition recipeNutrition = await _getRecipeNutrition(id);
    final RecipeInstruction recipeInstruction = await _getRecipeInstruction(id);

    return Recipe(
      recipeInformation: recipeInformation,
      recipeNutrition: recipeNutrition,
      recipeInstruction: recipeInstruction,
    );
  }

  Future<RecipeInformation> _getRecipeInformation(final int id) async {
    final String bodyInfo = await _recipeProvider.getRecipeInformation(id);
    final Map<String, Object?> recipeInformationJson = jsonDecode(bodyInfo) as Map<String, Object?>;

    return RecipeInformation.fromJson(recipeInformationJson);
  }

  Future<RecipeNutrition> _getRecipeNutrition(final int id) async {
    final String bodyNutrition = await _recipeProvider.getRecipeNutrition(id);
    final Map<String, Object?> recipeNutritionJson = jsonDecode(bodyNutrition) as Map<String, Object?>;

    return RecipeNutrition.fromJson(recipeNutritionJson);
  }

  Future<RecipeInstruction> _getRecipeInstruction(final int id) async {
    final String bodyInstruction = await _recipeProvider.getRecipeInstruction(id);

    if (bodyInstruction != '[]') {
      final Map<String, Object?> decodedInformation = _unpackListJson(bodyInstruction);
      return RecipeInstruction.fromJson(decodedInformation);
    } else {
      return RecipeInstruction.empty();
    }
  }

  Map<String, Object?> _unpackListJson(final String bodyInstruction) {
    final String json = '{"instruction": $bodyInstruction}';
    final Map<String, Object?> decodedInformationMap = jsonDecode(json) as Map<String, Object?>;
    final List<Object> decodedInstruction = decodedInformationMap['instruction'] as List<Object>;
    const int singleInstruction = 0;

    return decodedInstruction[singleInstruction] as Map<String, Object?>;
  }
}
