import 'package:flutter/material.dart';

BoxDecoration appTheme() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Colors.orangeAccent,
        Colors.orange,
        Colors.deepOrange,
      ],
    ),
  );
}

BoxDecoration menuTheme() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        Colors.orangeAccent,
        Colors.orange,
        Colors.deepOrange,
      ],
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(60.0),
      bottomRight: Radius.circular(60.0),
    ),
  );
}

Widget datePickerTheme(final Widget child) {
  return Theme(
    data: ThemeData.light().copyWith(
      primaryColor: Colors.deepOrange,
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      colorScheme: const ColorScheme.light(
        primary: Colors.orange,
        secondary: Colors.orangeAccent,
      ),
    ),
    child: child,
  );
}
