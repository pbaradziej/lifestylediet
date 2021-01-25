import 'package:http/http.dart' as http;
import 'dart:async';

class ProductProvider {
  static const String NutritionixAppID = "383e26e4";
  static const String NutritionixAppKey = "efbeed5ddee5cd9f15afc47f4e5238c5";
  static const Map<String, String> HEADERS = {
    'x-app-id': NutritionixAppID,
    'x-app-key': NutritionixAppKey,
    'x-remote-user-id': "0"
  };

  static const URL_SEARCH_ITEM =
      "https://trackapi.nutritionix.com/v2/search/item";
  static const String URL_NATURAL_SEARCH =
      "https://trackapi.nutritionix.com/v2/natural/nutrients";

  Future getProductFromBarcode(String code) async {
    http.Response response = await http.get(URL_SEARCH_ITEM +
        "?upc=$code&x-app-id=$NutritionixAppID&x-app-key=$NutritionixAppKey");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Product not found');
    }
  }

  Future getProductData(String search) async {
    Map<String, String> body = {"query": search, "timezone": "US/Eastern"};
    http.Response response =
        await http.post(URL_NATURAL_SEARCH, headers: HEADERS, body: body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Product not found');
    }
  }
}
