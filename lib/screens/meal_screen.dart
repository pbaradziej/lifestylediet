import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'package:lifestylediet/screens/screens.dart';

class MealScreen extends StatefulWidget {
  final List<Meal> meals;
  final Nutrition nutrition;

  MealScreen(this.meals, this.nutrition);

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  List<Meal> _meals;
  Nutrition _nutrition;
  HomeBloc _homeBloc;
  LoginBloc _loginBloc;

  @override
  void initState() {
    _meals = widget.meals;
    _nutrition = widget.nutrition;
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
      },
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          calories(),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10, bottom: 15),
              child: mealPanelList(),
            ),
          ),
        ],
      ),
    );
  }

  ExpansionPanelList mealPanelList() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _meals[index].isExpanded = !isExpanded;
        });
      },
      children: _meals.map((meal) {
        return ExpansionPanel(
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return Column(
                children: [
                  ListTile(
                    title: Text(
                      meal.name.toUpperCase(),
                      softWrap: true,
                    ),
                  ),
                ],
              );
            },
            isExpanded: meal.isExpanded,
            body: Column(
              children: [
                listBuilder(meal.mealList),
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "ADD ${meal.name.toUpperCase()} ",
                          style: defaultTextStyle,
                        ),
                      ),
                      Icon(Icons.add),
                    ],
                  ),
                  onPressed: () {
                    _homeBloc.add(AddProductScreen(meal.name));
                    _homeBloc.dispose();
                  },
                ),
              ],
            ));
      }).toList(),
    );
  }

  Widget listBuilder(List<DatabaseProduct> mealList) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: mealList.length,
      itemBuilder: (context, index) {
        return showFood(mealList, index);
      },
    );
  }

  Widget calories() {
    return Container(
      width: 350,
      height: 220,
      alignment: Alignment.topCenter,
      decoration: menuTheme(),
      child: Column(
        children: [
          kcalRow(),
          SizedBox(height: 26),
          nutritionRow(),
        ],
      ),
    );
  }

  Widget kcalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 0),
        _kcalPanel('kcal', 'left', subTitleStyle,
            (_nutrition.kcalLeft - _nutrition.kcal).toString()),
        SizedBox(width: 20),
        _kcalPanel('kcal', 'eaten', titleHomeStyle, _nutrition.kcal.toString()),
        SizedBox(width: 20),
        _kcalPanel('kcal', 'burned', subTitleStyle, '0'),
      ],
    );
  }

  Widget _kcalPanel(String name, String action, TextStyle style, String value) {
    return Column(
      children: [
        Text(name, style: subTitleStyle),
        Text(action, style: subTitleStyle),
        Text(value, style: style)
      ],
    );
  }

  Widget nutritionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _nutritionText('protein', _nutrition.protein.toString(), textStyle),
        _nutritionText('carbs', _nutrition.carbs.toString(), textStyle),
        _nutritionText('fats', _nutrition.fats.toString(), textStyle),
      ],
    );
  }

  Widget _nutritionText(String name, String value, TextStyle style) {
    return Column(
      children: [
        Text(name, style: style),
        SizedBox(height: 5),
        Text(value, style: style),
      ],
    );
  }

  Widget showFood(List<DatabaseProduct> mealList, int index) {
    final product = mealList[index];
    final nutriments = product.nutriments;

    return ListTile(
      subtitle: subtitleListTile(product, nutriments),
      title: Text(product.name ?? ""),
      trailing: IconButton(
        onPressed: () {
          _homeBloc.add(
            DeleteProduct(id: product.id),
          );
          //setState(() {});
        },
        icon: Icon(
          Icons.delete,
          color: Colors.black54,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(
            product: product,
            meal: _homeBloc.meal,
            uid: _loginBloc.uid,
            homeBloc: _homeBloc,
          ),
        ),
      ).then(
        (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget subtitleListTile(DatabaseProduct product, Nutriments nutriments) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text:
                  "kcal: ${isNullCheckAmount(nutriments.caloriesPer100g, nutriments.caloriesPerServing, product)}"),
          TextSpan(
              text:
                  " protein: ${isNullCheckAmount(nutriments.protein, nutriments.proteinPerServing, product)}"),
          TextSpan(
              text:
                  " carbs: ${isNullCheckAmount(nutriments.carbs, nutriments.carbsPerServing, product)}"),
          TextSpan(
              text:
                  " fats: ${isNullCheckAmount(nutriments.fats, nutriments.fatsPerServing, product)}"),
        ],
      ),
    );
  }

  isNullCheckAmount(
      double value, double valuePerServing, DatabaseProduct product) {
    double val;
    switch (product.value) {
      case 'serving':
        if (valuePerServing == -1 || valuePerServing == null) return '?';
        val = valuePerServing * product.amount;
        break;
      case '100g':
        if (value == -1 || valuePerServing == null) return '?';
        val = value * product.amount;
        break;
    }
    return val.roundToDouble().toString();
  }
}
