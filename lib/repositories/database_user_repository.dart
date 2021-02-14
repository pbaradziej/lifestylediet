import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';

class DatabaseUserRepository {
  String uid;

  DatabaseUserRepository({this.uid});

  Future addUserPersonalData({PersonalData personalData}) async {
    final CollectionReference personal =
        FirebaseFirestore.instance.collection('PersonalData');

    return await personal.doc(uid).set({
      'sex': personalData.sex,
      'weight': personalData.weight,
      'height': personalData.height,
      'date': personalData.date,
      'firstName': personalData.firstName,
      'lastName': personalData.lastName,
      'activity': personalData.activity,
      'goal': personalData.goal,
    });
  }

  Future addUserWeight({String weight}) async {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    String strDate = dateFormat.format(DateTime.now());

    final CollectionReference weightData =
        FirebaseFirestore.instance.collection('Weight');

    final CollectionReference personalDatabaseUpdate =
        FirebaseFirestore.instance.collection('PersonalData');

    await personalDatabaseUpdate.doc(uid).update({
      'weight': weight,
    });

    return await weightData
        .doc(uid)
        .collection('personalWeight')
        .doc(strDate)
        .set({
      'weight': weight,
      'date': strDate,
    });
  }

  Future updatePlan(String goal) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection('PersonalData');

    return await mealData.doc(uid).update({
      'goal': goal,
    });
  }

  Future updateProfileData(PersonalData personalData) async {
    final CollectionReference personalDatabase =
        FirebaseFirestore.instance.collection('PersonalData');

    return await personalDatabase.doc(uid).update({
      'sex': personalData.sex,
      'weight': personalData.weight,
      'height': personalData.height,
      'date': personalData.date,
      'firstName': personalData.firstName,
      'lastName': personalData.lastName,
      'activity': personalData.activity,
    });
  }

  Future getUserPersonalData() async {
    final CollectionReference personalDatabase =
        FirebaseFirestore.instance.collection('PersonalData');
    PersonalData personalData;

    await personalDatabase.doc(uid).get().then((result) {
      if(result.data() != null) {
        personalData = PersonalData.fromJson(result.data());
      } else {
        return null;
      }
    });
    return personalData;
  }

  Future getUserWeightData() async {
    final CollectionReference personalDatabase =
        FirebaseFirestore.instance.collection('Weight');
    List<WeightProgress> weightProgressList = [];
    WeightProgress weightProgress;

    await personalDatabase
        .doc(uid)
        .collection('personalWeight')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        weightProgress = WeightProgress.fromJson(result.data());
        weightProgressList.add(weightProgress);
      });
    });
    return weightProgressList;
  }
}
