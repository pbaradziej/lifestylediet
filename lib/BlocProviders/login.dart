import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/blocs/loginBloc/login_bloc.dart';
import 'package:lifestylediet/screens/login_screen.dart';


class LoginProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (content) => LoginBloc(),
        child: LoginScreen(),
    );
  }
}