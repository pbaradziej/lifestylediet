import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/models.dart';

class DatabaseUserRepository {
  String uid;

  DatabaseUserRepository({this.uid});

  Future addUserPersonalData({PersonalData personalData}) async {
    final CollectionReference personal =
        FirebaseFirestore.instance.collection(uid);

    return await personal.doc('PersonalData').set({
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
        FirebaseFirestore.instance.collection(uid + "WT");

    final CollectionReference personalDatabaseUpdate =
        FirebaseFirestore.instance.collection(uid + "PD");

    await personalDatabaseUpdate.doc('PersonalData').update({
      'weight': weight,
    });

    return await weightData.doc(strDate).set({
      'weight': weight,
      'date': strDate,
    });
  }

  Future updatePlan(String goal) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection(uid + "PD");

    return await mealData.doc('PersonalData').update({
      'goal': goal,
    });
  }

  Future updateProfileData(PersonalData personalData) async {
    final CollectionReference mealData =
        FirebaseFirestore.instance.collection(uid + "PD");

    return await mealData.doc('PersonalData').update({
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
    String uidPD = uid + "PD";
    final CollectionReference personalDatabase =
        FirebaseFirestore.instance.collection(uidPD);
    PersonalData personalData;

    await personalDatabase.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        personalData = PersonalData.fromJson(result.data());
      });
    });
    return personalData;
  }

  Future getUserWeightData() async {
    String uidWT = uid + "WT";
    final CollectionReference personalDatabase =
        FirebaseFirestore.instance.collection(uidWT);
    List<WeightProgress> weightProgressList = [];
    WeightProgress weightProgress;

    await personalDatabase.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        weightProgress = WeightProgress.fromJson(result.data());
        weightProgressList.add(weightProgress);
      });
    });
    return weightProgressList;
  }

  setUid(String uid) {
    this.uid = uid;
  }
}
