import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/registerBloc/bloc.dart';
import 'register_screen.dart';

class RegisterProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RegisterBloc>(
        create: (content) => RegisterBloc(),
        child: RegisterScreen(),
      ),
    );
  }
}
