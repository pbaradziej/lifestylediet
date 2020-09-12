import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loginBloc/login_bloc.dart';
import 'login_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (content) => LoginBloc(),
        child: LoginScreen(),
      ),
    );
  }
}

