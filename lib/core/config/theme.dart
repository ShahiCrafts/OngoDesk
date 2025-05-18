import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: Colors.white
  );
}