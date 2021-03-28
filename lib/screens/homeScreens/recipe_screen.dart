import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/repositories/repositories.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'package:lifestylediet/utils/fonts.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key key}) : super(key: key);

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  HomeBloc _homeBloc;
  List<RecipeMeal> _recipes;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _recipes = _homeBloc.recipes;
    return Column(
      children: [
        _searchField(),
        _getRecipeList(),
      ],
    );
  }

  Widget _getRecipeList() {
    return _recipes != null
        ? Expanded(
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return _showRecipes(_recipes, index);
              },
            ),
          )
        : Container();
  }

  Widget _searchField() {
    return TextFormFieldComponent(
      searchField: true,
      controller: _searchController,
      hintText: "Search recipes...",
      onEditingComplete: () => _getRecipes(),
      onFieldSubmitted: (_) => _getRecipes(),
      suffixIcon: IconButton(
        icon: Icon(
          Icons.search,
          color: defaultBorderColor,
        ),
        onPressed: () => _getRecipes(),
      ),
      textInputAction: TextInputAction.search,
    );
  }

  _getRecipes() async {
    setState(() {
      _homeBloc.add(SearchRecipes(_searchController.text));
      FocusScope.of(context).unfocus();
    });
  }

  Widget _showRecipes(List<RecipeMeal> recipes, int index) {
    RecipeMeal recipe = recipes[index];

    return Container(
      child: Card(
        child: InkWell(
          onTap: () => _detailsNavigator(recipe),
          child: Column(
            children: [
              recipe.image != null ? Image.network(recipe.image) : SizedBox(),
              _recipeTitle(recipe),
            ],
          ),
        ),
      ),
    );
  }

  _detailsNavigator(RecipeMeal recipeMeal) async {
    RecipeRepository recipeRepository = new RecipeRepository();
    Recipe recipe = await recipeRepository.getRecipe(recipeMeal.id);
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RecipeDetailsScreen(recipe: recipe, homeBloc: _homeBloc),
      ),
    );
  }

  _recipeTitle(RecipeMeal recipe) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        recipe.title ?? "no info",
        style: subTitleAddScreenStyle,
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}
