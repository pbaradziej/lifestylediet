import 'package:intl/intl.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/models/recipe.dart';
import 'package:lifestylediet/models/recipe_information.dart';
import 'package:lifestylediet/models/recipe_nutrition.dart';
import 'package:lifestylediet/utils/uuid_utils.dart';

class RecipeHelper {
  static DatabaseProduct getProductFromRecipe({
    required final Recipe recipe,
    required final String amount,
    required final String meal,
  }) {
    final RecipeInformation recipeInformation = recipe.recipeInformation;
    return DatabaseProduct(
      id: UuidUtils.getUuid(),
      date: _getDateNow(),
      meal: meal,
      amount: _parseNutritionValue(amount),
      image: recipeInformation.image,
      name: recipeInformation.title,
      value: 'serving',
      nutriments: _getNutriments(recipe),
    );
  }

  static String _getDateNow() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime dateNow = DateTime.now();

    return dateFormat.format(dateNow);
  }

  static Nutriments _getNutriments(final Recipe recipe) {
    final RecipeNutrition recipeNutrition = recipe.recipeNutrition;
    final String calories = recipeNutrition.calories;
    final String carbs = recipeNutrition.carbs;
    final String protein = recipeNutrition.protein;
    final String fat = recipeNutrition.fat;

    return Nutriments(
      caloriesPerServing: _parseNutritionValue(calories),
      carbsPerServing: _parseNutritionValue(carbs),
      proteinPerServing: _parseNutritionValue(protein),
      fatsPerServing: _parseNutritionValue(fat),
    );
  }

  static double _parseNutritionValue(final String value) {
    final String parsedValue = value.replaceAll('g', '');
    return double.parse(parsedValue);
  }
}
