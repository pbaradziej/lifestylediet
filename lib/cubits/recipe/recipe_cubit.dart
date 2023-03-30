import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lifestylediet/models/recipe.dart';
import 'package:lifestylediet/models/recipe_meal.dart';
import 'package:lifestylediet/repositories/recipe_repository.dart';

part 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository _recipeRepository;

  RecipeCubit()
      : _recipeRepository = RecipeRepository(),
        super(const RecipeState(status: RecipeStatus.loading));

  void initializeRecipeData() async {
    final List<RecipeMeal> recipes = await _recipeRepository.getInitialRecipes();
    _emitRecipeState(recipes);
  }

  void searchRecipes(String search) async {
    final List<RecipeMeal> recipes = await _recipeRepository.getRecipes(search);
    _emitRecipeState(recipes);
  }

  void showRecipeDetails(int recipeId) async {
    final RecipeRepository recipeRepository = RecipeRepository();
    final Recipe recipe = await recipeRepository.getRecipe(recipeId);
    final RecipeState updatedState = state.copyWith(
      status: RecipeStatus.details,
      recipe: recipe,
    );
    emit(updatedState);
  }

  void _emitRecipeState(List<RecipeMeal> recipes) {
    final RecipeState state = RecipeState(recipes: recipes, status: RecipeStatus.loaded);
    emit(state);
  }
}
