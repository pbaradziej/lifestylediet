import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestylediet/cubits/auth/auth_cubit.dart';
import 'package:lifestylediet/screens/auth/auth_screen.dart';
import 'package:lifestylediet/screens/loading_screens.dart';
import 'package:lifestylediet/utils/theme.dart';

void main() {
  return runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FireBase(),
    ),
  );
}

class FireBase extends StatefulWidget {
  @override
  _FireBaseState createState() => _FireBaseState();
}

class _FireBaseState extends State<FireBase> {
  bool initialized = false;
  bool error = false;

  Future<void> initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        initialized = true;
      });
    } catch (e) {
      setState(() {
        error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(final BuildContext context) {
    if (error) {
      return errorScreen();
    }

    if (!initialized) {
      return loadingScreenWidget();
    }

    return authScreen();
  }

  Widget errorScreen() {
    return const SizedBox(
      child: Text('Failed to connect to database'),
    );
  }

  Widget loadingScreenWidget() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: appTheme(),
      child: loadingScreen(),
    );
  }

  Widget authScreen() {
    return BlocProvider<AuthCubit>(
      create: (final BuildContext content) => AuthCubit(),
      child: AuthScreen(),
    );
  }
}
