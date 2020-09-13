import 'package:flutter/material.dart';

Widget loadingScreen() {
  return Center(
    child: Container(
      height: 200,
      width: 200,
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 5,
      ),
    ),
  );
}
