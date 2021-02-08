import 'package:flutter/material.dart';

BoxDecoration appTheme() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orangeAccent, Colors.orange, Colors.deepOrange],
    ),
  );
}

BoxDecoration menuTheme() {
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

Widget datePickerTheme(Widget child) {
  return Theme(
    data: ThemeData.light().copyWith(
      primaryColor: Colors.deepOrange,
      accentColor: Colors.orangeAccent,
      colorScheme: ColorScheme.light(primary: Colors.orange),
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
    ),
    child: child,
  );
}
