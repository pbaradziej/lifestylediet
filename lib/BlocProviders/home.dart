import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/blocs/homescreen/bloc.dart';
import 'package:lifestylediet/screens/home_screen_data.dart';

class HomeProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (content) => HomeBloc(),
      child: HomeScreenData(),
    );
  }
}