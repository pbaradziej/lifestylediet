import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final HomeBloc homeBloc;
  final Recipe recipe;

  const RecipeDetailsScreen({Key key, this.homeBloc, this.recipe})
      : super(key: key);

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  Recipe _recipe;
  HomeBloc _homeBloc;
  TextEditingController _amountController;
  TextEditingController _mealController;

  @override
  void initState() {
    super.initState();
    _homeBloc = widget.homeBloc;
    _recipe = widget.recipe;
    _amountController = TextEditingController(text: '1');
    _mealController = TextEditingController(text: 'Breakfast');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
        },
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            _titleBox(),
            _caloriesCard(),
            _ingredientsCard(),
            _instructionCard(),
          ],
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: backgroundColor,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: defaultColor,
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          }),
      actions: [_newButtons()],
    );
  }

  Widget _newButtons() {
    return FlatButton(
      onPressed: () {
        _alertDialog(context);
        //Navigator.pop(context);
      },
      child: Text(
        "Dodaj Produkt",
        style: labelStyle,
      ),
    );
  }

  Future _alertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Dodaj produkt"),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _amountField(),
                  _mealDropdownButton(),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Anuluj'),
                ),
                FlatButton(
                    child: Text('Zapisz'),
                    onPressed: () {
                      _homeBloc.add(AddRecipeProduct(
                        _recipe,
                        _amountController.text,
                        _mealController.text,
                      ));
                      setState(() {});
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _mealDropdownButton() {
    return DropdownComponent(
      alertDialog: true,
      controller: _mealController,
      label: "Meal",
      halfScreen: true,
      values: ["Breakfast", "Dinner", "Supper"],
    );
  }

  Widget _amountField() {
    return NumericComponent(
      alertDialog: true,
      initialValue: _amountController.text,
      controller: _amountController,
      label: "Amount",
      halfScreen: true,
    );
  }

  Widget _titleBox() {
    return SizedBox(
      height: 150,
      child: Container(
        width: double.infinity,
        color: backgroundColor,
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Text(
                  (widget.recipe.recipeInformation.spoonacularScore.floor() /
                              10)
                          .toString() +
                      '/10',
                  style: titleAddScreenStyle,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellowAccent,
                  size: 30,
                )
              ],
            ),
            Row(
              children: [
                SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.recipe.recipeInformation.title,
                    style: titleAddScreenStyle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget _caloriesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.network(_recipe.recipeInformation.image),
              ),
            ),
            Expanded(flex: 1, child: _nutrition()),
          ],
        ),
      ),
    );
  }

  Widget _nutrition() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _nutriments('Calories', _recipe.recipeNutrition.calories),
              _nutriments('Protein', _recipe.recipeNutrition.protein),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _nutriments('Carbs', _recipe.recipeNutrition.carbs),
              _nutriments('Fats', _recipe.recipeNutrition.fat),
            ],
          ),
        ],
      ),
    );
  }

  Widget _nutriments(String text, String nutrients) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: '$text\n',
            style: defaultTextStyle,
          ),
          TextSpan(
            text: nutrients,
            style: subTitleAddScreenStyle,
          ),
        ],
      ),
    );
  }

  Widget _ingredientsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Ready in ' +
                        _recipe.recipeInformation.readyInMinutes.toString() +
                        'minutes',
                    style: defaultProfileTextStyle),
                Text(
                    'Servings: ' +
                        _recipe.recipeInformation.servings.toString(),
                    style: defaultProfileTextStyle)
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Recipe Ingredients',
              style: subTitleAddScreenStyle,
            ),
            _ingredientsList(),
          ],
        ),
      ),
    );
  }

  Widget _ingredientsList() {
    List ingredients = _recipe.recipeInformation.extendedIngredients;
    Set ingredientsSet = ingredients.map((element) => element["id"]).toSet();
    ingredients.retainWhere((element) => ingredientsSet.remove(element["id"]));

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 5),
      shrinkWrap: true,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        return _showIngredients(ingredients, index);
      },
    );
  }

  Widget _showIngredients(List ingredients, int index) {
    var ingredient = ingredients[index];
    ExtendedIngredients extendedIngredients =
        ExtendedIngredients.fromJson(ingredient);

    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(extendedIngredients.name, style: defaultProfileTextStyle),
          Text(
            extendedIngredients.amount.toStringAsFixed(1).toString() +
                ' ' +
                extendedIngredients.unit,
            style: defaultProfileTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _instructionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Text(
              'Recipe Instructions',
              style: subTitleAddScreenStyle,
            ),
            _instructionsList(),
          ],
        ),
      ),
    );
  }

  Widget _instructionsList() {
    List steps = _recipe.recipeInstruction.steps;

    return ListView.builder(
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 5),
      shrinkWrap: true,
      itemCount: steps.length,
      itemBuilder: (context, index) {
        return _showSteps(steps, index);
      },
    );
  }

  Widget _showSteps(List steps, int index) {
    var stepJson = steps[index];
    Steps step = Steps.fromJson(stepJson);

    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Text(step.number.toString() + '. ' + step.step,
          style: defaultProfileTextStyle),
    );
  }
}
