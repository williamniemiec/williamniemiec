import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color spotifyBlack = Color(0xFF191414);
  static const Color spotifyDarkGrey = Color(0xFF121212);
  static const Color spotifyGrey = Color(0xFF535353);
  static const Color spotifyLightGrey = Color(0xFFB3B3B3);
  static const Color spotifyWhite = Color(0xFFFFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: spotifyGreen,
      scaffoldBackgroundColor: spotifyBlack,
      colorScheme: const ColorScheme.dark(
        primary: spotifyGreen,
        secondary: spotifyGreen,
        surface: spotifyDarkGrey,
        background: spotifyBlack,
        onPrimary: spotifyWhite,
        onSecondary: spotifyWhite,
        onSurface: spotifyWhite,
        onBackground: spotifyWhite,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: spotifyWhite,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: spotifyWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: spotifyWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            color: spotifyWhite,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: spotifyWhite,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: spotifyWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: spotifyWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: spotifyWhite,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: spotifyLightGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: spotifyWhite,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: spotifyWhite,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: spotifyLightGrey,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          labelLarge: TextStyle(
            color: spotifyWhite,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: TextStyle(
            color: spotifyLightGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            color: spotifyGrey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: spotifyWhite),
        titleTextStyle: TextStyle(
          color: spotifyWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: spotifyBlack,
        selectedItemColor: spotifyWhite,
        unselectedItemColor: spotifyGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: spotifyGreen,
          foregroundColor: spotifyWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: spotifyWhite,
          side: const BorderSide(color: spotifyGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: spotifyWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: spotifyDarkGrey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: spotifyDarkGrey,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: spotifyGrey),
        prefixIconColor: spotifyGrey,
        suffixIconColor: spotifyGrey,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: spotifyGreen,
        inactiveTrackColor: spotifyGrey,
        thumbColor: spotifyWhite,
        overlayColor: Color(0x1A1DB954),
      ),
      iconTheme: const IconThemeData(
        color: spotifyWhite,
      ),
      dividerTheme: const DividerThemeData(
        color: spotifyGrey,
        thickness: 0.5,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: spotifyGreen,
      scaffoldBackgroundColor: spotifyWhite,
      colorScheme: const ColorScheme.light(
        primary: spotifyGreen,
        secondary: spotifyGreen,
        surface: Color(0xFFF5F5F5),
        background: spotifyWhite,
        onPrimary: spotifyWhite,
        onSecondary: spotifyWhite,
        onSurface: spotifyBlack,
        onBackground: spotifyBlack,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: spotifyBlack,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: spotifyBlack,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            color: spotifyBlack,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            color: spotifyBlack,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: spotifyBlack,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: spotifyBlack,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: spotifyBlack,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: spotifyBlack,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            color: spotifyGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: spotifyBlack,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: spotifyBlack,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: spotifyGrey,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          labelLarge: TextStyle(
            color: spotifyBlack,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          labelMedium: TextStyle(
            color: spotifyGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          labelSmall: TextStyle(
            color: spotifyGrey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class AppColors {
  static const Color primary = AppTheme.spotifyGreen;
  static const Color background = AppTheme.spotifyBlack;
  static const Color surface = AppTheme.spotifyDarkGrey;
  static const Color onPrimary = AppTheme.spotifyWhite;
  static const Color onBackground = AppTheme.spotifyWhite;
  static const Color onSurface = AppTheme.spotifyWhite;
  static const Color grey = AppTheme.spotifyGrey;
  static const Color lightGrey = AppTheme.spotifyLightGrey;
  
  // Additional colors for specific use cases
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF1DB954),
    Color(0xFF1ED760),
  ];
  
  static const List<Color> darkGradient = [
    Color(0xFF191414),
    Color(0xFF121212),
  ];
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.lightGrey,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );
}