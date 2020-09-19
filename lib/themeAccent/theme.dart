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

searchTextFields() {
  return Colors.white70;
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

titleAddScreenStyle() {
  return TextStyle(fontSize: 30,
      color: Colors.black54);
}

subTitleAddScreenStyle() {
  return TextStyle(fontSize: 20,
      color: Colors.black);
}

titleStyle() {
  return TextStyle(fontSize: 40,
      color: Colors.white);
}

Widget appBarLogin() {
  return AppBar(
    elevation: 0,
    backgroundColor: Color.fromRGBO(255, 165, 44, 1),
  );
}

Widget appBarAdd() {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.orangeAccent,
    leading: IconButton(
      icon: Icon(
        Icons.account_circle,
        color: Colors.white,
      ),
      onPressed: null,
    ),
  );
}