import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Pinterest Brand Colors
  static const Color pinterestRed = Color(0xFFE60023);
  static const Color pinterestRedDark = Color(0xFFBD081C);
  static const Color pinterestRedLight = Color(0xFFFF4757);

  // Primary Colors
  static const Color primaryColor = pinterestRed;
  static const Color primaryColorDark = pinterestRedDark;
  static const Color primaryColorLight = pinterestRedLight;

  // Secondary Colors
  static const Color secondaryColor = Color(0xFF767676);
  static const Color secondaryColorDark = Color(0xFF5A5A5A);
  static const Color secondaryColorLight = Color(0xFF9E9E9E);

  // Background Colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color backgroundColorDark = Color(0xFF121212);
  static const Color surfaceColor = Color(0xFFFAFAFA);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF767676);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);

  // Accent Colors
  static const Color accentBlue = Color(0xFF0084FF);
  static const Color accentGreen = Color(0xFF00C851);
  static const Color accentOrange = Color(0xFFFF8A00);
  static const Color accentPurple = Color(0xFF8E24AA);
  static const Color accentTeal = Color(0xFF00BCD4);

  // Status Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);
  static const Color shadowColorDark = Color(0x3A000000);

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color borderColorDark = Color(0xFF333333);

  // Overlay Colors
  static const Color overlayColor = Color(0x80000000);
  static const Color overlayColorLight = Color(0x40000000);

  // Typography
  static const String fontFamily = 'Pinterest';
  static const String fallbackFontFamily = 'Roboto';

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Font Sizes
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;
  static const double fontSizeXXXLarge = 24.0;
  static const double fontSizeTitle = 28.0;
  static const double fontSizeHeading = 32.0;

  // Spacing
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  static const double spacingXXLarge = 48.0;

  // Border Radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 50.0;

  // Elevation
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Button Heights
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 44.0;
  static const double buttonHeightLarge = 56.0;

  // App Bar Height
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;

  // Bottom Navigation Height
  static const double bottomNavHeight = 60.0;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(primaryColor),
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      scaffoldBackgroundColor: backgroundColor,
      cardColor: white,
      dividerColor: borderColor,
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: primaryColorLight,
        secondary: secondaryColor,
        secondaryContainer: grey200,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: white,
        onSecondary: white,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: white,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: white,
        foregroundColor: textPrimary,
        elevation: elevationSmall,
        shadowColor: shadowColor,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: fontSizeLarge,
          fontWeight: fontWeightSemiBold,
          fontFamily: fontFamily,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // Bottom Navigation Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryColor,
        unselectedItemColor: grey500,
        type: BottomNavigationBarType.fixed,
        elevation: elevationMedium,
        selectedLabelStyle: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: fontWeightMedium,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: fontWeightRegular,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeHeading,
          fontWeight: fontWeightBold,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeTitle,
          fontWeight: fontWeightBold,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        displaySmall: TextStyle(
          fontSize: fontSizeXXXLarge,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        headlineLarge: TextStyle(
          fontSize: fontSizeXXLarge,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          fontSize: fontSizeXLarge,
          fontWeight: fontWeightMedium,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        headlineSmall: TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: fontWeightMedium,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: fontWeightSemiBold,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: fontWeightMedium,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        titleSmall: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: fontWeightMedium,
          color: textSecondary,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeLarge,
          fontWeight: fontWeightRegular,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: fontWeightRegular,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        bodySmall: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: fontWeightRegular,
          color: textSecondary,
          fontFamily: fontFamily,
        ),
        labelLarge: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: fontWeightMedium,
          color: textPrimary,
          fontFamily: fontFamily,
        ),
        labelMedium: TextStyle(
          fontSize: fontSizeSmall,
          fontWeight: fontWeightMedium,
          color: textSecondary,
          fontFamily: fontFamily,
        ),
        labelSmall: TextStyle(
          fontSize: fontSizeXSmall,
          fontWeight: fontWeightRegular,
          color: textTertiary,
          fontFamily: fontFamily,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          elevation: elevationSmall,
          shadowColor: shadowColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          minimumSize: const Size(double.infinity, buttonHeightMedium),
          textStyle: const TextStyle(
            fontSize: fontSizeMedium,
            fontWeight: fontWeightSemiBold,
            fontFamily: fontFamily,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          minimumSize: const Size(double.infinity, buttonHeightMedium),
          textStyle: const TextStyle(
            fontSize: fontSizeMedium,
            fontWeight: fontWeightSemiBold,
            fontFamily: fontFamily,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          minimumSize: const Size(0, buttonHeightMedium),
          textStyle: const TextStyle(
            fontSize: fontSizeMedium,
            fontWeight: fontWeightSemiBold,
            fontFamily: fontFamily,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          borderSide: const BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          borderSide: const BorderSide(color: errorColor, width: 1.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMedium,
          vertical: spacingMedium,
        ),
        hintStyle: const TextStyle(
          color: textTertiary,
          fontSize: fontSizeMedium,
          fontFamily: fontFamily,
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: fontSizeMedium,
          fontFamily: fontFamily,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: white,
        elevation: elevationSmall,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        margin: const EdgeInsets.all(spacingSmall),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: grey200,
        selectedColor: primaryColor,
        labelStyle: const TextStyle(
          color: textPrimary,
          fontSize: fontSizeSmall,
          fontFamily: fontFamily,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCircular),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: white,
        elevation: elevationLarge,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
        ),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: fontSizeXLarge,
          fontWeight: fontWeightSemiBold,
          fontFamily: fontFamily,
        ),
        contentTextStyle: const TextStyle(
          color: textSecondary,
          fontSize: fontSizeMedium,
          fontFamily: fontFamily,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: white,
        elevation: elevationMedium,
        shape: CircleBorder(),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: textSecondary,
        size: iconSizeMedium,
      ),

      primaryIconTheme: const IconThemeData(
        color: white,
        size: iconSizeMedium,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1.0,
        space: 1.0,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return grey400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColorLight;
          }
          return grey300;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return grey400;
        }),
        checkColor: MaterialStateProperty.all(white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return grey400;
        }),
      ),

      // Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: grey300,
        thumbColor: primaryColor,
        overlayColor: primaryColorLight,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
        linearTrackColor: grey300,
        circularTrackColor: grey300,
      ),

      // Tab Bar Theme
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textSecondary,
        indicatorColor: primaryColor,
        labelStyle: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: fontWeightSemiBold,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: fontSizeMedium,
          fontWeight: fontWeightRegular,
          fontFamily: fontFamily,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: grey800,
        contentTextStyle: const TextStyle(
          color: white,
          fontSize: fontSizeMedium,
          fontFamily: fontFamily,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundColorDark,
      cardColor: surfaceColorDark,
      dividerColor: borderColorDark,
      
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        primaryContainer: primaryColorDark,
        secondary: secondaryColorDark,
        secondaryContainer: grey700,
        surface: surfaceColorDark,
        background: backgroundColorDark,
        error: errorColor,
        onPrimary: white,
        onSecondary: white,
        onSurface: textPrimaryDark,
        onBackground: textPrimaryDark,
        onError: white,
      ),

      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: surfaceColorDark,
        foregroundColor: textPrimaryDark,
        titleTextStyle: lightTheme.appBarTheme.titleTextStyle?.copyWith(
          color: textPrimaryDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
        backgroundColor: surfaceColorDark,
        unselectedItemColor: grey500,
      ),

      textTheme: lightTheme.textTheme.apply(
        bodyColor: textPrimaryDark,
        displayColor: textPrimaryDark,
      ),

      cardTheme: lightTheme.cardTheme.copyWith(
        color: surfaceColorDark,
      ),

      dialogTheme: lightTheme.dialogTheme.copyWith(
        backgroundColor: surfaceColorDark,
        titleTextStyle: lightTheme.dialogTheme.titleTextStyle?.copyWith(
          color: textPrimaryDark,
        ),
        contentTextStyle: lightTheme.dialogTheme.contentTextStyle?.copyWith(
          color: textSecondaryDark,
        ),
      ),

      iconTheme: lightTheme.iconTheme.copyWith(
        color: textSecondaryDark,
      ),

      dividerTheme: lightTheme.dividerTheme.copyWith(
        color: borderColorDark,
      ),

      snackBarTheme: lightTheme.snackBarTheme.copyWith(
        backgroundColor: grey200,
        contentTextStyle: lightTheme.snackBarTheme.contentTextStyle?.copyWith(
          color: textPrimary,
        ),
      ),
    );
  }

  // Helper method to create MaterialColor
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

