import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    primarySwatch: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white
  );
}