import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(const Color(AppColors.wazeBlue)),
      primaryColor: const Color(AppColors.wazeBlue),
      scaffoldBackgroundColor: const Color(AppColors.backgroundColor),
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: Color(AppColors.wazeBlue),
        secondary: Color(AppColors.wazeOrange),
        surface: Color(AppColors.surfaceColor),
        background: Color(AppColors.backgroundColor),
        error: Color(AppColors.errorColor),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(AppColors.primaryTextColor),
        onBackground: Color(AppColors.primaryTextColor),
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(AppColors.wazeBlue),
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(AppColors.surfaceColor),
        selectedItemColor: Color(AppColors.wazeBlue),
        unselectedItemColor: Color(AppColors.secondaryTextColor),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(AppColors.wazeOrange),
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: const Color(AppColors.surfaceColor),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(AppColors.surfaceColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(AppColors.dividerColor)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(AppColors.dividerColor)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(AppColors.wazeBlue), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(AppColors.errorColor)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          color: Color(AppColors.secondaryTextColor),
          fontSize: 16,
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppColors.wazeBlue),
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(AppColors.wazeBlue),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(AppColors.wazeBlue),
          side: const BorderSide(color: Color(AppColors.wazeBlue)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: Color(AppColors.secondaryTextColor),
          fontFamily: 'Roboto',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.secondaryTextColor),
          fontFamily: 'Roboto',
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(AppColors.secondaryTextColor),
          fontFamily: 'Roboto',
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: Color(AppColors.primaryTextColor),
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: Color(AppColors.dividerColor),
        thickness: 1,
        space: 1,
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(AppColors.backgroundColor),
        selectedColor: const Color(AppColors.wazeBlue),
        disabledColor: const Color(AppColors.dividerColor),
        labelStyle: const TextStyle(
          color: Color(AppColors.primaryTextColor),
          fontSize: 14,
          fontFamily: 'Roboto',
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Roboto',
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(AppColors.surfaceColor),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          color: Color(AppColors.primaryTextColor),
          fontFamily: 'Roboto',
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(AppColors.surfaceColor),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      
      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(AppColors.primaryTextColor),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Roboto',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: Color(AppColors.wazeBlue),
        secondary: Color(AppColors.wazeOrange),
        surface: Color(0xFF1E1E1E),
        background: Color(0xFF121212),
        error: Color(AppColors.errorColor),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      textTheme: lightTheme.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
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

// Custom Colors for specific use cases
class WazeColors {
  static const Color trafficGreen = Color(AppColors.trafficGreen);
  static const Color trafficYellow = Color(AppColors.trafficYellow);
  static const Color trafficRed = Color(AppColors.trafficRed);
  static const Color trafficDarkRed = Color(AppColors.trafficDarkRed);
  
  static const Color policeBlue = Color(0xFF1976D2);
  static const Color accidentRed = Color(AppColors.errorColor);
  static const Color hazardOrange = Color(AppColors.wazeOrange);
  static const Color constructionYellow = Color(AppColors.wazeYellow);
  
  static Color getTrafficColor(String level) {
    switch (level.toLowerCase()) {
      case 'light':
        return trafficGreen;
      case 'moderate':
        return trafficYellow;
      case 'heavy':
        return trafficRed;
      case 'standstill':
        return trafficDarkRed;
      default:
        return trafficGreen;
    }
  }
  
  static Color getReportColor(String type) {
    switch (type.toLowerCase()) {
      case 'police':
        return policeBlue;
      case 'accident':
        return accidentRed;
      case 'traffic':
        return trafficRed;
      case 'hazard':
        return hazardOrange;
      case 'construction':
        return constructionYellow;
      case 'speed camera':
      case 'red light camera':
        return policeBlue;
      default:
        return hazardOrange;
    }
  }
}