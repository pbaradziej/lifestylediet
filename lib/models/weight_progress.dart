class WeightProgress {
  final String weight;
  final String date;

  WeightProgress(
    this.weight,
    this.date,
  );

  factory WeightProgress.fromJson(Map<String, dynamic> json) {
    return WeightProgress(
      json['weight'] as String,
      json['date'] as String,
    );
  }
}
