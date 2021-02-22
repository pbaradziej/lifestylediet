import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class DatabaseRepository {
  String uid;
  DatabaseLocalRepository _databaseLocalRepository;
  Utils utils = new Utils();

  DatabaseRepository({this.uid});

  Future addProduct({DatabaseProduct product}) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection('UserProducts');
    _databaseLocalRepository = new DatabaseLocalRepository(uid: uid);
    Map<String, dynamic> productMap = utils.setProduct(product);
    await _databaseLocalRepository.addDatabaseProduct(product: product);

    return await mealData
        .doc(uid)
        .collection('PersonalProducts')
        .doc(productMap["id"])
        .set(productMap);
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
