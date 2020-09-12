import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FireBase extends StatefulWidget {
  @override
  _FireBaseState createState() => _FireBaseState();
}

class _FireBaseState extends State<FireBase> {

  bool _initialized = false;
  bool _error = false;
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
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
    return Container();
  }
}
