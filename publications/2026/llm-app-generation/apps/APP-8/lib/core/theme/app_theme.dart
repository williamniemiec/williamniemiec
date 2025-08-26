import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryGreen,
        brightness: Brightness.light,
      ),
      textTheme: _textTheme,
      appBarTheme: _appBarTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      cardTheme: _cardTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      chipTheme: _chipTheme,
      dialogTheme: _dialogTheme,
      snackBarTheme: _snackBarTheme,
      floatingActionButtonTheme: _floatingActionButtonTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.primaryGreen,
        brightness: Brightness.dark,
      ),
      textTheme: _textTheme,
      appBarTheme: _appBarThemeDark,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      textButtonTheme: _textButtonTheme,
      cardTheme: _cardThemeDark,
      bottomNavigationBarTheme: _bottomNavigationBarThemeDark,
      progressIndicatorTheme: _progressIndicatorTheme,
      chipTheme: _chipThemeDark,
      dialogTheme: _dialogThemeDark,
      snackBarTheme: _snackBarThemeDark,
      floatingActionButtonTheme: _floatingActionButtonTheme,
    );
  }

  static TextTheme get _textTheme {
    return GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppConstants.black,
      ),
      displayMedium: GoogleFonts.nunito(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppConstants.black,
      ),
      displaySmall: GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppConstants.black,
      ),
      headlineLarge: GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppConstants.black,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppConstants.black,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppConstants.black,
      ),
      titleLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppConstants.black,
      ),
      titleMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppConstants.black,
      ),
      titleSmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppConstants.black,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppConstants.black,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppConstants.black,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppConstants.darkGray,
      ),
      labelLarge: GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppConstants.white,
      ),
      labelMedium: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppConstants.white,
      ),
      labelSmall: GoogleFonts.nunito(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppConstants.white,
      ),
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      backgroundColor: AppConstants.white,
      foregroundColor: AppConstants.black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConstants.black,
      ),
      iconTheme: const IconThemeData(
        color: AppConstants.black,
        size: 24,
      ),
    );
  }

  static AppBarTheme get _appBarThemeDark {
    return AppBarTheme(
      backgroundColor: AppConstants.black,
      foregroundColor: AppConstants.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConstants.white,
      ),
      iconTheme: const IconThemeData(
        color: AppConstants.white,
        size: 24,
      ),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: AppConstants.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppConstants.primaryGreen,
        side: const BorderSide(
          color: AppConstants.primaryGreen,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppConstants.primaryGreen,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        textStyle: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static CardThemeData get _cardTheme {
    return CardThemeData(
      color: AppConstants.white,
      elevation: 2,
      shadowColor: AppConstants.gray.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      margin: const EdgeInsets.all(AppConstants.spacingS),
    );
  }

  static CardThemeData get _cardThemeDark {
    return CardThemeData(
      color: AppConstants.darkGray,
      elevation: 2,
      shadowColor: AppConstants.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      margin: const EdgeInsets.all(AppConstants.spacingS),
    );
  }

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: AppConstants.white,
      selectedItemColor: AppConstants.primaryGreen,
      unselectedItemColor: AppConstants.gray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static BottomNavigationBarThemeData get _bottomNavigationBarThemeDark {
    return const BottomNavigationBarThemeData(
      backgroundColor: AppConstants.black,
      selectedItemColor: AppConstants.primaryGreen,
      unselectedItemColor: AppConstants.gray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static ProgressIndicatorThemeData get _progressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: AppConstants.primaryGreen,
      linearTrackColor: AppConstants.lightGray,
    );
  }

  static ChipThemeData get _chipTheme {
    return ChipThemeData(
      backgroundColor: AppConstants.lightGray,
      selectedColor: AppConstants.primaryGreen,
      labelStyle: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS,
        vertical: AppConstants.spacingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
    );
  }

  static ChipThemeData get _chipThemeDark {
    return ChipThemeData(
      backgroundColor: AppConstants.darkGray,
      selectedColor: AppConstants.primaryGreen,
      labelStyle: GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppConstants.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS,
        vertical: AppConstants.spacingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
    );
  }

  static DialogThemeData get _dialogTheme {
    return DialogThemeData(
      backgroundColor: AppConstants.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConstants.black,
      ),
      contentTextStyle: GoogleFonts.nunito(
        fontSize: 14,
        color: AppConstants.black,
      ),
    );
  }

  static DialogThemeData get _dialogThemeDark {
    return DialogThemeData(
      backgroundColor: AppConstants.darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppConstants.white,
      ),
      contentTextStyle: GoogleFonts.nunito(
        fontSize: 14,
        color: AppConstants.white,
      ),
    );
  }

  static SnackBarThemeData get _snackBarTheme {
    return SnackBarThemeData(
      backgroundColor: AppConstants.black,
      contentTextStyle: GoogleFonts.nunito(
        fontSize: 14,
        color: AppConstants.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  static SnackBarThemeData get _snackBarThemeDark {
    return SnackBarThemeData(
      backgroundColor: AppConstants.white,
      contentTextStyle: GoogleFonts.nunito(
        fontSize: 14,
        color: AppConstants.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }

  static FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: AppConstants.primaryGreen,
      foregroundColor: AppConstants.white,
      elevation: 4,
      shape: CircleBorder(),
    );
  }

  // Custom Colors for specific use cases
  static const Color correctAnswerColor = AppConstants.primaryGreen;
  static const Color incorrectAnswerColor = AppConstants.red;
  static const Color warningColor = AppConstants.orange;
  static const Color infoColor = AppConstants.blue;
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppConstants.primaryGreen, AppConstants.lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [AppConstants.blue, AppConstants.darkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppConstants.gray.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: AppConstants.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
}