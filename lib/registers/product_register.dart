import 'package:lifestylediet/models/database_product.dart';

class ProductRegister {
  final List<DatabaseProduct> _products;

  ProductRegister() : _products = <DatabaseProduct>[];

  void addProduct(final DatabaseProduct product) {
    _products.add(product);
  }

  void addProducts(final List<DatabaseProduct> products) {
    _products.addAll(products);
  }

  void updateProduct(final DatabaseProduct product) {
    final String productId = product.id;
    final int productIndex = _products.indexWhere((final DatabaseProduct product) => product.id == productId);
    _products[productIndex] = product;
  }

  void deleteProduct(final DatabaseProduct product) {
    _products.remove(product);
  }

  void clearProducts() {
    _products.clear();
  }

  List<DatabaseProduct> getProducts() {
    return _products;
  }
}
