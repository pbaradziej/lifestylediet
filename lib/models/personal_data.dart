import 'dart:io';

class PersonalData {
  String sex;
  String weight;
  String height;
  String date;
  String firstName;
  String lastName;
  String activity;
  String goal;
  String imagePath;

  PersonalData(
    this.sex,
    this.weight,
    this.height,
    this.date,
    this.firstName,
    this.lastName,
    this.activity,
    this.goal,
    this.imagePath,
  );

  factory PersonalData.fromJson(Map<String, dynamic> json) {
    return PersonalData(
      json['sex'] as String,
      json['weight'] as String,
      json['height'] as String,
      json['date'] as String,
      json['firstName'] as String,
      json['lastName'] as String,
      json['activity'] as String,
      json['goal'] as String,
      json['imagePath'] as String,
    );
  }

  void setGoal(String value) {
    goal = value;
  }

  void setActivity(String value) {
    activity = value;
  }

  void setLastName(String value) {
    lastName = value;
  }

  void setFirstName(String value) {
    firstName = value;
  }

  void setDate(String value) {
    date = value;
  }

  void setHeight(String value) {
    height = value;
  }

  void setWeight(String value) {
    weight = value;
  }

  void setSex(String value) {
    sex = value;
  }

  void setImagePath(String value) {
    imagePath = value;
  }
}
