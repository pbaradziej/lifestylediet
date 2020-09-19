import 'package:openfoodfacts/openfoodfacts.dart';
import 'dart:async';

class Food {
  Future<Product> getProduct(String code) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(code,
        language: OpenFoodFactsLanguage.POLISH,
        fields: [
          ProductField.NAME,
          ProductField.NUTRIMENTS,
          ProductField.SELECTED_IMAGE,
          ProductField.BARCODE,
        ]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      return result.product;
    } else {
      throw new Exception("product not found, please insert data for " + code);
    }
  }
}
