class PersonalData {
  final String sex;
  String weight;
  String height;
  final String date;
  final String firstName;
  final String lastName;
  String activity;
  String goal;

  PersonalData(
    this.sex,
    this.weight,
    this.height,
    this.date,
    this.firstName,
    this.lastName,
    this.activity,
    this.goal,
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
    );
  }
}
