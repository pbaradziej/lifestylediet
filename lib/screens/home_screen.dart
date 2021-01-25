import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/blocProviders/bloc_providers.dart';
import 'package:lifestylediet/screens/screens.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeLogoutState) {
        return LoginScreen();
      } else if (state is HomeLoadingState) {
        return loadingScreenMainScreen();
      } else if (state is HomeLoadedState) {
        return _homeScreen();
      } else if (state is HomeAddingState) {
        return AddProvider(
          meal: state.meal,
          currentDate: state.currentDate,
          uid: state.uid,
        );
      } else {
        return Container();
      }
    });
  }

  _homeScreen() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: _appBar(),
        body: TabBarView(
          children: [
            MealScreen(),
            ChartScreen(),
            ProfileScreen(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      title: Center(
        child: Text("Lifestyle Diet", style: titleStyle),
      ),
      bottom: TabBar(
        tabs: [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.show_chart)),
          Tab(icon: Icon(Icons.account_circle)),
        ],
      ),
      backgroundColor: Colors.orangeAccent,
    );
  }
}
