import 'dart:async';
import 'dart:convert';

import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/providers/providers.dart';

class RecipeRepository {
  RecipeProvider _recipeProvider = RecipeProvider();

  Future<List<RecipeMeal>> getRecipes(String name) async {
    final body = await _recipeProvider.getRecipes(name);
    Map<String, dynamic> recipesList = jsonDecode(body);
    List recipes = recipesList["results"];

    return recipes.map((recipe) => RecipeMeal.fromJson(recipe)).toList();
  }

  Future<List<RecipeMeal>> getInitialRecipes() async {
    final body = await _recipeProvider.getInitialRecipes();
    Map<String, dynamic> recipesList = jsonDecode(body);
    List recipes = recipesList["recipes"];

    return recipes.map((recipe) => RecipeMeal.fromJson(recipe)).toList();
  }

  Future<Recipe> getRecipe(int id) async {
    RecipeInformation recipeInformation = await _getRecipeInformation(id);
    RecipeNutrition recipeNutrition = await _getRecipeNutrition(id);
    RecipeInstruction recipeInstruction = await _getRecipeInstruction(id);

    return new Recipe(
      recipeInformation: recipeInformation,
      recipeNutrition: recipeNutrition,
      recipeInstruction: recipeInstruction,
    );
  }

  Future<RecipeInformation> _getRecipeInformation(int id) async {
    final bodyInfo = await _recipeProvider.getRecipeInformation(id);
    Map<String, dynamic> recipeInformationJson = jsonDecode(bodyInfo);

    return RecipeInformation.fromJson(recipeInformationJson);
  }

  Future<RecipeNutrition> _getRecipeNutrition(int id) async {
    final bodyNutrition = await _recipeProvider.getRecipeNutrition(id);
    Map<String, dynamic> recipeNutritionJson = jsonDecode(bodyNutrition);

    return RecipeNutrition.fromJson(recipeNutritionJson);
  }

  Future<RecipeInstruction> _getRecipeInstruction(int id) async {
    final bodyInstruction = await _recipeProvider.getRecipeInstruction(id);

    if (bodyInstruction != '[]') {
      var decodedInformation = _unpackListJson(bodyInstruction);
      return RecipeInstruction.fromJson(decodedInformation);
    } else {
      return RecipeInstruction.fromJson(new Map());
    }
  }

  _unpackListJson(final bodyInstruction) {
    String json = '{"instruction": ' + bodyInstruction + '}';
    var decodedInformationMap = jsonDecode(json);
    var decodedInstruction = decodedInformationMap['instruction'];

    return decodedInstruction[0];
  }
}
