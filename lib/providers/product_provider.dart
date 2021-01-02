import 'dart:convert';
import 'package:lifestylediet/models/barcode.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ProductProvider {
  static const String URI_SCHEME = "https://";
  static const String URI_HOST = "world.openfoodfacts.org";
  static const String PREFIX = "/cgi/search.pl?search_terms=";
  static const String POSTFIX =
      "&search_simple=1&action=process&json=1&page_size=5";

  Future searchResultBarcode(String search) async {
    var productUrl = URI_SCHEME + URI_HOST + PREFIX + search + POSTFIX;
    final response = await http.get(productUrl);
    Barcode barcode = Barcode.fromJson(jsonDecode(response.body));
    return barcode.codeList;
  }

  Future<Product> getProductData(String code) async {
    ProductQueryConfiguration configuration = ProductQueryConfiguration(code,
        language: OpenFoodFactsLanguage.WORLD,
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
