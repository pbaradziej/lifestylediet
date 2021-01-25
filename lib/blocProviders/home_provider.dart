import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/homeBloc/bloc.dart';
import 'package:lifestylediet/screens/screens.dart';

class HomeProvider extends StatelessWidget {
  final String uid;
  final String currentDate;

  const HomeProvider({Key key, this.uid, this.currentDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (content) => HomeBloc(uid, currentDate),
      child: HomeScreen(),
    );
  }
}
