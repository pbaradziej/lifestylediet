import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/components.dart';
import 'package:lifestylediet/cubits/product/product_cubit.dart';
import 'package:lifestylediet/models/database_product.dart';
import 'package:lifestylediet/models/extended_ingredients.dart';
import 'package:lifestylediet/models/recipe.dart';
import 'package:lifestylediet/models/recipe_step.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';
import 'package:lifestylediet/utils/recipe/recipe_helper.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({
    required this.recipe,
  });

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  late Recipe recipe;
  late TextEditingController amountController;
  late TextEditingController mealController;
  late ProductCubit productCubit;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
    amountController = TextEditingController(text: '1');
    mealController = TextEditingController(text: 'Breakfast');
    productCubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            titleBox(),
            caloriesCard(),
            ingredientsCard(),
            instructionCard(),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
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
        },
      ),
      actions: <Widget>[
        newButtons(),
      ],
    );
  }

  Widget newButtons() {
    return ElevatedButton(
      onPressed: alertDialog,
      child: Text(
        'Add product',
        style: labelStyle,
      ),
    );
  }

  void alertDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add product'),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  amountField(),
                  mealDropdownButton(),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void onPressed() async {
    final DatabaseProduct product = RecipeHelper.getProductFromRecipe(
      recipe: recipe,
      amount: amountController.text,
      meal: mealController.text,
    );
    await productCubit.addProduct(product);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Widget mealDropdownButton() {
    return DropdownComponent(
      alertDialog: true,
      controller: mealController,
      label: 'Meal',
      halfScreen: true,
      values: <String>['Breakfast', 'Dinner', 'Supper'],
    );
  }

  Widget amountField() {
    return NumericComponent(
      alertDialog: true,
      initialValue: amountController.text,
      controller: amountController,
      label: 'Amount',
      halfScreen: true,
    );
  }

  Widget titleBox() {
    return SizedBox(
      height: 150,
      child: Container(
        width: double.infinity,
        color: backgroundColor,
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Text(
                  '${widget.recipe.recipeInformation.spoonacularScore.floor() / 10}/10',
                  style: titleAddScreenStyle,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.yellowAccent,
                  size: 30,
                )
              ],
            ),
            Row(
              children: <Widget>[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.recipe.recipeInformation.title,
                    style: titleAddScreenStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  Widget caloriesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Image.network(recipe.recipeInformation.image),
              ),
            ),
            Expanded(
              child: nutrition(),
            ),
          ],
        ),
      ),
    );
  }

  Widget nutrition() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              nutriments('Calories', recipe.recipeNutrition.calories),
              nutriments('Protein', recipe.recipeNutrition.protein),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              nutriments('Carbs', recipe.recipeNutrition.carbs),
              nutriments('Fats', recipe.recipeNutrition.fat),
            ],
          ),
        ],
      ),
    );
  }

  Widget nutriments(String text, String nutrients) {
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

  Widget ingredientsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Ready in ${recipe.recipeInformation.readyInMinutes}minutes',
                  style: defaultProfileTextStyle,
                ),
                Text(
                  'Servings: ${recipe.recipeInformation.servings}',
                  style: defaultProfileTextStyle,
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Recipe Ingredients',
              style: subTitleAddScreenStyle,
            ),
            ingredientsList(),
          ],
        ),
      ),
    );
  }

  Widget ingredientsList() {
    final List<ExtendedIngredients> extendedIngredients = recipe.recipeInformation.extendedIngredients;
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 5),
      shrinkWrap: true,
      itemCount: extendedIngredients.length,
      itemBuilder: (BuildContext context, int index) {
        return showIngredients(extendedIngredients, index);
      },
    );
  }

  Widget showIngredients(List<ExtendedIngredients> extendedIngredients, int index) {
    final ExtendedIngredients ingredient = extendedIngredients[index];
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            ingredient.name,
            style: defaultProfileTextStyle,
            softWrap: true,
          ),
          Text(
            '${ingredient.amount.toStringAsFixed(1)} ${ingredient.unit}',
            style: defaultProfileTextStyle,
            softWrap: true,
          ),
        ],
      ),
    );
  }

  Widget instructionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: <Widget>[
            Text(
              'Recipe Instructions',
              style: subTitleAddScreenStyle,
            ),
            instructionsList(),
          ],
        ),
      ),
    );
  }

  Widget instructionsList() {
    final List<RecipeStep> steps = recipe.recipeInstruction.steps;

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 5),
      shrinkWrap: true,
      itemCount: steps.length,
      itemBuilder: (BuildContext context, int index) {
        return showSteps(steps, index);
      },
    );
  }

  Widget showSteps(List<RecipeStep> steps, int index) {
    final RecipeStep step = steps[index];
    return Padding(
      padding: const EdgeInsets.all(1.5),
      child: Text('${step.number}. ${step.step}', style: defaultProfileTextStyle),
    );
  }
}
