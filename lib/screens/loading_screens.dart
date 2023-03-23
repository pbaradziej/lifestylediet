import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/palette.dart';
import 'package:lifestylediet/utils/theme.dart';

Widget loadingScreen() {
  return Center(
    child: SizedBox(
      height: 200,
      width: 200,
      child: CircularProgressIndicator(
        backgroundColor: defaultColor,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        strokeWidth: 5,
      ),
    ),
  );
}

Widget loadingScreenMainScreen() {
  return DecoratedBox(
    decoration: appTheme(),
    child: Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: CircularProgressIndicator(
          backgroundColor: defaultColor,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          strokeWidth: 5,
        ),
      ),
    ),
  );
}
