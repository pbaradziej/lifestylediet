import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/components/snack_bar.dart';
import 'package:lifestylediet/cubits/auth/auth_cubit.dart';
import 'package:lifestylediet/cubits/login/login_cubit.dart';
import 'package:lifestylediet/screens/auth/goals_screen.dart';
import 'package:lifestylediet/screens/auth/login_form.dart';
import 'package:lifestylediet/screens/auth/personal_data_screen.dart';
import 'package:lifestylediet/screens/auth/register_screen.dart';
import 'package:lifestylediet/screens/loading_screens.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthCubit authCubit;
  late LoginCubit loginCubit;

  @override
  void initState() {
    super.initState();
    authCubit = context.read();
    loginCubit = context.read();
    loginCubit.initializeAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    final LoginState state = context.select<LoginCubit, LoginState>(getLoginState);
    final LoginStatus status = state.status;
    showSnackBar(state);
    if (status == LoginStatus.loaded || status == LoginStatus.notVerified || status == LoginStatus.loginError) {
      return LoginForm(email: state.email);
    } else if (status == LoginStatus.initialPersonalData) {
      return PersonalDataScreen();
    } else if (status == LoginStatus.initialGoals) {
      return GoalsScreen(personalData: state.personalData);
    } else if (status == LoginStatus.authenticated) {
      return authenticationScreen();
    } else if (status == LoginStatus.register) {
      return RegisterScreen();
    }

    return loadingScreen();
  }

  LoginState getLoginState(LoginCubit cubit) {
    return cubit.state;
  }

  void showSnackBar(LoginState state) {
    final String message = state.message;
    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SnackBarBuilder.showSnackBar(context, message);
      });
    }
  }

  Widget authenticationScreen() {
    authCubit.authenticate();
    return loadingScreen();
  }
}
