import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Colors
  static const Color redditOrange = Color(0xFFFF4500);
  static const Color redditBlue = Color(0xFF0079D3);
  static const Color redditDarkBlue = Color(0xFF24A0ED);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFF8F9FA);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1A1A1B);
  static const Color lightTextSecondary = Color(0xFF787C82);
  static const Color lightDivider = Color(0xFFEDEFF1);
  static const Color lightBorder = Color(0xFFCCD2D9);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF030303);
  static const Color darkSurface = Color(0xFF1A1A1B);
  static const Color darkCardBackground = Color(0xFF1A1A1B);
  static const Color darkTextPrimary = Color(0xFFD7DADC);
  static const Color darkTextSecondary = Color(0xFF818384);
  static const Color darkDivider = Color(0xFF343536);
  static const Color darkBorder = Color(0xFF474748);
  
  // Vote Colors
  static const Color upvoteColor = Color(0xFFFF4500);
  static const Color downvoteColor = Color(0xFF7193FF);
  static const Color upvoteActiveColor = Color(0xFFFF6314);
  static const Color downvoteActiveColor = Color(0xFF5A75CC);
  
  // Status Colors
  static const Color successColor = Color(0xFF46D160);
  static const Color errorColor = Color(0xFFEA0027);
  static const Color warningColor = Color(0xFFFFB000);
  static const Color infoColor = Color(0xFF0079D3);
  
  // Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: redditOrange,
      scaffoldBackgroundColor: lightBackground,
      
      colorScheme: const ColorScheme.light(
        primary: redditOrange,
        secondary: redditBlue,
        surface: lightSurface,
        background: lightBackground,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightTextPrimary,
        onBackground: lightTextPrimary,
        onError: Colors.white,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightBackground,
        selectedItemColor: redditOrange,
        unselectedItemColor: lightTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      cardTheme: CardThemeData(
        color: lightCardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: redditOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: redditBlue,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: redditBlue, width: 2),
        ),
        hintStyle: const TextStyle(
          color: lightTextSecondary,
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 1,
      ),
      
      textTheme: const TextTheme(
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ).apply(
        bodyColor: lightTextPrimary,
        displayColor: lightTextPrimary,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: redditOrange,
      scaffoldBackgroundColor: darkBackground,
      
      colorScheme: const ColorScheme.dark(
        primary: redditOrange,
        secondary: redditDarkBlue,
        surface: darkSurface,
        background: darkBackground,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkTextPrimary,
        onBackground: darkTextPrimary,
        onError: Colors.white,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: redditOrange,
        unselectedItemColor: darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      cardTheme: CardThemeData(
        color: darkCardBackground,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: redditOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: redditDarkBlue,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: redditDarkBlue, width: 2),
        ),
        hintStyle: const TextStyle(
          color: darkTextSecondary,
        ),
      ),
      
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
      ),
      
      textTheme: const TextTheme(
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ).apply(
        bodyColor: darkTextPrimary,
        displayColor: darkTextPrimary,
      ),
    );
  }
}

// Custom Colors Extension
extension AppColors on ColorScheme {
  Color get upvoteColor => AppTheme.upvoteColor;
  Color get downvoteColor => AppTheme.downvoteColor;
  Color get upvoteActiveColor => AppTheme.upvoteActiveColor;
  Color get downvoteActiveColor => AppTheme.downvoteActiveColor;
  Color get successColor => AppTheme.successColor;
  Color get warningColor => AppTheme.warningColor;
  Color get infoColor => AppTheme.infoColor;
  
  Color get textSecondary => brightness == Brightness.light 
      ? AppTheme.lightTextSecondary 
      : AppTheme.darkTextSecondary;
      
  Color get cardBackground => brightness == Brightness.light 
      ? AppTheme.lightCardBackground 
      : AppTheme.darkCardBackground;
      
  Color get dividerColor => brightness == Brightness.light 
      ? AppTheme.lightDivider 
      : AppTheme.darkDivider;
      
  Color get borderColor => brightness == Brightness.light 
      ? AppTheme.lightBorder 
      : AppTheme.darkBorder;
}