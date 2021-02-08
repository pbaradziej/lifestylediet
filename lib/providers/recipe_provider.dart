import 'dart:io';

import 'package:http/http.dart' as http;

class RecipeProvider {
  final String SPOONACULAR_URL = "api.spoonacular.com";
  static const String API_KEY = "df9b380178e64f5c94568eaa1ec3f317";

  Future getRecipes(String name) async {
    Map<String, String> parameters = {
      'query': name,
      'number': '5',
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(
      SPOONACULAR_URL,
      '/recipes/complexSearch',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Recipe not found');
    }
  }

  Future getRandomRecipes() async {
    Map<String, String> parameters = {
      'number': '5',
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(
      SPOONACULAR_URL,
      '/recipes/random',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Recipe not found');
    }
  }

  Future getRecipeInformation(int id) async {
    Map<String, String> parameters = {
      'includeNutrition': 'false',
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(
      SPOONACULAR_URL,
      '/recipes/$id/information',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Recipe not found');
    }
  }

  Future getRecipeNutrition(int id) async {
    Map<String, String> parameters = {
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(
      SPOONACULAR_URL,
      '/recipes/$id/nutritionWidget.json',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Recipe not found');
    }
  }

  Future getRecipeInstruction(int id) async {
    Map<String, String> parameters = {
      'apiKey': API_KEY,
    };
    Uri uri = Uri.https(
      SPOONACULAR_URL,
      '/recipes/$id/analyzedInstructions',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Recipe not found');
    }
  }
}
