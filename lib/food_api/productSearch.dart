import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lifestylediet/models/barcode.dart';
import 'file:///C:/Users/Pawel/AndroidStudioProjects/lifestylediet/lib/food_api/food.dart';
import 'package:openfoodfacts/model/Product.dart';

class ProductSearch {
  static const String URI_SCHEME = "https://";
  static const String URI_HOST = "world.openfoodfacts.org";
  static const String PREFIX = "/cgi/search.pl?search_terms=";
  static const String POSTFIX =
      "&search_simple=1&action=process&json=1&page_size=5";

  Food _food = Food();

  Future searchResultBarcode(String search) async {
    var productUrl = URI_SCHEME + URI_HOST + PREFIX + search + POSTFIX;
    final response = await http.get(productUrl);
    Barcode barcode = Barcode.fromJson(jsonDecode(response.body));
    return barcode.codeList;
  }

  Future searchProducts(String search) async {
    List<Product> _products = new List();
    search = search.replaceAll(' ', '-');
    List<Code> barcodeList = await searchResultBarcode(search);
    for (Code barcode in barcodeList) {
      Product product = await _food.getProduct(barcode.code);
      _products.add(product);
      if (_products.length == 5) {
        return _products;
      }
    }
    return _products;
  }
}
