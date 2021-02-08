class RecipeMeal {
  final int id;
  final String title;
  final String image;

  RecipeMeal({this.id, this.title, this.image});

  factory RecipeMeal.fromJson(Map<String, dynamic> json) {
    return RecipeMeal(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String,
    );
  }
}
