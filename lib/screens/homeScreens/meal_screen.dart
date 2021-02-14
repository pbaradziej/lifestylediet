import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/authBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class MealScreen extends StatefulWidget {
  @override
  _MealScreenState createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
  List<Meal> _meals;
  Nutrition _nutrition;
  HomeBloc _homeBloc;
  AuthBloc _loginBloc;
  String _currentDate;
  Utils _utils;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<AuthBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _currentDate = _homeBloc.currentDate;
    _meals = _homeBloc.mealList;
    _utils = new Utils();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PersonalData personalData = _homeBloc.personalData;
    _nutrition = _utils.getNutrition(personalData);
    _getNutritionWithCurrentDate();
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
      },
      child: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          calories(),
          _dateCard(),
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

  Widget _dateCard() {
    DateFormat _dateFormat = new DateFormat("yyyy-MM-dd");
    String strLastDate =
        _dateFormat.format(DateTime.now().subtract(Duration(days: 7)));
    String strDate = _dateFormat.format(DateTime.now());
    return Card(
      color: defaultColor,
      child: ListTile(
        leading: _dataIconButton(strLastDate, "sub", Icons.arrow_back),
        trailing: _dataIconButton(strDate, "add", Icons.arrow_forward),
        title: Text(
          _currentDate,
          style: titleDateStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _getNutritionWithCurrentDate() {
    Utils _utils = new Utils();
    for (Meal meal in _meals) {
      for (DatabaseProduct product in meal.mealList) {
        if (_currentDate == product.date) {
          _nutrition = _utils.kcalAmount(product, _nutrition);
        }
      }
    }
  }

  Widget _dataIconButton(String strDate, String action, IconData icon) {
    return IconButton(
      splashColor: _currentDate == strDate ? defaultColor : Color(0x66C8C8C8),
      highlightColor:
          _currentDate == strDate ? defaultColor : Color(0x66C8C8C8),
      color: _currentDate == strDate ? Colors.grey[300] : Colors.grey[500],
      icon: Icon(icon),
      onPressed: () {
        swipeData(strDate, action);
      },
    );
  }

  void swipeData(String strDate, String action) {
    if (_currentDate != strDate) {
      setState(() {
        DateTime newDate;
        if (action == "sub") {
          newDate = DateTime.parse(_currentDate).subtract(
            Duration(days: 1),
          );
        } else {
          newDate = DateTime.parse(_currentDate).add(
            Duration(days: 1),
          );
        }

        DateFormat _dateFormat = new DateFormat("yyyy-MM-dd");
        _currentDate = _dateFormat.format(newDate);
        _loginBloc.setCurrentDate(_currentDate);
      });
    }
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
          body: _mealPanel(meal),
        );
      }).toList(),
    );
  }

  Widget _mealPanel(Meal meal) {
    return Column(
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
            'protein\nleft', _nutrition.protein.toString(), mealTextStyle),
        _nutritionText(
            'carbs\nleft', _nutrition.carbs.toString(), mealTextStyle),
        _nutritionText('fats\nleft', _nutrition.fats.toString(), mealTextStyle),
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
      trailing: _deleteButton(product),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(
            product: product,
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

  _deleteButton(DatabaseProduct product) {
    return IconButton(
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
    );
  }

  Widget subtitleListTile(DatabaseProduct product, Nutriments nutriments) {
    Utils utils = new Utils();
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: "kcal: ${utils.amountOfNutriments(
            nutriments.caloriesPer100g,
            nutriments.caloriesPerServing,
            product,
          )}"),
          TextSpan(
              text: " protein: ${utils.amountOfNutriments(
            nutriments.protein,
            nutriments.proteinPerServing,
            product,
          )}"),
          TextSpan(
              text: " carbs: ${utils.amountOfNutriments(
            nutriments.carbs,
            nutriments.carbsPerServing,
            product,
          )}"),
          TextSpan(
              text: " fats: ${utils.amountOfNutriments(
            nutriments.fats,
            nutriments.fatsPerServing,
            product,
          )}"),
        ],
      ),
    );
  }
}
