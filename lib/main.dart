import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/screens/loading_screen.dart';
import 'package:lifestylediet/utils//theme.dart';
import 'BlocProviders/login_provider.dart';

void main() => runApp(MaterialApp(home: FireBase()));

class FireBase extends StatefulWidget {
  @override
  _FireBaseState createState() => _FireBaseState();
}

class _FireBaseState extends State<FireBase> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container(
        child: Text("Failed to connect to database"),
      );
    }

    if (!_initialized) {
      return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: appTheme(),
          child: loadingScreen());
    }

    return LoginProvider();
  }
}
