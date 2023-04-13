import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/profile/profile_cubit.dart';
import 'package:lifestylediet/cubits/recipe/recipe_cubit.dart';
import 'package:lifestylediet/cubits/routing/routing_cubit.dart';
import 'package:lifestylediet/cubits/weight/weight_cubit.dart';
import 'package:lifestylediet/screens/home/chart_screen.dart';
import 'package:lifestylediet/screens/home/meal_screen.dart';
import 'package:lifestylediet/screens/home/profile_screen.dart';
import 'package:lifestylediet/screens/home/recipe_screen.dart';
import 'package:lifestylediet/screens/loading_screens.dart';
import 'package:lifestylediet/screens/product/add_product_screen.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RoutingState state = context.select<RoutingCubit, RoutingState>(getRoutingState);
    final RoutingStatus status = state.status;
    if (status == RoutingStatus.loaded) {
      return homeScreen();
    } else if (status == RoutingStatus.addingProduct) {
      return addProductScreen(state);
    }

    return loadingScreenMainScreen();
  }

  RoutingState getRoutingState(RoutingCubit cubit) {
    return cubit.state;
  }

  Widget homeScreen() {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: appBar(),
        body: TabBarView(
          children: <Widget>[
            MealScreen(),
            recipeScreen(),
            chartScreen(),
            profileScreen(),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      title: Center(
        child: Text('Lifestyle Diet', style: titleStyle),
      ),
      bottom: const TabBar(
        tabs: <Tab>[
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.receipt)),
          Tab(icon: Icon(Icons.show_chart)),
          Tab(icon: Icon(Icons.account_circle)),
        ],
      ),
      backgroundColor: backgroundColor,
    );
  }

  Widget recipeScreen() {
    return BlocProvider<RecipeCubit>(
      create: (BuildContext content) => RecipeCubit(),
      child: RecipeScreen(),
    );
  }

  Widget chartScreen() {
    return BlocProvider<WeightCubit>(
      create: (BuildContext content) => WeightCubit(),
      child: ChartScreen(),
    );
  }

  Widget profileScreen() {
    return BlocProvider<ProfileCubit>(
      create: (BuildContext content) => ProfileCubit(),
      child: ProfileScreen(),
    );
  }

  Widget addProductScreen(RoutingState state) {
    final String meal = state.meal;
    final String currentDate = state.currentDate;
    return AddProductScreen(
      meal: meal,
      date: currentDate,
    );
  }
}
