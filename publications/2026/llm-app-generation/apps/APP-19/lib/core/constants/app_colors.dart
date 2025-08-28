import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Healthcare Blue Theme
  static const Color primary = Color(0xFF0066CC);
  static const Color primaryLight = Color(0xFF3399FF);
  static const Color primaryDark = Color(0xFF004499);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF00A86B);
  static const Color secondaryLight = Color(0xFF33CC88);
  static const Color secondaryDark = Color(0xFF007A4D);
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  
  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF17A2B8);
  
  // Card and Border Colors
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE9ECEF);
  static const Color borderMedium = Color(0xFFDEE2E6);
  static const Color divider = Color(0xFFE0E0E0);
  
  // Health-specific Colors
  static const Color healthGreen = Color(0xFF4CAF50);
  static const Color healthYellow = Color(0xFFFF9800);
  static const Color healthRed = Color(0xFFF44336);
  static const Color healthBlue = Color(0xFF2196F3);
  
  // Appointment Status Colors
  static const Color appointmentScheduled = Color(0xFF2196F3);
  static const Color appointmentConfirmed = Color(0xFF4CAF50);
  static const Color appointmentCancelled = Color(0xFFF44336);
  static const Color appointmentCompleted = Color(0xFF9E9E9E);
  
  // Message Status Colors
  static const Color messageUnread = Color(0xFF0066CC);
  static const Color messageRead = Color(0xFF6C757D);
  static const Color messageUrgent = Color(0xFFDC3545);
  
  // Test Result Colors
  static const Color testNormal = Color(0xFF28A745);
  static const Color testAbnormal = Color(0xFFDC3545);
  static const Color testPending = Color(0xFFFFC107);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}