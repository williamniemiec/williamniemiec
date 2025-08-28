import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (YouTube Music Brand Colors)
  static const Color primary = Color(0xFFFF0000); // YouTube Red
  static const Color primaryDark = Color(0xFFCC0000);
  static const Color primaryLight = Color(0xFFFF3333);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF282828); // Dark Gray
  static const Color secondaryDark = Color(0xFF1A1A1A);
  static const Color secondaryLight = Color(0xFF404040);

  // Background Colors - Dark Theme (Primary)
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF282828);
  static const Color bottomNavDark = Color(0xFF1A1A1A);
  
  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF5F5F5);
  static const Color bottomNavLight = Color(0xFFFFFFFF);

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  static const Color textTertiaryDark = Color(0xFF808080);
  static const Color textDisabledDark = Color(0xFF4D4D4D);

  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textTertiaryLight = Color(0xFF9E9E9E);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  // Accent Colors
  static const Color accent = Color(0xFF1DB954); // Spotify Green (for liked songs)
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentOrange = Color(0xFFFF9800);
  static const Color accentTeal = Color(0xFF009688);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Player Colors
  static const Color playerBackground = Color(0xFF000000);
  static const Color playerSurface = Color(0xFF1A1A1A);
  static const Color progressBarActive = Color(0xFFFFFFFF);
  static const Color progressBarInactive = Color(0xFF404040);
  static const Color playerButton = Color(0xFFFFFFFF);
  static const Color playerButtonDisabled = Color(0xFF808080);

  // Premium Colors
  static const Color premiumGold = Color(0xFFFFD700);
  static const Color premiumGradientStart = Color(0xFFFFD700);
  static const Color premiumGradientEnd = Color(0xFFFFA500);

  // Overlay Colors
  static const Color overlayDark = Color(0x80000000);
  static const Color overlayLight = Color(0x80FFFFFF);
  static const Color scrimDark = Color(0xB3000000);
  static const Color scrimLight = Color(0xB3FFFFFF);

  // Border Colors
  static const Color borderDark = Color(0xFF404040);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF2A2A2A);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // Shimmer Colors
  static const Color shimmerBaseDark = Color(0xFF2A2A2A);
  static const Color shimmerHighlightDark = Color(0xFF404040);
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);

  // Genre Colors
  static const Map<String, Color> genreColors = {
    'Pop': Color(0xFFE91E63),
    'Rock': Color(0xFF795548),
    'Hip Hop': Color(0xFF9C27B0),
    'Electronic': Color(0xFF00BCD4),
    'Country': Color(0xFFFF9800),
    'R&B': Color(0xFF673AB7),
    'Jazz': Color(0xFF3F51B5),
    'Classical': Color(0xFF607D8B),
    'Reggae': Color(0xFF4CAF50),
    'Folk': Color(0xFF8BC34A),
    'Blues': Color(0xFF2196F3),
    'Punk': Color(0xFFF44336),
    'Metal': Color(0xFF424242),
    'Alternative': Color(0xFF9E9E9E),
    'Indie': Color(0xFFFF5722),
  };

  // Mood Colors
  static const Map<String, Color> moodColors = {
    'Happy': Color(0xFFFFEB3B),
    'Sad': Color(0xFF3F51B5),
    'Energetic': Color(0xFFFF5722),
    'Chill': Color(0xFF00BCD4),
    'Focus': Color(0xFF9C27B0),
    'Workout': Color(0xFFF44336),
    'Party': Color(0xFFE91E63),
    'Romance': Color(0xFFE91E63),
    'Sleep': Color(0xFF673AB7),
    'Study': Color(0xFF607D8B),
    'Motivation': Color(0xFFFF9800),
    'Relaxation': Color(0xFF4CAF50),
  };

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFFF0000),
    Color(0xFFCC0000),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF121212),
    Color(0xFF000000),
  ];

  static const List<Color> premiumGradient = [
    Color(0xFFFFD700),
    Color(0xFFFFA500),
  ];

  static const List<Color> playerGradient = [
    Color(0xFF000000),
    Color(0xFF1A1A1A),
  ];

  // Social Colors
  static const Color facebook = Color(0xFF1877F2);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color instagram = Color(0xFFE4405F);
  static const Color youtube = Color(0xFFFF0000);
  static const Color spotify = Color(0xFF1DB954);
  static const Color appleMusic = Color(0xFFFA243C);

  // Utility Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  static LinearGradient createGradient(List<Color> colors, {
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors,
    );
  }

  static RadialGradient createRadialGradient(List<Color> colors, {
    AlignmentGeometry center = Alignment.center,
    double radius = 0.5,
  }) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: colors,
    );
  }
}