import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/models/personal_data.dart';
import 'package:lifestylediet/models/weight_progress.dart';
import 'package:lifestylediet/shared_repositories/user_credentials_provider.dart';

class DatabaseUserRepository {
  final String? uid;
  final UserCredentialsProvider _userCredentialsProvider;

  DatabaseUserRepository({
    this.uid,
  }) : _userCredentialsProvider = UserCredentialsProvider();

  Future<void> addUserPersonalData({required final PersonalData personalData}) async {
    await addUserWeight(weight: personalData.weight);
    await _addPersonalData(personalData);
  }

  Future<void> addUserWeight({required final String weight}) async {
    await _updatePersonalData(weight);
    await _setPersonalWeight(weight);
  }

  Future<void> updateProfileData(final PersonalData personalData) async {
    final DocumentReference<Map<String, Object?>> personalDataDocument = await _getDocument('PersonalData');
    final Map<String, Object?> mappedPersonalData = personalData.toMap();
    await personalDataDocument.update(mappedPersonalData);
  }

  Future<void> updatePlan(final String goal) async {
    final DocumentReference<Map<String, Object?>> personalDataDocument = await _getDocument('PersonalData');
    await personalDataDocument.update(<String, Object>{'goal': goal});
  }

  Future<PersonalData> getUserPersonalData() async {
    final DocumentReference<Map<String, Object?>> personalDataDocument = await _getDocument('PersonalData');
    final Future<DocumentSnapshot<Map<String, Object?>>> personalData = personalDataDocument.get();

    return personalData.then(_getPersonalData);
  }

  Future<void> updateImage(final String imagePath) async {
    final DocumentReference<Map<String, Object?>> personalDataDocument = await _getDocument('PersonalData');
    await personalDataDocument.update(<String, Object>{'imagePath': imagePath});
  }

  Future<List<WeightProgress>> getUserWeightData() async {
    final CollectionReference<Map<String, Object?>> personalWeightCollection = await _getPersonalWeightCollection();
    final Future<QuerySnapshot<Map<String, Object?>>> personalWeight = personalWeightCollection.get();

    return personalWeight.then(_getWeightProgress);
  }

  Future<void> _updatePersonalData(final String weight) async {
    final DocumentReference<Map<String, Object?>> personalDataDocument = await _getDocument('PersonalData');
    await personalDataDocument.update(<String, Object>{'weight': weight});
  }

  Future<void> _setPersonalWeight(final String weight) async {
    final String date = _getDateNow();
    final DocumentReference<Map<String, Object?>> personalWeightDocument = await _getPersonalDataDocument(date);
    await personalWeightDocument.set(<String, Object>{
      'weight': weight,
      'date': date,
    });
  }

  String _getDateNow() {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateTime dateTime = DateTime.now();

    return dateFormat.format(dateTime);
  }

  Future<DocumentReference<Map<String, Object?>>> _getPersonalDataDocument(final String date) async {
    final CollectionReference<Map<String, Object?>> personalWeightCollection = await _getPersonalWeightCollection();
    return personalWeightCollection.doc(date);
  }

  Future<void> _addPersonalData(final PersonalData personalData) async {
    final DocumentReference<Map<String, Object?>> personalDataDocument = await _getDocument('PersonalData');
    final Map<String, Object?> mappedPersonalData = personalData.toMap();
    await personalDataDocument.set(mappedPersonalData);
  }

  FutureOr<PersonalData> _getPersonalData(final DocumentSnapshot<Object?> result) {
    final Map<String, Object?>? data = result.data() as Map<String, Object?>?;
    if (data != null) {
      return PersonalData.fromJson(data);
    }

    return PersonalData();
  }

  Future<CollectionReference<Map<String, Object?>>> _getPersonalWeightCollection() async {
    final DocumentReference<Map<String, Object?>> weightDocument = await _getDocument('Weight');
    return weightDocument.collection('personalWeight');
  }

  Future<DocumentReference<Map<String, Object?>>> _getDocument(final String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final CollectionReference<Map<String, Object?>> collectionReference = firebaseFirestore.collection(collection);
    final String userUid = await _getUid();

    return collectionReference.doc(userUid);
  }

  Future<String> _getUid() async {
    final String userUid = await _userCredentialsProvider.readUid();
    return uid ?? userUid;
  }

  FutureOr<List<WeightProgress>> _getWeightProgress(final QuerySnapshot<Map<String, Object?>> personalWeight) {
    final List<WeightProgress> weightProgressList = <WeightProgress>[];
    final List<QueryDocumentSnapshot<Map<String, Object?>>> personalWeightDocs = personalWeight.docs;
    for (final QueryDocumentSnapshot<Map<String, Object?>> weight in personalWeightDocs) {
      final Map<String, Object?> weightData = weight.data();
      final WeightProgress weightProgress = WeightProgress.fromJson(weightData);
      weightProgressList.add(weightProgress);
    }

    return weightProgressList;
  }
}
