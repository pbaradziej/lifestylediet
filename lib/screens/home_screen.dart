import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/BlocProviders/add.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/bloc/loginBloc/bloc.dart';
import 'package:lifestylediet/models/models.dart';
import 'package:lifestylediet/themeAccent/theme.dart';

import 'details_home_screen.dart';
import 'loading_screen.dart';
import 'login_screen.dart';

class HomeScreenData extends StatefulWidget {
  @override
  _HomeScreenDataState createState() => _HomeScreenDataState();
}

class _HomeScreenDataState extends State<HomeScreenData> {
  HomeBloc _homeBloc;
  LoginBloc _loginBloc;
  List<DatabaseProduct> _breakfast;
  List<DatabaseProduct> _dinner;
  List<DatabaseProduct> _supper;
  Nutrition _nutrition;

  @override
  initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    load();
  }

  load() {
    _homeBloc.add(HomeLoad(_loginBloc.uid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeLogoutState) {
          return LoginScreen();
        } else if (state is HomeLoadingState) {
          return loadingScreenMainScreen();
        } else if (state is HomeLoadedState) {
          return _homeScreen(state);
        } else if (state is HomeAddingState) {
          return AddProvider();
        } else {
          return Container();
        }
      }),
    );
  }

  _homeScreen(HomeLoadedState state) {
    _breakfast = state.breakfast;
    _dinner = state.dinner;
    _supper = state.supper;
    _nutrition = state.nutrition;
    return Container(
      color: Colors.orangeAccent,
      child: Column(
        children: [
          appBar(),
          mealList(),
        ],
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.orangeAccent,
      leading: IconButton(
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        onPressed: null,
      ),
      actions: [
        logout(),
      ],
    );
  }

  Widget logout() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
      child: FlatButton(
        onPressed: () {
          _homeBloc.add(Logout());
        },
        child: Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget mealList() {
    return Expanded(
      child: ListView(
        children: <Widget>[
          calories(),
          meal('Breakfast', _breakfast),
          meal('Dinner', _dinner),
          meal('Supper', _supper),
        ],
      ),
    );
  }

  Widget meal(String meal, List<DatabaseProduct> mealList) {
    return Card(
      child: Column(
        children: [
          mealNameTile(meal),
          listBuilder(mealList),
        ],
      ),
    );
  }

  Widget mealNameTile(String meal) {
    return Card(
      child: ListTile(
        title: Text(meal),
        trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _homeBloc.add(AddProduct(meal));
              _homeBloc.dispose();
            }),
      ),
    );
  }

  Widget listBuilder(List<DatabaseProduct> mealList) {
    return ListView.builder(
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
      height: 220,
      alignment: Alignment.topCenter,
      decoration: menuTheme(),
      child: Container(
        width: 350,
        child: Column(
          children: [
            kcalRow(),
            SizedBox(height: 26),
            nutritionRow(),
          ],
        ),
      ),
    );
  }

  Widget kcalRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 0),
        _kcalPanel('kcal', 'left', subTitleStyle(),
            (_nutrition.kcalLeft - _nutrition.kcal).toString()),
        SizedBox(width: 20),
        _kcalPanel('kcal', 'eaten', titleStyle(), _nutrition.kcal.toString()),
        SizedBox(width: 20),
        _kcalPanel('kcal', 'burned', subTitleStyle(), '0'),
      ],
    );
  }

  Widget _kcalPanel(String name, String action, TextStyle style, String value) {
    return Column(
      children: [
        Text(name, style: subTitleStyle()),
        Text(action, style: subTitleStyle()),
        Text(value, style: style)
      ],
    );
  }

  Widget nutritionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _nutritionText('fats', _nutrition.fats.toString(), textStyle()),
        _nutritionText('protein', _nutrition.protein.toString(), textStyle()),
        _nutritionText('carbs', _nutrition.carbs.toString(), textStyle()),
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
      trailing: trailingListTile(product, nutriments),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsHomeScreen(
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
    return Row(
      children: [
        Text("carbs: " +
            isNullCheckAmount(
                nutriments.carbs, nutriments.carbsPerServing, product)),
        Text(" protein: " +
            isNullCheckAmount(
                nutriments.protein, nutriments.proteinPerServing, product)),
        Text(
          " fats: " +
              isNullCheckAmount(
                  nutriments.fats, nutriments.fatsPerServing, product),
        ),
      ],
    );
  }

  Widget trailingListTile(DatabaseProduct product, Nutriments nutriments) {
    return Text(
      "kcal: " +
          isNullCheckAmount(nutriments.caloriesPer100g,
              nutriments.caloriesPerServing, product),
    );
  }

  isNullCheckAmount(
      double value, double valuePerServing, DatabaseProduct product) {
    double val;
    switch (product.value) {
      case 'serving':
        if (valuePerServing == null) return '?';
        val = valuePerServing * product.amount;
        break;
      case '100g':
        if (value == null) return '?';
        val = value * product.amount;
        break;
    }
    return val.toString();
  }
}
