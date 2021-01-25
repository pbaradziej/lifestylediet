import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/screens/screens.dart';

class AddProvider extends StatelessWidget {
  final String meal;
  final String currentDate;
  final String uid;

  const AddProvider({
    Key key,
    this.meal,
    this.currentDate,
    this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBloc>(
      create: (content) => AddBloc(meal, currentDate, uid),
      child: AddScreen(),
    );
  }
}
