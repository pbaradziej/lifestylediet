import 'dart:async';

import 'package:http/http.dart' as http;

class ProductProvider {
  static const String NUTRITIONIX_APP_ID = '383e26e4';
  static const String NUTRITIONIX_APP_KEY = '5e3e48a2c63e8ca97a85881cbe1766ad';
  static const Map<String, String> HEADERS = <String, String>{
    'x-app-id': NUTRITIONIX_APP_ID,
    'x-app-key': NUTRITIONIX_APP_KEY,
    'x-remote-user-id': '0'
  };
  static const String URL_SEARCH_ITEM = 'https://trackapi.nutritionix.com/v2/search/item';
  static const String URL_NATURAL_SEARCH = 'https://trackapi.nutritionix.com/v2/natural/nutrients';

  Future<String> getProductFromBarcode(String code) async {
    final String url = '$URL_SEARCH_ITEM?upc=$code&x-app-id=$NUTRITIONIX_APP_ID&x-app-key=$NUTRITIONIX_APP_KEY';
    final Uri lookupUri = Uri.parse(url);
    final http.Response response = await http.get(lookupUri);

    return _getResponse(response);
  }

  Future<String> getProductData(String search) async {
    final Map<String, String> body = <String, String>{
      'query': search,
      'timezone': 'US/Eastern',
    };
    final Uri lookupUri = Uri.parse(URL_NATURAL_SEARCH);
    final http.Response response = await http.post(lookupUri, headers: HEADERS, body: body);

    return _getResponse(response);
  }

  String _getResponse(http.Response response) {
    if (response.statusCode == 200) {
      return response.body;
    }

    return '{}';
  }
}
