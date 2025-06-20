import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getAppTheme({ required bool isDarkMode }) => ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primarySwatch: Colors.orange,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,

    appBarTheme: AppBarTheme(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      elevation: 0,
      surfaceTintColor: isDarkMode ? Colors.black : Colors.white,
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black54),
        borderRadius: BorderRadius.circular(32),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
