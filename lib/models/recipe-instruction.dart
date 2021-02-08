class RecipeInstruction {
  final List steps;

  RecipeInstruction({this.steps});

  factory RecipeInstruction.fromJson(Map<String, dynamic> json) {
    return RecipeInstruction(
      steps: json['steps'] as List,
    );
  }
}

class Steps {
  final int number;
  final String step;

  Steps({this.number, this.step});

  factory Steps.fromJson(Map<String, dynamic> json) {
    return Steps(
      number: json['number'] as int,
      step: json['step'] as String,
    );
  }
}
