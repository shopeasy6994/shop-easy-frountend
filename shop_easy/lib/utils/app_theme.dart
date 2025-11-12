import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: const AppBarTheme(
      color: Colors.teal,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
    chipTheme: const ChipThemeData(
      backgroundColor: Colors.teal,
      labelStyle: TextStyle(color: Colors.white),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.teal,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    ),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(
        secondary: Colors.amber,
        // FIXED: Replaced deprecated 'background' with 'surface'
        surface: Colors.white),
  );
}
