import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/common_utils.dart';

Widget loadingScreen() {
  return Center(
    child: Container(
      height: 200,
      width: 200,
      child: CircularProgressIndicator(
        backgroundColor: defaultColor,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
        strokeWidth: 5,
      ),
    ),
  );
}

Widget loadingScreenMainScreen() {
  return Container(
    decoration: appTheme(),
    child: Center(
      child: Container(
        height: 200,
        width: 200,
        child: CircularProgressIndicator(
          backgroundColor: defaultColor,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
          strokeWidth: 5,
        ),
      ),
    ),
  );
}
