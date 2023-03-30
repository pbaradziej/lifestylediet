import 'dart:io';

import 'package:http/http.dart' as http;

class RecipeProvider {
  static const String SPOONACULAR_URL = 'api.spoonacular.com';
  static const String API_KEY = '0168d7219d5d4c53bc343f9e0e967977';

  Future<String> getRecipes(String name) async {
    const String url = '/recipes/complexSearch';
    final Map<String, String> parameters = <String, String>{
      'query': name,
      'number': '5',
    };

    return _getResponse(url: url, parameters: parameters);
  }

  Future<String> getInitialRecipes() async {
    const String url = '/recipes/random';
    final Map<String, String> parameters = <String, String>{
      'number': '5',
    };

    return _getResponse(url: url, parameters: parameters);
  }

  Future<String> getRecipeInformation(int id) async {
    final String url = '/recipes/$id/information';
    final Map<String, String> parameters = <String, String>{
      'includeNutrition': 'false',
    };

    return _getResponse(url: url, parameters: parameters);
  }

  Future<String> getRecipeNutrition(int id) async {
    final String url = '/recipes/$id/nutritionWidget.json';
    return _getResponse(url: url);
  }

  Future<String> getRecipeInstruction(int id) async {
    final String url = '/recipes/$id/analyzedInstructions';
    return _getResponse(url: url);
  }

  Future<String> _getResponse({
    required String url,
    Map<String, String> parameters = const <String, String>{},
  }) async {
    final Uri uri = _getUri(url, parameters);
    final Map<String, String> headers = _getHeaders();
    final http.Response response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception('Recipe not found');
  }

  Uri _getUri(String url, Map<String, String> parameters) {
    final Map<String, String> updatedParameters = _getParameters(parameters);
    return Uri.https(SPOONACULAR_URL, url, updatedParameters);
  }

  Map<String, String> _getParameters(Map<String, String> parameters) {
    final Map<String, String> defaultParameters = _getDefaultParameters();
    parameters.addAll(defaultParameters);

    return parameters;
  }

  Map<String, String> _getDefaultParameters() {
    return <String, String>{
      'apiKey': API_KEY,
    };
  }

  Map<String, String> _getHeaders() {
    final Map<String, String> headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    return headers;
  }
}
