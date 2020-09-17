import 'package:flutter/material.dart';
import 'package:lifestylediet/themeAccent/theme.dart';

Widget loadingScreen() {
  return Center(
    child: Container(
      height: 200,
      width: 200,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
        strokeWidth: 5,
      ),
    ),
  );
}

Widget loadingScreenMainScreen() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: appTheme(),
    child: Center(
      child: Container(
        height: 200,
        width: 200,
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
          strokeWidth: 5,
        ),
      ),
    ),
  );
}
