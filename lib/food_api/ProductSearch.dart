import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lifestylediet/models/barcode.dart';
import 'package:lifestylediet/models/food.dart';
import 'package:openfoodfacts/model/Product.dart';

class ProductSearch {
  static const String URI_SCHEME = "https://";
  static const String URI_HOST = "world.openfoodfacts.org";
  static const String PREFIX = "/cgi/search.pl?search_terms=";
  static const String POSTFIX = "&search_simple=1&action=process&json=1";

  Food _food = Food();

  Future searchResultBarcode(String search) async {
    var productUrl = URI_SCHEME + URI_HOST + PREFIX + search + POSTFIX;
    final response = await http.get(productUrl);
    Barcode barcode = Barcode.fromJson(jsonDecode(response.body));
    print(barcode.codeList[0].code);
    return barcode.codeList;
  }

  Future searchProducts(String search) async {
    List<Product> _products = new List();
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
