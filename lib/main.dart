import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lifestylediet/screens/loading_screen.dart';
import 'BlocProviders/login.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        child: Text("fucccc"),
      );
    }

    if (!_initialized) {
      return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.lightBlue, Colors.blue, Colors.blueAccent],
            ),
          ),
          child: loadingScreen());
    }

    return Scaffold(
      body: LoginProvider(),
    );
  }
}
