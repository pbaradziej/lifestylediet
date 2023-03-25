import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/repositories/database_local_repository.dart';
import 'package:lifestylediet/shared_repositories/user_credentials_provider.dart';
import 'package:lifestylediet/utils/uuid_utils.dart';

class DatabaseRepository {
  final UserCredentialsProvider _userCredentialsProvider;

  DatabaseRepository() : _userCredentialsProvider = UserCredentialsProvider();

  Future<void> addMultipleProducts(List<DatabaseProduct> products) async {
    for (final DatabaseProduct product in products) {
      await addProduct(product);
    }
  }

  Future<void> addProduct(DatabaseProduct databaseProduct) async {
    final DatabaseProduct updatedProduct = _getUpdatedProduct(databaseProduct);
    await _addDatabaseProduct(updatedProduct);
    await _setDatabaseProduct(updatedProduct);
  }

  Future<void> updateProduct(DatabaseProduct databaseProduct) async {
    final CollectionReference<Map<String, Object?>> productsCollection = await _getProductsCollection();
    await productsCollection.doc(databaseProduct.id).update(<String, Object?>{
      'amount': databaseProduct.amount,
      'value': databaseProduct.value,
    });
  }

  Future<void> deleteProduct(DatabaseProduct databaseProduct) async {
    final CollectionReference<Map<String, Object?>> productsCollection = await _getProductsCollection();
    await productsCollection.doc(databaseProduct.id).delete();
  }

  Future<List<DatabaseProduct>> getProducts() async {
    final CollectionReference<Map<String, Object?>> productsCollection = await _getProductsCollection();
    return productsCollection.get().then(_getProductDocuments);
  }

  DatabaseProduct _getUpdatedProduct(DatabaseProduct databaseProduct) {
    final String uuid = UuidUtils.getUuid();
    return databaseProduct.copyWith(id: uuid);
  }

  Future<void> _addDatabaseProduct(DatabaseProduct databaseProduct) async {
    final DatabaseLocalRepository databaseLocalRepository = DatabaseLocalRepository();
    await databaseLocalRepository.addDatabaseProduct(product: databaseProduct);
  }

  Future<void> _setDatabaseProduct(DatabaseProduct databaseProduct) async {
    final CollectionReference<Map<String, Object?>> productsCollection = await _getProductsCollection();
    final String id = databaseProduct.id;
    final Map<String, Object?> product = databaseProduct.toMap();
    await productsCollection.doc(id).set(product);
  }

  FutureOr<List<DatabaseProduct>> _getProductDocuments(QuerySnapshot<Map<String, dynamic>> productsCollection) async {
    final List<DatabaseProduct> databaseProducts = <DatabaseProduct>[];
    final List<QueryDocumentSnapshot<Map<String, Object?>>> productDocuments = productsCollection.docs;
    for (final QueryDocumentSnapshot<Map<String, Object?>> productData in productDocuments) {
      final DatabaseProduct databaseProduct = _getDateBaseProductFromDocument(productData);
      final bool isAfter7Days = _isAfter7Days(databaseProduct);
      if (!isAfter7Days) {
        databaseProducts.add(databaseProduct);
      } else {
        await deleteProduct(databaseProduct);
      }
    }

    return databaseProducts;
  }

  DatabaseProduct _getDateBaseProductFromDocument(QueryDocumentSnapshot<Map<String, Object?>> productData) {
    final Map<String, Object?> data = productData.data();
    return DatabaseProduct.fromJson(data);
  }

  bool _isAfter7Days(DatabaseProduct databaseProduct) {
    const Duration duration = Duration(days: 7);
    final DateTime dateTime = DateTime.now();
    final DateTime days7fromNow = dateTime.subtract(duration);
    final String date = databaseProduct.date;
    final DateTime productDate = DateTime.tryParse(date) ?? dateTime;

    return days7fromNow.isAfter(productDate);
  }

  Future<CollectionReference<Map<String, Object?>>> _getProductsCollection() async {
    final CollectionReference<Map<String, Object?>> userProductsCollection = _getUserProductsCollection();
    final String parsedUid = await _userCredentialsProvider.readUid();
    final DocumentReference<Map<String, Object?>> userProductsDocument = userProductsCollection.doc(parsedUid);

    return userProductsDocument.collection('PersonalProducts');
  }

  CollectionReference<Map<String, Object?>> _getUserProductsCollection() {
    final FirebaseFirestore instance = FirebaseFirestore.instance;
    return instance.collection('UserProducts');
  }
}
