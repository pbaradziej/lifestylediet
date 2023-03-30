import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/cubits/recipe/recipe_cubit.dart';
import 'package:lifestylediet/models/recipe.dart';
import 'package:lifestylediet/models/recipe_meal.dart';
import 'package:lifestylediet/screens/detail/recipe_details_screen.dart';
import 'package:lifestylediet/screens/loading_screens.dart';
import 'package:lifestylediet/styles/app_text_styles.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late RecipeCubit recipeCubit;
  late TextEditingController searchController;
  late List<RecipeMeal> recipes;

  @override
  void initState() {
    super.initState();
    recipeCubit = context.read();
    searchController = TextEditingController();
    recipeCubit.initializeRecipeData();
  }

  @override
  Widget build(BuildContext context) {
    recipes = context.select<RecipeCubit, List<RecipeMeal>>(getMealRecipes);
    return BlocBuilder<RecipeCubit, RecipeState>(
      builder: builder,
    );
  }

  List<RecipeMeal> getMealRecipes(RecipeCubit cubit) {
    final RecipeState state = cubit.state;
    return state.recipes;
  }

  Widget builder(BuildContext context, RecipeState state) {
    final RecipeStatus status = state.status;
    if (status == RecipeStatus.loaded) {
      return recipesScreen();
    } else if (status == RecipeStatus.details) {
      detailsNavigator(state.recipe!);
    }

    return loadingScreen();
  }

  Widget recipesScreen() {
    return Column(
      children: <Widget>[
        searchField(),
        getRecipeList(),
      ],
    );
  }

  Widget searchField() {
    return TextFormFieldComponent(
      searchField: true,
      controller: searchController,
      hintText: 'Search recipes...',
      onEditingComplete: getRecipes,
      onFieldSubmitted: (_) => getRecipes(),
      suffixIcon: IconButton(
        icon: Icon(
          Icons.search,
          color: defaultBorderColor,
        ),
        onPressed: getRecipes,
      ),
      textInputAction: TextInputAction.search,
    );
  }

  Widget getRecipeList() {
    if (recipes.isNotEmpty) {
      return recipeList();
    }

    return emptyScreen();
  }

  Expanded recipeList() {
    return Expanded(
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          return showRecipes(index);
        },
      ),
    );
  }

  void getRecipes() async {
    setState(() {
      final String recipeName = searchController.text;
      recipeCubit.searchRecipes(recipeName);
      FocusScope.of(context).unfocus();
    });
  }

  Widget showRecipes(int index) {
    final RecipeMeal recipe = recipes[index];
    return Container(
      child: Card(
        child: InkWell(
          onTap: () => onTap(index),
          child: Column(
            children: <Widget>[
              Image.network(recipe.image),
              recipeTitle(recipe),
            ],
          ),
        ),
      ),
    );
  }

  void onTap(int index) {
    recipeCubit.showRecipeDetails(index);
  }

  void detailsNavigator(Recipe recipe) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => detailsBuilder(recipe),
      ),
    );
  }

  Widget detailsBuilder(Recipe recipe) {
    return BlocProvider<ProductCubit>.value(
      value: context.read(),
      child: RecipeDetailsScreen(
        recipe: recipe,
      ),
    );
  }

  Widget recipeTitle(RecipeMeal recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        recipe.title,
        style: subTitleAddScreenStyle,
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget emptyScreen() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.folder_off_outlined,
            size: 85,
              color: defaultBorderColor,
            ),
            Text(
              'Nie znaleziono żadnych przepisów\no tej nazwie',
              textAlign: TextAlign.center,
              softWrap: true,
              style: AppTextStyle.titleLarge(context)?.copyWith(color: defaultBorderColor),
            ),
          ],
        ),
      ),
    );
  }
}
