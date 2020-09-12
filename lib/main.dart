import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MaterialApp(home: FireBase()));

class FireBase extends StatefulWidget {
  @override
  _FireBaseState createState() => _FireBaseState();
}

class _FireBaseState extends State<FireBase> {
  bool _initialized = false;
  bool _error = false;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container(
        child: Text("you focked this up"),
      );
    }

    if (!_initialized) {
      return CircularProgressIndicator();
    } else {
      return Home();
    }
  }

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
}
