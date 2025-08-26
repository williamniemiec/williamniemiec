import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Netflix Brand Colors
  static const Color netflixRed = Color(0xFFE50914);
  static const Color netflixBlack = Color(0xFF000000);
  static const Color netflixDarkGray = Color(0xFF141414);
  static const Color netflixGray = Color(0xFF333333);
  static const Color netflixLightGray = Color(0xFF564D4D);
  static const Color netflixWhite = Color(0xFFFFFFFF);
  static const Color netflixOffWhite = Color(0xFFF3F3F3);

  // Additional Colors
  static const Color successGreen = Color(0xFF46D369);
  static const Color warningYellow = Color(0xFFFFC107);
  static const Color errorRed = Color(0xFFDC3545);
  static const Color infoBlue = Color(0xFF17A2B8);

  // Text Colors
  static const Color primaryText = netflixWhite;
  static const Color secondaryText = netflixOffWhite;
  static const Color mutedText = netflixLightGray;

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(netflixRed),
      primaryColor: netflixRed,
      scaffoldBackgroundColor: netflixBlack,
      colorScheme: const ColorScheme.dark(
        primary: netflixRed,
        secondary: netflixRed,
        surface: netflixDarkGray,
        background: netflixBlack,
        error: errorRed,
        onPrimary: netflixWhite,
        onSecondary: netflixWhite,
        onSurface: netflixWhite,
        onBackground: netflixWhite,
        onError: netflixWhite,
      ),
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: netflixBlack,
        foregroundColor: netflixWhite,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: netflixWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: netflixBlack,
        selectedItemColor: netflixWhite,
        unselectedItemColor: netflixLightGray,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: netflixDarkGray,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: netflixRed,
          foregroundColor: netflixWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: netflixWhite,
          side: const BorderSide(color: netflixWhite, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: netflixWhite,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: netflixGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: netflixRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        hintStyle: const TextStyle(color: netflixLightGray),
        labelStyle: const TextStyle(color: netflixWhite),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: primaryText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: primaryText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: secondaryText,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: mutedText,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: mutedText,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: netflixWhite,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: netflixGray,
        thickness: 1,
        space: 1,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: netflixGray,
        selectedColor: netflixRed,
        disabledColor: netflixLightGray,
        labelStyle: const TextStyle(color: netflixWhite),
        secondaryLabelStyle: const TextStyle(color: netflixWhite),
        brightness: Brightness.dark,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: netflixDarkGray,
        titleTextStyle: const TextStyle(
          color: netflixWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: const TextStyle(
          color: secondaryText,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: netflixGray,
        contentTextStyle: TextStyle(color: netflixWhite),
        actionTextColor: netflixRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

// Custom Text Styles for specific Netflix UI elements
class NetflixTextStyles {
  static const TextStyle heroTitle = TextStyle(
    color: AppTheme.netflixWhite,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: AppTheme.netflixWhite,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle contentTitle = TextStyle(
    color: AppTheme.netflixWhite,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle contentSubtitle = TextStyle(
    color: AppTheme.netflixLightGray,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle buttonText = TextStyle(
    color: AppTheme.netflixWhite,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tabLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle ratingText = TextStyle(
    color: AppTheme.netflixLightGray,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle yearText = TextStyle(
    color: AppTheme.netflixLightGray,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle genreText = TextStyle(
    color: AppTheme.netflixLightGray,
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
}