import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color darkBlue = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color warningRed = Color(0xFFE53935);
  static const Color successGreen = Color(0xFF43A047);
  
  // Weather Colors
  static const Color sunnyYellow = Color(0xFFFFC107);
  static const Color cloudyGray = Color(0xFF9E9E9E);
  static const Color rainyBlue = Color(0xFF2196F3);
  static const Color snowWhite = Color(0xFFECEFF1);
  static const Color stormPurple = Color(0xFF673AB7);
  
  // Radar Colors
  static const Color lightRain = Color(0xFF4CAF50);
  static const Color moderateRain = Color(0xFFFFEB3B);
  static const Color heavyRain = Color(0xFFFF9800);
  static const Color severeRain = Color(0xFFE53935);
  static const Color extremeRain = Color(0xFF9C27B0);
  
  // Neutral Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: MaterialColor(primaryBlue.value, {
        50: const Color(0xFFE3F2FD),
        100: const Color(0xFFBBDEFB),
        200: const Color(0xFF90CAF9),
        300: const Color(0xFF64B5F6),
        400: const Color(0xFF42A5F5),
        500: primaryBlue,
        600: const Color(0xFF1E88E5),
        700: const Color(0xFF1976D2),
        800: const Color(0xFF1565C0),
        900: const Color(0xFF0D47A1),
      }),
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: accentOrange,
        surface: surfaceLight,
        background: backgroundLight,
        error: warningRed,
        onPrimary: textLight,
        onSecondary: textLight,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textLight,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textLight,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceLight,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(primaryBlue.value, {
        50: const Color(0xFFE3F2FD),
        100: const Color(0xFFBBDEFB),
        200: const Color(0xFF90CAF9),
        300: const Color(0xFF64B5F6),
        400: const Color(0xFF42A5F5),
        500: primaryBlue,
        600: const Color(0xFF1E88E5),
        700: const Color(0xFF1976D2),
        800: const Color(0xFF1565C0),
        900: const Color(0xFF0D47A1),
      }),
      colorScheme: const ColorScheme.dark(
        primary: lightBlue,
        secondary: accentOrange,
        surface: surfaceDark,
        background: backgroundDark,
        error: warningRed,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textLight,
        onBackground: textLight,
        onError: textLight,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceDark,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBlue,
          foregroundColor: textPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textLight,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textLight,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textLight,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textLight,
        size: 24,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: lightBlue,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Weather Alert Colors
  static Color getAlertColor(String alertType) {
    switch (alertType.toLowerCase()) {
      case 'tornado warning':
      case 'hurricane warning':
      case 'flash flood warning':
        return warningRed;
      case 'tornado watch':
      case 'hurricane watch':
      case 'severe thunderstorm warning':
        return accentOrange;
      case 'severe thunderstorm watch':
      case 'winter storm warning':
        return sunnyYellow;
      case 'flood warning':
      case 'high wind warning':
        return primaryBlue;
      default:
        return textSecondary;
    }
  }

  // Precipitation Intensity Colors
  static Color getPrecipitationColor(double intensity) {
    if (intensity < 0.1) return lightRain;
    if (intensity < 2.5) return moderateRain;
    if (intensity < 10.0) return heavyRain;
    if (intensity < 50.0) return severeRain;
    return extremeRain;
  }
}