// Custom Text Styles
class AppTextStyles {
  static const TextStyle pinTitle = TextStyle(
    fontSize: AppTheme.fontSizeMedium,
    fontWeight: AppTheme.fontWeightSemiBold,
    color: AppTheme.textPrimary,
    fontFamily: AppTheme.fontFamily,
  );

  static const TextStyle pinDescription = TextStyle(
    fontSize: AppTheme.fontSizeSmall,
    fontWeight: AppTheme.fontWeightRegular,
    color: AppTheme.textSecondary,
    fontFamily: AppTheme.fontFamily,
  );

  static const TextStyle username = TextStyle(
    fontSize: AppTheme.fontSizeSmall,
    fontWeight: AppTheme.fontWeightMedium,
    color: AppTheme.textPrimary,
    fontFamily: AppTheme.fontFamily,
  );

  static const TextStyle boardTitle = TextStyle(
    fontSize: AppTheme.fontSizeLarge,
    fontWeight: AppTheme.fontWeightSemiBold,
    color: AppTheme.textPrimary,
    fontFamily: AppTheme.fontFamily,
  );

  static const TextStyle searchHint = TextStyle(
    fontSize: AppTheme.fontSizeMedium,
    fontWeight: AppTheme.fontWeightRegular,
    color: AppTheme.textTertiary,
    fontFamily: AppTheme.fontFamily,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: AppTheme.fontSizeMedium,
    fontWeight: AppTheme.fontWeightSemiBold,
    color: AppTheme.white,
    fontFamily: AppTheme.fontFamily,
  );

  static const TextStyle caption = TextStyle(
    fontSize: AppTheme.fontSizeXSmall,
    fontWeight: AppTheme.fontWeightRegular,
    color: AppTheme.textTertiary,
    fontFamily: AppTheme.fontFamily,
  );
}

// Custom Decorations
class AppDecorations {
  static BoxDecoration pinCardDecoration = BoxDecoration(
    color: AppTheme.white,
    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
    boxShadow: const [
      BoxShadow(
        color: AppTheme.shadowColor,
        blurRadius: AppTheme.elevationSmall,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration searchBarDecoration = BoxDecoration(
    color: AppTheme.grey100,
    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
  );

  static BoxDecoration bottomSheetDecoration = const BoxDecoration(
    color: AppTheme.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(AppTheme.radiusLarge),
      topRight: Radius.circular(AppTheme.radiusLarge),
    ),
  );
}