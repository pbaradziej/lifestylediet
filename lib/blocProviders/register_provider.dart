import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/bloc/registerBloc/bloc.dart';
import 'package:lifestylediet/screens/screens.dart';

class RegisterProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (content) => RegisterBloc(),
      child: RegisterScreen(),
    );
  }
}
