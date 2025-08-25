import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Color by Number';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE53E3E);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textLight = Color(0xFFA0AEC0);
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Categories
  static const List<String> categories = [
    'Featured',
    'Animals',
    'Mandalas',
    'Floral',
    'Nature',
    'Fantasy',
    'Famous Paintings',
    'Abstract',
    'Geometric',
  ];
  
  // Difficulty Levels
  static const Map<int, String> difficultyLevels = {
    1: 'Easy',
    2: 'Medium',
    3: 'Hard',
    4: 'Expert',
  };
  
  // Canvas Settings
  static const double minZoom = 0.5;
  static const double maxZoom = 5.0;
  static const double defaultZoom = 1.0;
  
  // Storage Keys
  static const String keyUserProgress = 'user_progress';
  static const String keyUserArtworks = 'user_artworks';
  static const String keyAppSettings = 'app_settings';
  static const String keyFirstLaunch = 'first_launch';
  
  // Database
  static const String databaseName = 'color_by_number.db';
  static const int databaseVersion = 1;
  
  // Table Names
  static const String tableColoringPages = 'coloring_pages';
  static const String tableUserProgress = 'user_progress';
  static const String tableUserArtworks = 'user_artworks';
  
  // Asset Paths
  static const String assetsImages = 'assets/images/';
  static const String assetsColoringPages = 'assets/coloring_pages/';
  static const String assetsIcons = 'assets/icons/';
  static const String assetsFonts = 'assets/fonts/';
  
  // Social Media
  static const String shareText = 'Check out my amazing artwork created with Color by Number! 🎨';
  static const String appStoreUrl = 'https://apps.apple.com/app/color-by-number';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.color_by_number_app';
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryColor,
        brightness: Brightness.light,
      ),
      // fontFamily: 'Poppins', // Commented out since font files are not included
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.surfaceColor,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppConstants.surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
            vertical: AppConstants.paddingMedium,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppConstants.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: AppConstants.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: AppConstants.textLight,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}