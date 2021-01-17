import 'dart:async';
import 'dart:convert';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/providers/providers.dart';

class ProductRepository {
  ProductProvider _productProvider = ProductProvider();

  Future<DatabaseProduct> getProductFromBarcode(String code) async {
    final body = await _productProvider.getProductFromBarcode(code);
    Map<String, dynamic> productMap = jsonDecode(body);
    Object product = productMap["foods"][0];
    DatabaseProduct databaseProduct = _getDatabaseProduct(product);

    return databaseProduct;
  }

  Future<List<DatabaseProduct>> getSearchProducts(String search) async {
    final body = await _productProvider.getProductData(search);
    Map<String, dynamic> productMap = jsonDecode(body);
    List products = productMap["foods"];
    List<DatabaseProduct> databaseProductList = new List<DatabaseProduct>();
    for (var product in products) {
      DatabaseProduct databaseProduct = _getDatabaseProduct(product);
      databaseProductList.add(databaseProduct);
    }
    return databaseProductList;
  }

  DatabaseProduct _getDatabaseProduct(final product) {
    Nutriments nutrimentsDatabase = _getNutriments(product);
    Map photos = product["photo"];
    return new DatabaseProduct(
      "",
      "",
      "",
      1,
      photos["thumb"] ?? photos["highres"],
      product["food_name"],
      "serving",
      _servingUnit(product),
      nutrimentsDatabase,
    );
  }

  Nutriments _getNutriments(final product) {
    double servingWeight = _getServing(product);
    return new Nutriments(
      _calculatePer100g(
        product["nf_calories"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_calories"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_total_carbohydrate"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_total_carbohydrate"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_dietary_fiber"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_dietary_fiber"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_sugars"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_sugars"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_protein"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_protein"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_total_fat"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_total_fat"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_saturated_fat"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_saturated_fat"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_cholesterol"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_cholesterol"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_sodium"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_sodium"]?.toDouble()) ?? -1,
      _calculatePer100g(
        product["nf_potassium"]?.toDouble() ?? -1,
        servingWeight,
      ),
      formatTo2Digits(product["nf_potassium"]?.toDouble()) ?? -1,
    );
  }

  String _servingUnit(final product) {
    if (product["serving_weight_grams"] != null) {
      return "g";
    }

    return product["serving_unit"];
  }

  double _getServing(final product) {
    if (product["serving_weight_grams"] != null) {
      return product["serving_weight_grams"]?.toDouble();
    }

    return product["serving_qty"]?.toDouble();
  }

  double formatTo2Digits(double value) {
    if (value == null) {
      return -1;
    }

    return double.parse((value).toStringAsFixed(2));
  }

  double _calculatePer100g(double value, double servingWeight) {
    double servingWeightPer100 = servingWeight / 100;
    double valueIn100g = value / servingWeightPer100;

    return double.parse((valueIn100g).toStringAsFixed(2));
  }
}
