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

  Future<void> initializeProducts() async {
    _emitLoadingState();
    _productRegister.clearProducts();
    final List<DatabaseProduct> products = await _databaseRepository.getProducts();
    _productRegister.addProducts(products);
    await _emitProductState();
  }

  Future<void> addProduct(final DatabaseProduct product) async {
    _emitLoadingState();
    _productRegister.addProduct(product);
    await _databaseRepository.addProduct(product);
    await _emitProductState();
  }

  Future<void> addMultipleProducts(final List<DatabaseProduct> products) async {
    _emitLoadingState();
    _productRegister.addProducts(products);
    await _databaseRepository.addMultipleProducts(products);
    await _emitProductState();
  }

  Future<void> listProducts() async {
    final List<DatabaseProduct> products = await _databaseLocalRepository.getDatabaseData();
    await _emitProductState(
      status: ProductStatus.listProducts,
      products: products,
    );
  }

  Future<void> searchProducts(final String search) async {
    _emitLoadingState();
    final List<DatabaseProduct> searchedProducts = await _productRepository.getSearchProducts(search);
    if (searchedProducts.isNotEmpty) {
      await _emitProductState(
        status: ProductStatus.filtered,
        products: searchedProducts,
      );
    } else {
      await _emitProductState(
        status: ProductStatus.loaded,
        message: 'Product not found!',
      );
    }
  }

  Future<void> scanProduct(final String barcode) async {
    _emitLoadingState();
    final DatabaseProduct? databaseProduct = await _productRepository.getProductFromBarcode(barcode);
    if (databaseProduct != null) {
      await _emitProductState(
        status: ProductStatus.filtered,
        products: <DatabaseProduct>[
          databaseProduct,
        ],
      );
    } else {
      await _emitProductState(
        status: ProductStatus.loaded,
        message: barcode != '-1' ? 'Product not found!' : '',
      );
    }
  }

  Future<void> deleteProduct(final DatabaseProduct product) async {
    _emitLoadingState();
    _productRegister.deleteProduct(product);
    await _databaseRepository.deleteProduct(product);
    await _emitProductState();
  }

  Future<void> updateProduct(final DatabaseProduct product) async {
    _emitLoadingState();
    _productRegister.updateProduct(product);
    await _databaseRepository.updateProduct(product);
    await _emitProductState();
  }

  void _emitLoadingState() {
    final ProductState loadingState = state.copyWith(
      status: ProductStatus.loading,
    );
    emit(loadingState);
  }

  Future<void> _emitProductState({
    final ProductStatus? status,
    final List<DatabaseProduct>? products,
    final String message = '',
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
