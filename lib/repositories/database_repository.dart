import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/databaseProduct.dart';
import 'package:openfoodfacts/model/Product.dart';
import 'package:uuid/uuid.dart';

class DatabaseRepository {
  final String uid;

  DatabaseRepository({this.uid});

  Future addUserData(
      {String meal, Product product, double amount, String value}) async {
    String uuid = Uuid().v4().toString();
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection(uid);

    return await mealData.doc(uuid).set({
      'id': uuid,
      'meal': meal,
      'name': product.productName,
      'image': product.selectedImages[1].url,
      'amount': amount,
      'value': value,
      'nutriments': {
        'caloriesPerServing': product.nutriments.energyServing,
        'caloriesPer100g': product.nutriments.energyKcal100g,
        'carbs': product.nutriments.carbohydrates,
        'carbsPerServing': product.nutriments.carbohydratesServing,
        'fiber': product.nutriments.fiber,
        'fiberPerServing': product.nutriments.fiberServing,
        'sugars': product.nutriments.sugars,
        'sugarsPerServing': product.nutriments.sugarsServing,
        'protein': product.nutriments.proteins,
        'proteinPerServing': product.nutriments.proteinsServing,
        'fats': product.nutriments.fat,
        'fatsPerServing': product.nutriments.fatServing,
        'saturatedFats': product.nutriments.saturatedFat,
        'saturatedFatsPerServing': product.nutriments.saturatedFatServing,
        'salt': product.nutriments.salt,
        'saltPerServing': product.nutriments.saltServing
      }
    });
  }

  Future updateProduct(DatabaseProduct databaseProduct) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection(uid);

    return await mealData.doc(databaseProduct.id).update({
      'amount': databaseProduct.amount,
      'value': databaseProduct.value,
    });
  }

  Future deleteProduct(DatabaseProduct databaseProduct) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection(uid);

    return await mealData.doc(databaseProduct.id).delete();
  }

  Future getUserData() async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection(uid);
    DatabaseProduct databaseProduct;
    List<DatabaseProduct> databaseList = [];

    await mealData.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        databaseProduct = DatabaseProduct.fromJson(result.data());
        databaseList.add(databaseProduct);
      });
    });
    return databaseList;
  }
}
