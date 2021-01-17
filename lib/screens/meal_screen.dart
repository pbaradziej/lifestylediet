import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/utils/common_utils.dart';
import 'package:lifestylediet/screens/screens.dart';

class MealScreen extends StatefulWidget {
  final List<Meal> meals;
  final Nutrition nutrition;
  final PersonalData personalData;
  String currentDate;

  MealScreen(
    this.meals,
    this.nutrition,
    this.personalData,
    this.currentDate,
  );

  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  List<Meal> _meals;
  Nutrition _nutrition;
  HomeBloc _homeBloc;
  PersonalData _personalData;
  LoginBloc _loginBloc;
  String _currentDate;

  @override
  void initState() {
    _currentDate = widget.currentDate;
    _meals = widget.meals;
    _nutrition = widget.nutrition;
    _personalData = widget.personalData;
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_homeBloc.state is HomeLoadedState) {
      HomeLoadedState state = _homeBloc.state;
      _personalData = state.personalData;
    }
    _nutrition = _homeBloc.getNutrition(_personalData);
    _getNutritionWithCurrentDate(_meals);
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    String strDate = dateFormat.format(DateTime.now());
    String strLastDate =
        dateFormat.format(DateTime.now().subtract(Duration(days: 7)));
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
      },
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          calories(),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: dataSubtractIconButton(dateFormat, strLastDate),
              trailing: dataAddIconButton(dateFormat, strDate),
              title: Text(
                _currentDate,
                style: titleDateStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 15),
              child: mealPanelList(),
            ),
          ),
        ],
      ),
    );
  }

  void _getNutritionWithCurrentDate(List<Meal> mealList) {
    for (Meal meal in mealList) {
      for (DatabaseProduct product in meal.mealList) {
        if (_currentDate == product.date) {
          _kcalAmount(product);
        }
      }
    }
  }

  _kcalAmount(DatabaseProduct product) {
    Nutriments nutriments = product.nutriments;
    _nutrition.kcal += _valueOfNutriment(
        nutriments.caloriesPer100g, nutriments.caloriesPerServing, product);
    _nutrition.protein -= _valueOfNutriment(
        nutriments.protein, nutriments.proteinPerServing, product);
    _nutrition.carbs -= _valueOfNutriment(
        nutriments.carbs, nutriments.carbsPerServing, product);
    _nutrition.fats -=
        _valueOfNutriment(nutriments.fats, nutriments.fatsPerServing, product);
  }

  _valueOfNutriment(
      double value, double valuePerServing, DatabaseProduct product) {
    double val;
    switch (product.value) {
      case 'serving':
        if (valuePerServing == null) return 0;
        val = valuePerServing * product.amount;
        break;
      case '100g':
        if (value == null) return 0;
        val = value * product.amount;
        break;
    }
    return val.toInt();
  }

  Widget dataSubtractIconButton(DateFormat dateFormat, String strLastDate) {
    return IconButton(
      splashColor:
          _currentDate == strLastDate ? Colors.white : Color(0x66C8C8C8),
      highlightColor:
          _currentDate == strLastDate ? Colors.white : Color(0x66C8C8C8),
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        if (_currentDate != strLastDate) {
          setState(() {
            DateTime subDate =
                DateTime.parse(_currentDate).subtract(Duration(days: 1));
            _currentDate = dateFormat.format(subDate);
            widget.currentDate = _currentDate;
            _loginBloc.setCurrentDate(_currentDate);
          });
        }
      },
      color: _currentDate == strLastDate ? Colors.grey[300] : Colors.grey[500],
    );
  }

  Widget dataAddIconButton(DateFormat dateFormat, String strDate) {
    return IconButton(
      splashColor: _currentDate == strDate ? Colors.white : Color(0x66C8C8C8),
      highlightColor:
          _currentDate == strDate ? Colors.white : Color(0x66C8C8C8),
      icon: Icon(Icons.arrow_forward),
      color: _currentDate == strDate ? Colors.grey[300] : Colors.grey[500],
      onPressed: () {
        if (_currentDate != strDate) {
          setState(() {
            DateTime addDate =
                DateTime.parse(_currentDate).add(Duration(days: 1));
            _currentDate = dateFormat.format(addDate);
            widget.currentDate = _currentDate;
            _loginBloc.setCurrentDate(_currentDate);
          });
        }
      },
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
                    _homeBloc.add(AddProductScreen(meal.name, _currentDate));
                    _homeBloc.dispose();
                  },
                ),
              ],
            ));
      }).toList(),
    );
  }

  Widget listBuilder(List<DatabaseProduct> mealList) {
    List<DatabaseProduct> currentMealList =
        getProductsWithCurrentDate(mealList);
    return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: currentMealList.length,
      itemBuilder: (context, index) {
        return showFood(currentMealList, index);
      },
    );
  }

  List<DatabaseProduct> getProductsWithCurrentDate(
      List<DatabaseProduct> mealList) {
    List<DatabaseProduct> currentMealList = [];
    for (DatabaseProduct product in mealList) {
      if (_currentDate == product.date) {
        currentMealList.add(product);
      }
    }

    return currentMealList;
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
          SizedBox(height: 14),
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
        _nutritionText(
            'protein\nleft', _nutrition.protein.toString(), textStyle),
        _nutritionText('carbs\nleft', _nutrition.carbs.toString(), textStyle),
        _nutritionText('fats\nleft', _nutrition.fats.toString(), textStyle),
      ],
    );
  }

  Widget _nutritionText(String name, String value, TextStyle style) {
    return Column(
      children: [
        Text(
          name,
          style: style,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
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
          setState(() {});
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
