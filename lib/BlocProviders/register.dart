import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/blocs/registerBloc/register_bloc.dart';
import '../screens/register_screen.dart';

class RegisterProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
        create: (content) => RegisterBloc(),
        child: RegisterScreen(),
    );
  }
}
