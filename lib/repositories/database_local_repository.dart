import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:uuid/uuid.dart';

class DatabaseLocalRepository {
  String uid;

  DatabaseLocalRepository({this.uid});

  Future addDatabaseProduct({
    DatabaseProduct product,
  }) async {
    String uuid = Uuid().v4().toString();
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection("DatabaseProducts");

    return await mealData.doc(product.name).set({
      'id': uuid,
      'date': "currentDate",
      'meal': "meal",
      'name': product.name,
      'image': product.image,
      'amount': 1.0,
      'value': "serving",
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
