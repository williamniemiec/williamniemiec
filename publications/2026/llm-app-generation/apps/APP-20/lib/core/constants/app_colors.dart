import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Based on Brazilian Government branding
  static const Color primary = Color(0xFF0F4C75); // Dark Blue
  static const Color primaryLight = Color(0xFF3282B8); // Light Blue
  static const Color primaryDark = Color(0xFF0A3A5C); // Darker Blue
  
  // Secondary Colors
  static const Color secondary = Color(0xFF00A859); // Green (SUS Green)
  static const Color secondaryLight = Color(0xFF4CAF50); // Light Green
  static const Color secondaryDark = Color(0xFF00783E); // Dark Green
  
  // Accent Colors
  static const Color accent = Color(0xFFFFB300); // Amber/Yellow
  static const Color accentLight = Color(0xFFFFC947); // Light Amber
  
  // Background Colors
  static const Color background = Color(0xFFF5F5F5); // Light Gray
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color surfaceVariant = Color(0xFFF8F9FA); // Very Light Gray
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212529); // Dark Gray
  static const Color textSecondary = Color(0xFF6C757D); // Medium Gray
  static const Color textLight = Color(0xFF9E9E9E); // Light Gray
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White
  static const Color textOnSecondary = Color(0xFFFFFFFF); // White
  
  // Status Colors
  static const Color success = Color(0xFF28A745); // Green
  static const Color warning = Color(0xFFFFC107); // Yellow
  static const Color error = Color(0xFFDC3545); // Red
  static const Color info = Color(0xFF17A2B8); // Cyan
  
  // Card and Component Colors
  static const Color cardBackground = Color(0xFFFFFFFF); // White
  static const Color cardShadow = Color(0x1A000000); // Black with 10% opacity
  static const Color divider = Color(0xFFE0E0E0); // Light Gray
  static const Color border = Color(0xFFDEE2E6); // Light Gray Border
  
  // Vaccination Certificate Colors
  static const Color certificateBackground = Color(0xFFFFFFFF); // White
  static const Color certificateBorder = Color(0xFF0F4C75); // Primary Blue
  static const Color qrCodeBackground = Color(0xFFFFFFFF); // White
  
  // Bottom Navigation Colors
  static const Color bottomNavBackground = Color(0xFFFFFFFF); // White
  static const Color bottomNavSelected = Color(0xFF0F4C75); // Primary Blue
  static const Color bottomNavUnselected = Color(0xFF9E9E9E); // Light Gray
  
  // Button Colors
  static const Color buttonPrimary = Color(0xFF0F4C75); // Primary Blue
  static const Color buttonSecondary = Color(0xFF00A859); // Secondary Green
  static const Color buttonDisabled = Color(0xFFE0E0E0); // Light Gray
  static const Color buttonText = Color(0xFFFFFFFF); // White
  
  // Input Field Colors
  static const Color inputBackground = Color(0xFFF8F9FA); // Very Light Gray
  static const Color inputBorder = Color(0xFFDEE2E6); // Light Gray
  static const Color inputFocused = Color(0xFF0F4C75); // Primary Blue
  static const Color inputError = Color(0xFFDC3545); // Red
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryLight],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface, surfaceVariant],
  );
  
  // Health Service Category Colors
  static const Color vaccineColor = Color(0xFF4CAF50); // Green
  static const Color examColor = Color(0xFF2196F3); // Blue
  static const Color medicationColor = Color(0xFFFF9800); // Orange
  static const Color appointmentColor = Color(0xFF9C27B0); // Purple
  static const Color donorColor = Color(0xFFE91E63); // Pink
  
  // Opacity Values
  static const double lowOpacity = 0.1;
  static const double mediumOpacity = 0.3;
  static const double highOpacity = 0.7;
}