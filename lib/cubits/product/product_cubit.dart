import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/builders/meal_builder.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/meal.dart';
import 'package:lifestylediet/registers/product_register.dart';
import 'package:lifestylediet/repositories/database_local_repository.dart';
import 'package:lifestylediet/repositories/database_product_repository.dart';
import 'package:lifestylediet/repositories/product_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final DatabaseRepository _databaseRepository;
  final ProductRepository _productRepository;
  final DatabaseLocalRepository _databaseLocalRepository;
  final ProductRegister _productRegister;

  ProductCubit()
      : _databaseRepository = DatabaseRepository(),
        _productRepository = ProductRepository(),
        _databaseLocalRepository = DatabaseLocalRepository(),
        _productRegister = ProductRegister(),
        super(ProductState(status: ProductStatus.loading));

  void initializeScreen() {
    _emitProductState();
  }

  void initializeProducts() async {
    _emitLoadingState();
    _productRegister.clearProducts();
    final List<DatabaseProduct> products = await _databaseRepository.getProducts();
    _productRegister.addProducts(products);
    _emitProductState();
  }

  Future<void> addProduct(DatabaseProduct product) async {
    _emitLoadingState();
    _productRegister.addProduct(product);
    await _databaseRepository.addProduct(product);
    _emitProductState();
  }

  Future<void> addMultipleProducts(List<DatabaseProduct> products) async {
    _emitLoadingState();
    _productRegister.addProducts(products);
    await _databaseRepository.addMultipleProducts(products);
    _emitProductState();
  }

  void listProducts() async {
    final List<DatabaseProduct> products = await _databaseLocalRepository.getDatabaseData();
    _emitProductState(
      status: ProductStatus.listProducts,
      products: products,
    );
  }

  void searchProducts(String search) async {
    _emitLoadingState();
    final List<DatabaseProduct> searchedProducts = await _productRepository.getSearchProducts(search);
    if (searchedProducts.isNotEmpty) {
      _emitProductState(
        status: ProductStatus.filtered,
        products: searchedProducts,
      );
    } else {
      _emitProductState(
        status: ProductStatus.loaded,
        message: 'Product not found!',
      );
    }
  }

  void scanProduct(String barcode) async {
    _emitLoadingState();
    final DatabaseProduct? databaseProduct = await _productRepository.getProductFromBarcode(barcode);
    if (databaseProduct != null) {
      _emitProductState(
        status: ProductStatus.filtered,
        products: <DatabaseProduct>[
          databaseProduct,
        ],
      );
    } else {
      _emitProductState(
        status: ProductStatus.loaded,
        message: barcode != '-1' ? 'Product not found!' : '',
      );
    }
  }

  void deleteProduct(DatabaseProduct product) async {
    _emitLoadingState();
    _productRegister.deleteProduct(product);
    await _databaseRepository.deleteProduct(product);
    _emitProductState();
  }

  void updateProduct(DatabaseProduct product) async {
    _emitLoadingState();
    _productRegister.updateProduct(product);
    await _databaseRepository.updateProduct(product);
    _emitProductState();
  }

  void _emitLoadingState() {
    final ProductState loadingState = state.copyWith(
      status: ProductStatus.loading,
    );
    emit(loadingState);
  }

  void _emitProductState({
    ProductStatus? status,
    List<DatabaseProduct>? products,
    String message = '',
  }) async {
    final ProductStatus productStatus = status ?? ProductStatus.loaded;
    final List<DatabaseProduct> databaseProducts = products ?? _productRegister.getProducts();
    final MealBuilder mealBuilder = MealBuilder(databaseProducts);
    final ProductState state = ProductState(
      status: productStatus,
      products: databaseProducts,
      meals: mealBuilder.createMeals(),
      message: message,
    );
    emit(state);
  }
}
