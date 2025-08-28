import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);
  
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentRed = Color(0xFFF44336);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentYellow = Color(0xFFFFC107);
  
  // Neutral Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF000000);
  
  // Weather Condition Colors
  static const Color sunnyColor = Color(0xFFFFC107);
  static const Color cloudyColor = Color(0xFF9E9E9E);
  static const Color rainyColor = Color(0xFF2196F3);
  static const Color snowyColor = Color(0xFFE3F2FD);
  static const Color stormyColor = Color(0xFF673AB7);
  static const Color foggyColor = Color(0xFFBDBDBD);
  
  // Alert Colors
  static const Color alertMinor = Color(0xFF4CAF50);
  static const Color alertModerate = Color(0xFFFFC107);
  static const Color alertSevere = Color(0xFFFF9800);
  static const Color alertExtreme = Color(0xFFF44336);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        primaryContainer: primaryLight,
        secondary: accentOrange,
        secondaryContainer: Color(0xFFFFE0B2),
        surface: surfaceLight,
        background: backgroundLight,
        error: accentRed,
        onPrimary: textLight,
        onSecondary: textDark,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textLight,
      ),
      
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceLight,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: textLight,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: 24,
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: backgroundDark,
      
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        primaryContainer: primaryDark,
        secondary: accentOrange,
        secondaryContainer: Color(0xFF5D4037),
        surface: surfaceDark,
        background: backgroundDark,
        error: accentRed,
        onPrimary: textDark,
        onSecondary: textLight,
        onSurface: textLight,
        onBackground: textLight,
        onError: textLight,
      ),
      
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textLight,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: surfaceDark,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: textDark,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      iconTheme: const IconThemeData(
        color: Color(0xFFBDBDBD),
        size: 24,
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textLight,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFFBDBDBD),
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFFBDBDBD),
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFFBDBDBD),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceDark,
        selectedItemColor: primaryLight,
        unselectedItemColor: Color(0xFFBDBDBD),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  // Weather condition color helpers
  static Color getWeatherConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return sunnyColor;
      case 'clouds':
      case 'cloudy':
      case 'overcast':
        return cloudyColor;
      case 'rain':
      case 'drizzle':
      case 'shower':
        return rainyColor;
      case 'snow':
      case 'sleet':
        return snowyColor;
      case 'thunderstorm':
      case 'storm':
        return stormyColor;
      case 'mist':
      case 'fog':
      case 'haze':
        return foggyColor;
      default:
        return primaryBlue;
    }
  }

  // Alert severity color helpers
  static Color getAlertSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'minor':
        return alertMinor;
      case 'moderate':
        return alertModerate;
      case 'severe':
        return alertSevere;
      case 'extreme':
        return alertExtreme;
      default:
        return alertModerate;
    }
  }

  // UV Index color helpers
  static Color getUVIndexColor(int uvIndex) {
    if (uvIndex <= 2) return alertMinor;
    if (uvIndex <= 5) return alertModerate;
    if (uvIndex <= 7) return accentOrange;
    if (uvIndex <= 10) return alertSevere;
    return alertExtreme;
  }

  // Air Quality Index color helpers
  static Color getAQIColor(int aqi) {
    switch (aqi) {
      case 1:
        return alertMinor;
      case 2:
        return Color(0xFF8BC34A);
      case 3:
        return alertModerate;
      case 4:
        return alertSevere;
      case 5:
        return alertExtreme;
      default:
        return alertModerate;
    }
  }
}