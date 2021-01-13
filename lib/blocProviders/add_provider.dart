import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/addBloc/bloc.dart';
import 'package:lifestylediet/screens/screens.dart';

class AddProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBloc>(
      create: (content) => AddBloc(),
      child: AddScreen(),
    );
  }
}
