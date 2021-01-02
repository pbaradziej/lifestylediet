import 'dart:async';
import 'package:lifestylediet/models/barcode.dart';
import 'package:lifestylediet/models/databaseProduct.dart';
import 'package:lifestylediet/providers/product_provider.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class ProductRepository {
  ProductProvider _productProvider = ProductProvider();

  Future<DatabaseProduct> getProduct(String code) async {
    Product resultProduct = await _productProvider.getProductData(code);
    var nutriments = resultProduct.nutriments;
    Nutriments nutrimentsDatabase = new Nutriments(
        nutriments.energyServing ?? -1,
        nutriments.energyKcal100g ?? -1,
        nutriments.carbohydrates ?? -1,
        nutriments.carbohydratesServing ?? -1,
        nutriments.fiber ?? -1,
        nutriments.fiberServing ?? -1,
        nutriments.sugars ?? -1,
        nutriments.sugarsServing ?? -1,
        nutriments.proteins ?? -1,
        nutriments.proteinsServing ?? -1,
        nutriments.fat ?? -1,
        nutriments.fatServing ?? -1,
        nutriments.saturatedFat ?? -1,
        nutriments.saturatedFatServing ?? -1,
        nutriments.salt ?? -1,
        nutriments.saltServing ?? -1);
    DatabaseProduct product = new DatabaseProduct(
        "",
        "",
        1,
        resultProduct.selectedImages[2].url,
        resultProduct.productName,
        "serving",
        nutrimentsDatabase,
        nameEN: resultProduct.productNameEN,
        nameDE: resultProduct.productNameDE,
        nameFR: resultProduct.productNameFR);
    return product;
    }

    Future getSearchProducts(String search) async {
      search = search.replaceAll(' ', '-');
      List<Code> barcodeList = await _productProvider.searchResultBarcode(search);
      return barcodeList;
    }
}
