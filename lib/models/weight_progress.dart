class WeightProgress {
  final String weight;
  final String date;

  WeightProgress({
    required this.weight,
    required this.date,
  });

  factory WeightProgress.fromJson(final Map<String, dynamic> json) {
    return WeightProgress(
      weight: json['weight'] as String,
      date: json['date'] as String,
    );
  }
}
