import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF4A90E2),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.blue,
      accentColor: const Color(0xFF4A90E2),
      brightness: Brightness.light,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      color: Color(0xFF4A90E2),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Color(0xFF4A90E2),
      unselectedItemColor: Colors.grey,
    ),
  );
}