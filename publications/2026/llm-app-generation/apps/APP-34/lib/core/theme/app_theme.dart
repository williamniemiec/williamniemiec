import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppConstants.primaryColor,
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: AppConstants.primaryColor,
        secondary: AppConstants.secondaryColor,
        surface: AppConstants.surfaceColor,
        background: AppConstants.backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: AppConstants.textPrimaryColor,
        onBackground: AppConstants.textPrimaryColor,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppConstants.iconColor),
        titleTextStyle: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppConstants.backgroundColor,
        selectedItemColor: AppConstants.textPrimaryColor,
        unselectedItemColor: AppConstants.textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: AppConstants.textSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: AppConstants.textSecondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: AppConstants.textSecondaryColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppConstants.iconColor,
        size: 24,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.textPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.textPrimaryColor,
          side: const BorderSide(color: AppConstants.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          borderSide: const BorderSide(color: AppConstants.primaryColor),
        ),
        hintStyle: const TextStyle(color: AppConstants.textSecondaryColor),
        labelStyle: const TextStyle(color: AppConstants.textSecondaryColor),
        contentPadding: const EdgeInsets.all(AppConstants.defaultPadding),
      ),
      
      // Card Theme
      // cardTheme: CardTheme(
      //   color: AppConstants.surfaceColor,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      //   ),
      // ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppConstants.dividerColor,
        thickness: 1,
      ),
      
      // Dialog Theme
      // dialogTheme: DialogTheme(
      //   backgroundColor: AppConstants.surfaceColor,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
      //   ),
      // ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.largeBorderRadius),
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
  
  // Custom text styles for specific use cases
  static const TextStyle usernameStyle = TextStyle(
    color: AppConstants.textPrimaryColor,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle captionStyle = TextStyle(
    color: AppConstants.textPrimaryColor,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle hashtagStyle = TextStyle(
    color: AppConstants.textPrimaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle soundNameStyle = TextStyle(
    color: AppConstants.textPrimaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle statsStyle = TextStyle(
    color: AppConstants.textSecondaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}