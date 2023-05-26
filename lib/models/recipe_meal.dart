class RecipeMeal {
  final int id;
  final String title;
  final String image;

  RecipeMeal({
    required this.id,
    required this.title,
    required this.image,
  });

  factory RecipeMeal.fromJson(final Map<String, Object?> json) {
    return RecipeMeal(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String? ?? '',
    );
  }
}
