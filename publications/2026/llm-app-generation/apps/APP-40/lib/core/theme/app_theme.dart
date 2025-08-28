import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static const Color primaryColor = Color(AppConstants.primaryColorValue);
  static const Color secondaryColor = Color(AppConstants.secondaryColorValue);
  static const Color accentColor = Color(AppConstants.accentColorValue);
  static const Color warningColor = Color(AppConstants.warningColorValue);
  
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1F1F1F);
  static const Color lightOnBackground = Color(0xFF1F1F1F);
  static const Color lightCardColor = Color(0xFFFFFFFF);
  
  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Color(0xFFE1E1E1);
  static const Color darkOnBackground = Color(0xFFE1E1E1);
  static const Color darkCardColor = Color(0xFF2C2C2C);
  
  // Text Styles
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    fontFamily: 'GoogleSans',
  );
  
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    fontFamily: 'GoogleSans',
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackground,
    cardColor: lightCardColor,
    
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: lightSurface,
      background: lightBackground,
      onSurface: lightOnSurface,
      onBackground: lightOnBackground,
      error: accentColor,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightOnBackground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: lightOnBackground,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontFamily: 'GoogleSans',
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'GoogleSans',
        fontWeight: FontWeight.normal,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: lightCardColor,
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        textStyle: const TextStyle(
          fontFamily: 'GoogleSans',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(
          fontFamily: 'GoogleSans',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        textStyle: const TextStyle(
          fontFamily: 'GoogleSans',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade200,
      selectedColor: primaryColor.withOpacity(0.2),
      labelStyle: const TextStyle(
        fontFamily: 'GoogleSans',
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
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
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkCardColor,
    
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      surface: darkSurface,
      background: darkBackground,
      onSurface: darkOnSurface,
      onBackground: darkOnBackground,
      error: accentColor,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkOnBackground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: darkOnBackground,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontFamily: 'GoogleSans',
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'GoogleSans',
        fontWeight: FontWeight.normal,
      ),
    ),
    
    cardTheme: CardThemeData(
      color: darkCardColor,
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        textStyle: const TextStyle(
          fontFamily: 'GoogleSans',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        textStyle: const TextStyle(
          fontFamily: 'GoogleSans',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        textStyle: const TextStyle(
          fontFamily: 'GoogleSans',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
    ),
    
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade800,
      selectedColor: primaryColor.withOpacity(0.3),
      labelStyle: const TextStyle(
        fontFamily: 'GoogleSans',
        fontWeight: FontWeight.w500,
        color: darkOnSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryColor.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
    
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        fontFamily: 'GoogleSans',
        color: darkOnBackground,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        fontFamily: 'GoogleSans',
        color: darkOnBackground,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        fontFamily: 'GoogleSans',
        color: darkOnBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
        color: darkOnBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
        color: darkOnBackground,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
        color: darkOnBackground,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        fontFamily: 'GoogleSans',
        color: darkOnSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: 'GoogleSans',
        color: darkOnSurface,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'GoogleSans',
        color: darkOnSurface,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
        color: darkOnSurface,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
        color: darkOnSurface,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        fontFamily: 'GoogleSans',
        color: darkOnSurface,
      ),
    ),
  );
}