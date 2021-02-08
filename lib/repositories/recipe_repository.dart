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
    List<RecipeMeal> recipeList = new List<RecipeMeal>();
    for (var recipe in recipes) {
      recipeList.add(RecipeMeal.fromJson(recipe));
    }

    return recipeList;
  }

  Future<List<RecipeMeal>> getRandomRecipes() async {
    final body = await _recipeProvider.getRandomRecipes();
    Map<String, dynamic> recipesList = jsonDecode(body);
    List recipes = recipesList["recipes"];
    List<RecipeMeal> recipeList = new List<RecipeMeal>();
    for (var recipe in recipes) {
      recipeList.add(RecipeMeal.fromJson(recipe));
    }

    return recipeList;
  }

  Future<Recipe> getRecipe(int id) async {
    final bodyInfo = await _recipeProvider.getRecipeInformation(id);
    Map<String, dynamic> recipeInformationJson = jsonDecode(bodyInfo);
    RecipeInformation recipeInformation =
        RecipeInformation.fromJson(recipeInformationJson);

    final bodyNutrition = await _recipeProvider.getRecipeNutrition(id);
    Map<String, dynamic> recipeNutritionJson = jsonDecode(bodyNutrition);
    RecipeNutrition recipeNutrition =
        RecipeNutrition.fromJson(recipeNutritionJson);

    final bodyInstruction = await _recipeProvider.getRecipeInstruction(id);
    var recipeInstructionJson;
    if (bodyInstruction != '[]') {
      String json = '{"instruction": ' + bodyInstruction + '}';
      recipeInstructionJson = jsonDecode(json)['instruction'][0];
    } else {
      recipeInstructionJson = [];
    }
    RecipeInstruction recipeInstruction =
        RecipeInstruction.fromJson(recipeInstructionJson);

    Recipe recipe = new Recipe(
      recipeInformation: recipeInformation,
      recipeNutrition: recipeNutrition,
      recipeInstruction: recipeInstruction,
    );

    return recipe;
  }
}
