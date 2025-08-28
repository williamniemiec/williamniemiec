import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  
  // Text Colors
  static const Color primaryTextColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);
  static const Color hintTextColor = Color(0xFF9E9E9E);
  
  // Map Colors
  static const Color routeColor = Color(0xFF1976D2);
  static const Color currentLocationColor = Color(0xFF2196F3);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: primaryTextColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryBlue,
        unselectedItemColor: secondaryTextColor,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 6,
      ),
      cardTheme: const CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        hintStyle: const TextStyle(
          color: hintTextColor,
          fontSize: 16,
          fontFamily: 'Roboto',
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        displayMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        displaySmall: TextStyle(
          color: primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
        headlineLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        headlineMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        headlineSmall: TextStyle(
          color: primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        titleLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        titleMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        titleSmall: TextStyle(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        bodyLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
        ),
        bodySmall: TextStyle(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
        ),
        labelLarge: TextStyle(
          color: primaryTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        labelMedium: TextStyle(
          color: secondaryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
        labelSmall: TextStyle(
          color: hintTextColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}