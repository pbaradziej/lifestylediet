part of 'recipe_cubit.dart';

enum RecipeStatus {
  loading,
  loaded,
  details,
}

class RecipeState extends Equatable {
  final RecipeStatus status;
  final List<RecipeMeal> recipes;
  final Recipe? recipe;

  const RecipeState({
    required this.status,
    this.recipes = const <RecipeMeal>[],
    this.recipe,
  });

  RecipeState copyWith({
    RecipeStatus? status,
    List<RecipeMeal>? recipes,
    Recipe? recipe,
  }) {
    return RecipeState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      recipe: recipe ?? this.recipe,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        status,
        recipes,
        recipe,
      ];
}
