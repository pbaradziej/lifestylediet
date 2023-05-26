import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/database_product.dart';

class DatabaseLocalRepository {
  Future<void> addDatabaseProduct({required final DatabaseProduct product}) async {
    final CollectionReference<Map<String, Object?>> mealData = _getDatabaseProductsCollection();
    final Map<String, Object?> mappedProduct = product.toMap();
    await mealData.doc(product.name).set(mappedProduct);
  }

  Future<List<DatabaseProduct>> getDatabaseData() async {
    final CollectionReference<Map<String, Object?>> databaseProductsCollection = _getDatabaseProductsCollection();
    final List<DatabaseProduct> databaseList = <DatabaseProduct>[];

    final Future<QuerySnapshot<Map<String, Object?>>> databaseProducts = databaseProductsCollection.get();
    await databaseProducts.then((final QuerySnapshot<Map<String, Object?>> querySnapshot) {
      querySnapshot.docs.forEach((final QueryDocumentSnapshot<Map<String, Object?>> result) async {
        final Map<String, Object?> data = result.data();
        final DatabaseProduct databaseProduct = DatabaseProduct.fromJson(data);
        databaseList.add(databaseProduct);
      });
    });

    return databaseList;
  }

  CollectionReference<Map<String, Object?>> _getDatabaseProductsCollection() {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return firebaseFirestore.collection('DatabaseProducts');
  }
}
