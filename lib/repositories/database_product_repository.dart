import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

class DatabaseRepository {
  String uid;
  DatabaseLocalRepository _databaseLocalRepository;

  DatabaseRepository({this.uid});

  Future addProduct({
    String meal,
    DatabaseProduct product,
    double amount,
    String value,
    String currentDate,
  }) async {
    String uuid = Uuid().v4().toString();
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection('UserProducts');
    _databaseLocalRepository = new DatabaseLocalRepository(uid: uid);
    await _databaseLocalRepository.addDatabaseProduct(product: product);

    return await mealData
        .doc(uid)
        .collection('PersonalProducts')
        .doc(uuid)
        .set({
      'id': uuid,
      'date': currentDate,
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
        FirebaseFirestore.instance.collection('UserProducts');

    return await mealData
        .doc(uid)
        .collection('PersonalProducts')
        .doc(databaseProduct.id)
        .update({
      'amount': databaseProduct.amount,
      'value': databaseProduct.value,
    });
  }

  Future deleteProduct(DatabaseProduct databaseProduct) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection('UserProducts');

    return await mealData
        .doc(uid)
        .collection('PersonalProducts')
        .doc(databaseProduct.id)
        .delete();
  }

  Future getProducts() async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection('UserProducts');
    DatabaseProduct databaseProduct;
    List<DatabaseProduct> databaseList = [];

    await mealData
        .doc(uid)
        .collection('PersonalProducts')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) async {
        databaseProduct = DatabaseProduct.fromJson(result.data());
        DateTime days7fromNow = DateTime.now().subtract(Duration(days: 7));
        DateTime productDate = DateTime.parse(databaseProduct.date);
        if (!days7fromNow.isAfter(productDate)) {
          databaseList.add(databaseProduct);
        } else {
          await deleteProduct(databaseProduct);
        }
      });
    });
    return databaseList;
  }
}
