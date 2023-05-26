import 'package:lifestylediet/models/recipe_step.dart';

class RecipeInstruction {
  final List<RecipeStep> steps;

  RecipeInstruction({
    required this.steps,
  });

  factory RecipeInstruction.fromJson(final Map<String, Object?> json) {
    final List<Object> steps = json['steps'] as List<Object>;
    final Iterable<RecipeStep> parsedSteps = _getSteps(steps);

    return RecipeInstruction(
      steps: parsedSteps.toList(),
    );
  }

  factory RecipeInstruction.empty() {
    return RecipeInstruction(
      steps: <RecipeStep>[],
    );
  }

  static Iterable<RecipeStep> _getSteps(final List<Object> steps) sync* {
    for (final Object step in steps) {
      yield RecipeStep.fromJson(step as Map<String, Object?>);
    }
  }
}
