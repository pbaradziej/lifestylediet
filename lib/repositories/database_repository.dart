import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/databaseProduct.dart';
import 'package:uuid/uuid.dart';

class DatabaseRepository {
  final String uid;

  DatabaseRepository({this.uid});

  Future addUserData(
      {String meal, DatabaseProduct product, double amount, String value}) async {
    String uuid = Uuid().v4().toString();
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection(uid);

    return await mealData.doc(uuid).set({
      'id': uuid,
      'meal': meal,
      'name': product.name,
      'image': product.image,
      'amount': amount,
      'value': value,
      'servingUnit': product.servingUnit,
      'nutriments': {
        'caloriesPer100g': product.nutriments.caloriesPer100g,
        'caloriesPerServing': product.nutriments.caloriesPerServing,
        'carbs': product.nutriments.carbs,
        'carbsPerServing': product.nutriments.carbsPerServing,
        'fiber': product.nutriments.fiber,
        'fiberPerServing': product.nutriments.fiberPerServing,
        'sugars': product.nutriments.sugars,
        'sugarsPerServing': product.nutriments.sugarsPerServing,
        'protein': product.nutriments.protein,
        'proteinPerServing': product.nutriments.proteinPerServing,
        'fats': product.nutriments.fats,
        'fatsPerServing': product.nutriments.fatsPerServing,
        'saturatedFats': product.nutriments.saturatedFats,
        'saturatedFatsPerServing': product.nutriments.saturatedFatsPerServing,
        'cholesterol': product.nutriments.cholesterol,
        'cholesterolPerServing': product.nutriments.cholesterolPerServing,
        'sodium': product.nutriments.sodium,
        'sodiumPerServing': product.nutriments.sodiumPerServing,
        'potassium': product.nutriments.potassium,
        'potassiumPerServing': product.nutriments.potassiumPerServing,
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
