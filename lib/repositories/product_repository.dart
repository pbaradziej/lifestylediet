import 'dart:async';
import 'dart:convert';

import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/nutriments.dart';
import 'package:lifestylediet/providers/product_provider.dart';

class ProductRepository {
  final ProductProvider _productProvider;

  ProductRepository() : _productProvider = ProductProvider();

  Future<DatabaseProduct?> getProductFromBarcode(final String code) async {
    try {
      return await getProductFromCode(code);
    } catch (_) {
      return null;
    }
  }

  Future<DatabaseProduct> getProductFromCode(final String code) async {
    final String body = await _productProvider.getProductFromBarcode(code);
    final Map<String, Object?> singleProduct = jsonDecode(body) as Map<String, Object?>;
    final List<Object> productFoods = singleProduct['foods'] as List<Object>? ?? <Object>[];
    const int singleFood = 0;
    final Map<String, Object> product = productFoods[singleFood] as Map<String, Object>? ?? <String, Object>{};

    return _getDatabaseProduct(product);
  }

  Future<List<DatabaseProduct>> getSearchProducts(final String search) async {
    final String body = await _productProvider.getProductData(search);
    final Map<String, Object?> singleProduct = jsonDecode(body) as Map<String, Object?>;
    final List<Object?> productFoods = singleProduct['foods'] as List<Object?>? ?? <Object>[];
    final List<Map<String, Object?>> foods = List<Map<String, Object?>>.from(productFoods);

    return _getDatabaseProducts(foods);
  }

  List<DatabaseProduct> _getDatabaseProducts(final List<Map<String, Object?>> products) {
    return <DatabaseProduct>[
      for (Map<String, Object?> product in products) _getDatabaseProduct(product),
    ];
  }

  DatabaseProduct _getDatabaseProduct(final Map<String, Object?> product) {
    final Nutriments nutrimentsDatabase = _getNutriments(product);
    final Map<String, Object?>? photos = product['photo'] as Map<String, Object?>?;

    return DatabaseProduct(
      amount: 1,
      image: photos?['thumb'] as String? ?? photos?['highres'] as String? ?? '',
      name: product['food_name'] as String? ?? '',
      value: 'serving',
      servingUnit: _servingUnit(product),
      nutriments: nutrimentsDatabase,
    );
  }

  String _servingUnit(final Map<String, Object?> product) {
    if (product['serving_weight_grams'] != null) {
      return 'g';
    }

    return product['serving_unit'] as String? ?? '';
  }

  Nutriments _getNutriments(final Map<String, Object?> product) {
    final double servingWeight = _getServing(product);
    return Nutriments(
      caloriesPer100g: _calculatePer100g(product, 'nf_calories', servingWeight),
      caloriesPerServing: parseValueToTwoDigitDouble(product, 'nf_calories'),
      carbs: _calculatePer100g(product, 'nf_total_carbohydrate', servingWeight),
      carbsPerServing: parseValueToTwoDigitDouble(product, 'nf_total_carbohydrate'),
      fiber: _calculatePer100g(product, 'nf_dietary_fiber', servingWeight),
      fiberPerServing: parseValueToTwoDigitDouble(product, 'nf_dietary_fiber'),
      sugars: _calculatePer100g(product, 'nf_sugars', servingWeight),
      sugarsPerServing: parseValueToTwoDigitDouble(product, 'nf_sugars'),
      protein: _calculatePer100g(product, 'nf_protein', servingWeight),
      proteinPerServing: parseValueToTwoDigitDouble(product, 'nf_protein'),
      fats: _calculatePer100g(product, 'nf_total_fat', servingWeight),
      fatsPerServing: parseValueToTwoDigitDouble(product, 'nf_total_fat'),
      saturatedFats: _calculatePer100g(product, 'nf_saturated_fat', servingWeight),
      saturatedFatsPerServing: parseValueToTwoDigitDouble(product, 'nf_saturated_fat'),
      cholesterol: _calculatePer100g(product, 'nf_cholesterol', servingWeight),
      cholesterolPerServing: parseValueToTwoDigitDouble(product, 'nf_cholesterol'),
      sodium: _calculatePer100g(product, 'nf_sodium', servingWeight),
      sodiumPerServing: parseValueToTwoDigitDouble(product, 'nf_sodium'),
      potassium: _calculatePer100g(product, 'nf_potassium', servingWeight),
      potassiumPerServing: parseValueToTwoDigitDouble(product, 'nf_potassium'),
    );
  }

  double _getServing(final Map<String, Object?> product) {
    if (product['serving_weight_grams'] != null) {
      return _parseDouble(product, 'serving_weight_grams');
    }

    return _parseDouble(product, 'serving_qty');
  }

  double _calculatePer100g(final Map<String, Object?> product, final String key, final double servingWeight) {
    final double value = _parseDouble(product, key);
    final double servingWeightPer100 = servingWeight / 100;
    final double valueIn100g = value / servingWeightPer100;
    final String valueWithDecimals = valueIn100g.toStringAsFixed(2);

    return double.parse(valueWithDecimals);
  }

  double parseValueToTwoDigitDouble(final Map<String, Object?> product, final String key) {
    final double value = _parseDouble(product, key);
    final String valueWithDecimals = value.toStringAsFixed(2);

    return double.parse(valueWithDecimals);
  }

  double _parseDouble(final Map<String, Object?> product, final String key) {
    final Object? value = product[key];
    if (value != null) {
      return _getDoubleValue(value);
    }

    return -1;
  }

  double _getDoubleValue(final Object value) {
    if (value is double) {
      return value;
    }

    final int parsedValue = value as int;
    return parsedValue.toDouble();
  }
}
