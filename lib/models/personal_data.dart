class PersonalData {
  final String sex;
  final String weight;
  final String height;
  final String date;
  final String firstName;
  final String lastName;
  final String activity;
  final String goal;
  final String imagePath;

  PersonalData({
    this.sex = '',
    this.weight = '',
    this.height = '',
    this.date = '',
    this.firstName = '',
    this.lastName = '',
    this.activity = '',
    this.goal = '',
    this.imagePath = '',
  });

  factory PersonalData.fromJson(Map<String, Object?> json) {
    return PersonalData(
      sex: json['sex'] as String,
      weight: json['weight'] as String,
      height: json['height'] as String,
      date: json['date'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      activity: json['activity'] as String,
      goal: json['goal'] as String,
      imagePath: json['imagePath'] as String,
    );
  }

  PersonalData copyWith({
    String? sex,
    String? weight,
    String? height,
    String? date,
    String? firstName,
    String? lastName,
    String? activity,
    String? goal,
    String? imagePath,
  }) {
    return PersonalData(
      sex: sex ?? this.sex,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      date: date ?? this.date,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      activity: activity ?? this.activity,
      goal: goal ?? this.goal,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'sex': sex,
      'weight': weight,
      'height': height,
      'date': date,
      'firstName': firstName,
      'lastName': lastName,
      'activity': activity,
      'goal': goal,
      'imagePath': imagePath,
    };
  }
}
