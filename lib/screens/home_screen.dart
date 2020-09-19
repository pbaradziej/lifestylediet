import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/BlocProviders/add.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/themeAccent/theme.dart';

import 'loading_screen.dart';
import 'login_screen.dart';

class HomeScreenData extends StatefulWidget {
  @override
  _HomeScreenDataState createState() => _HomeScreenDataState();
}

class _HomeScreenDataState extends State<HomeScreenData> {
  HomeBloc _homeBloc;

  @override
  initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    load();
  }

  load() {
    _homeBloc.add(HomeLoad());
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
          return Column(
            children: [appBar(), calories(), mealList()],
          );
        } else if (state is HomeAddingState) {
          return AddProvider();
        } else {
          return Container();
        }
      }),
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
          _homeBloc.add(HomeLogout());
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

  // Widget example(HomeLoadedState state) {
  //   return Card(
  //     child: ListTile(
  //       subtitle: Text("carbs: " +
  //           state.product.nutriments.carbohydrates.toString() +
  //           " protein: " +
  //           state.product.nutriments.proteins.toString() +
  //           " fats: " +
  //           state.product.nutriments.fat.toString()),
  //       title: Text(state.product.productName),
  //       trailing: Text("kcal: " +
  //           state.product.nutriments.energyServing.toString() +
  //           "\nkcal 100g: " +
  //           state.product.nutriments.energyKcal100g.toString()),
  //       leading: Image.network(state.product.selectedImages[2].url),
  //     ),
  //   );
  // }

  Widget mealList() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          SizedBox(width: 5),
          SizedBox(
            width: 350,
            child: Column(
              children: [
                breakfast(),
                dinner(),
                supper(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget breakfast() {
    return Card(
      child: ListTile(
        title: Text('Breakfast'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _homeBloc.add(HomeAddFood()),
        ),
      ),
    );
  }

  Widget dinner() {
    return Card(
      child: ListTile(
        title: Text('Dinner'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: null,
        ),
      ),
    );
  }

  Widget supper() {
    return Card(
      child: ListTile(
        title: Text('Supper'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: null,
        ),
      ),
    );
  }

  Widget calories() {
    return Container(
      height: 250,
      alignment: Alignment.topCenter,
      decoration: menuTheme(),
      child: Container(
        width: 350,
        child: Column(
          children: [
            SizedBox(height: 20),
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
        kcalLeft(),
        SizedBox(width: 20),
        kcal(),
        SizedBox(width: 20),
        kcalTaken(),
      ],
    );
  }

  Widget nutritionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        fats(),
        protein(),
        carbs(),
      ],
    );
  }

  Widget kcalLeft() {
    return Column(
      children: [
        Text(
          'kcal',
          style: subTitleStyle(),
        ),
        Text(
          'left',
          style: subTitleStyle(),
        ),
        Text(
          '0',
          style: subTitleStyle(),
        )
      ],
    );
  }

  Widget kcal() {
    return Column(
      children: [
        Text(
          'kcal',
          style: titleStyle(),
        ),
        Text(
          '0',
          style: titleStyle(),
        )
      ],
    );
  }

  Widget kcalTaken() {
    return Column(
      children: [
        Text(
          'kcal',
          style: subTitleStyle(),
        ),
        Text(
          'taken',
          style: subTitleStyle(),
        ),
        Text(
          '0',
          style: subTitleStyle(),
        )
      ],
    );
  }

  Widget fats() {
    return Column(
      children: [
        Text('Fats', style: textStyle()),
        SizedBox(
          height: 5,
        ),
        Text('0', style: textStyle()),
      ],
    );
  }

  Widget protein() {
    return Column(
      children: [
        Text('Protein', style: textStyle()),
        SizedBox(
          height: 5,
        ),
        Text('0', style: textStyle()),
      ],
    );
  }

  Widget carbs() {
    return Column(
      children: [
        Text('Carbs', style: textStyle()),
        SizedBox(
          height: 5,
        ),
        Text('0', style: textStyle()),
      ],
    );
  }
}
