import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/utils.dart';

class DatabaseLocalRepository {
  String uid;
  Utils utils = new Utils();

  DatabaseLocalRepository({this.uid});

  Future addDatabaseProduct({DatabaseProduct product}) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection("DatabaseProducts");
    DatabaseProduct databaseProduct =
        utils.setProductValues(product, "currentDate", "meal", 1, "serving");
    Map<String, dynamic> productMap = utils.setProduct(databaseProduct);

    return await mealData.doc(product.name).set(productMap);
  }

  Future getDatabaseData() async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection("DatabaseProducts");
    DatabaseProduct databaseProduct;
    List<DatabaseProduct> databaseList = [];

    await mealData.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        databaseProduct = DatabaseProduct.fromJson(result.data());
        databaseList.add(databaseProduct);
      });
    });
    return databaseList;
  }
}
