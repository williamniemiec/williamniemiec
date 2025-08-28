import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // X Brand Colors
  static const Color xBlue = Color(0xFF1DA1F2);
  static const Color xBlack = Color(0xFF000000);
  static const Color xDarkGray = Color(0xFF15202B);
  static const Color xGray = Color(0xFF657786);
  static const Color xLightGray = Color(0xFFAAB8C2);
  static const Color xExtraLightGray = Color(0xFFE1E8ED);
  static const Color xWhite = Color(0xFFFFFFFF);
  
  // Additional Colors
  static const Color xRed = Color(0xFFE0245E);
  static const Color xGreen = Color(0xFF17BF63);
  static const Color xOrange = Color(0xFFFF6600);
  static const Color xPurple = Color(0xFF794BC4);
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: xBlue,
      scaffoldBackgroundColor: xWhite,
      
      colorScheme: const ColorScheme.light(
        primary: xBlue,
        secondary: xBlue,
        surface: xWhite,
        background: xWhite,
        error: xRed,
        onPrimary: xWhite,
        onSecondary: xWhite,
        onSurface: xBlack,
        onBackground: xBlack,
        onError: xWhite,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: xWhite,
        foregroundColor: xBlack,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: xBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'TwitterChirp',
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: xWhite,
        selectedItemColor: xBlue,
        unselectedItemColor: xGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: xBlack,
          fontFamily: 'TwitterChirp',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: xBlue,
          fontFamily: 'TwitterChirp',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: xBlue,
          fontFamily: 'TwitterChirp',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: xBlue,
          foregroundColor: xWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'TwitterChirp',
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: xBlue,
          side: const BorderSide(color: xLightGray),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'TwitterChirp',
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: xBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'TwitterChirp',
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: xExtraLightGray.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: xBlue, width: 2),
        ),
        hintStyle: const TextStyle(
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
      ),
      
      cardTheme: CardThemeData(
        color: xWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      
      dividerTheme: const DividerThemeData(
        color: xExtraLightGray,
        thickness: 1,
        space: 1,
      ),
      
      iconTheme: const IconThemeData(
        color: xGray,
        size: 24,
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: xBlue,
        foregroundColor: xWhite,
        elevation: 4,
      ),
    );
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: xBlue,
      scaffoldBackgroundColor: xBlack,
      
      colorScheme: const ColorScheme.dark(
        primary: xBlue,
        secondary: xBlue,
        surface: xDarkGray,
        background: xBlack,
        error: xRed,
        onPrimary: xWhite,
        onSecondary: xWhite,
        onSurface: xWhite,
        onBackground: xWhite,
        onError: xWhite,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: xBlack,
        foregroundColor: xWhite,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: xWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'TwitterChirp',
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: xBlack,
        selectedItemColor: xBlue,
        unselectedItemColor: xGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: xWhite,
          fontFamily: 'TwitterChirp',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: xBlue,
          fontFamily: 'TwitterChirp',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: xBlue,
          fontFamily: 'TwitterChirp',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: xBlue,
          foregroundColor: xWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'TwitterChirp',
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: xBlue,
          side: const BorderSide(color: xGray),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'TwitterChirp',
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: xBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'TwitterChirp',
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: xDarkGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: xBlue, width: 2),
        ),
        hintStyle: const TextStyle(
          color: xGray,
          fontFamily: 'TwitterChirp',
        ),
      ),
      
      cardTheme: CardThemeData(
        color: xDarkGray,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      
      dividerTheme: const DividerThemeData(
        color: xDarkGray,
        thickness: 1,
        space: 1,
      ),
      
      iconTheme: const IconThemeData(
        color: xGray,
        size: 24,
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: xBlue,
        foregroundColor: xWhite,
        elevation: 4,
      ),
    );
  }
}

// Custom Text Styles
class XTextStyles {
  static const TextStyle username = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppTheme.xGray,
    fontFamily: 'TwitterChirp',
  );
  
  static const TextStyle handle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppTheme.xGray,
    fontFamily: 'TwitterChirp',
  );
  
  static const TextStyle timestamp = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppTheme.xGray,
    fontFamily: 'TwitterChirp',
  );
  
  static const TextStyle postContent = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.4,
    fontFamily: 'TwitterChirp',
  );
  
  static const TextStyle hashtag = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppTheme.xBlue,
    fontFamily: 'TwitterChirp',
  );
  
  static const TextStyle mention = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppTheme.xBlue,
    fontFamily: 'TwitterChirp',
  );
  
  static const TextStyle link = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppTheme.xBlue,
    decoration: TextDecoration.underline,
    fontFamily: 'TwitterChirp',
  );
}