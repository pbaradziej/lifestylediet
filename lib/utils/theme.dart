import 'package:flutter/material.dart';

Color get appTextFieldsColor => Colors.orangeAccent;

Color get searchLupe => Colors.white70;

TextStyle get searchListStyle => TextStyle(fontSize: 11);

TextStyle get textStyle => TextStyle(fontSize: 20, color: Colors.white);

TextStyle get defaultTextStyle => TextStyle(fontSize: 14, color: Colors.black);

TextStyle get subTitleStyle => TextStyle(fontSize: 25, color: Colors.white);

TextStyle get titleAddScreenStyle => TextStyle(fontSize: 30, color: Colors.black54);

TextStyle get subTitleAddScreenStyle => TextStyle(fontSize: 20, color: Colors.black);

TextStyle get titleStyle => TextStyle(fontSize: 40, color: Colors.white);

appTheme() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orangeAccent, Colors.orange, Colors.deepOrange],
    ),
  );
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