import 'package:flutter/material.dart';

appTheme() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orangeAccent, Colors.orange, Colors.deepOrange],
    ),
  );
}

appTextFields() {
  return Colors.orangeAccent;
}

menuTheme() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orangeAccent, Colors.orange, Colors.deepOrange],
    ),
    borderRadius: new BorderRadius.only(
      bottomLeft: Radius.circular(60.0),
      bottomRight: Radius.circular(60.0),
    ),
  );
}

textStyle() {
  return TextStyle(fontSize: 20,
  color: Colors.white);
}

subTitleStyle() {
  return TextStyle(fontSize: 25,
      color: Colors.white);
}

titleStyle() {
  return TextStyle(fontSize: 40,
      color: Colors.white);
}
