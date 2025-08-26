import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Blood Pressure Tracker';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Track and monitor your blood pressure readings';

  // Database
  static const String databaseName = 'blood_pressure_app.db';
  static const int databaseVersion = 1;

  // Shared Preferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserName = 'user_name';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyThemeMode = 'theme_mode';

  // Blood Pressure Categories
  static const Map<String, Color> categoryColors = {
    'normal': Color(0xFF4CAF50),
    'elevated': Color(0xFFFF9800),
    'hypertensionStage1': Color(0xFFFF5722),
    'hypertensionStage2': Color(0xFFF44336),
    'hypertensiveCrisis': Color(0xFF9C27B0),
  };

  // Common Tags
  static const List<String> commonTags = [
    'Morning',
    'Evening',
    'Before Meal',
    'After Meal',
    'Sitting',
    'Standing',
    'Left Arm',
    'Right Arm',
    'Stressed',
    'Relaxed',
    'After Exercise',
    'Before Sleep',
  ];

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFFE91E63), // Pink
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Cyan
  ];

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Spacing
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Border Radius
  static const double smallBorderRadius = 8.0;
  static const double mediumBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;

  // Icon Sizes
  static const double smallIconSize = 16.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 32.0;
  static const double extraLargeIconSize = 48.0;

  // Blood Pressure Ranges
  static const Map<String, Map<String, int>> bloodPressureRanges = {
    'normal': {'systolicMax': 119, 'diastolicMax': 79},
    'elevated': {'systolicMin': 120, 'systolicMax': 129, 'diastolicMax': 79},
    'hypertensionStage1': {
      'systolicMin': 130,
      'systolicMax': 139,
      'diastolicMin': 80,
      'diastolicMax': 89
    },
    'hypertensionStage2': {'systolicMin': 140, 'diastolicMin': 90},
    'hypertensiveCrisis': {'systolicMin': 180, 'diastolicMin': 120},
  };

  // Notification Settings
  static const String notificationChannelId = 'blood_pressure_reminders';
  static const String notificationChannelName = 'Blood Pressure Reminders';
  static const String notificationChannelDescription = 'Reminders to measure blood pressure';

  // Export Settings
  static const String exportFilePrefix = 'blood_pressure_report';
  static const String exportDateFormat = 'yyyy-MM-dd_HH-mm-ss';

  // Validation
  static const int minSystolicValue = 50;
  static const int maxSystolicValue = 300;
  static const int minDiastolicValue = 30;
  static const int maxDiastolicValue = 200;
  static const int minPulseValue = 30;
  static const int maxPulseValue = 220;

  // Chart Settings
  static const int maxChartDataPoints = 100;
  static const double chartLineWidth = 2.0;
  static const double chartDotSize = 4.0;

  // Time Filters
  static const List<String> timeFilters = [
    'Week',
    'Month',
    '3 Months',
    '6 Months',
    'Year',
    'All',
  ];

  // Days of Week
  static const List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // Error Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNoData = 'No data available.';
  static const String errorInvalidInput = 'Please enter valid values.';
  static const String errorDatabaseConnection = 'Database connection failed.';
  static const String errorPermissionDenied = 'Permission denied.';
  static const String errorNetworkConnection = 'Network connection failed.';

  // Success Messages
  static const String successReadingSaved = 'Reading saved successfully!';
  static const String successReminderSet = 'Reminder set successfully!';
  static const String successReportGenerated = 'Report generated successfully!';
  static const String successDataExported = 'Data exported successfully!';

  // Disclaimer Text
  static const String disclaimerText = '''
This app does not measure blood pressure. It is a tracking tool that requires you to input readings taken from a separate, medically-approved blood pressure monitor. This app is intended for informational purposes and should not be used as a substitute for professional medical advice. Always consult with your healthcare provider regarding your blood pressure readings and health concerns.
''';

  // About Text
  static const String aboutText = '''
Blood Pressure Tracker helps you monitor and track your cardiovascular health by providing an easy-to-use digital logbook for your blood pressure readings. 

Features:
• Manual data entry for blood pressure and pulse
• Automatic categorization of readings
• Historical tracking and trends
• Visual charts and statistics
• PDF report generation
• Reminder notifications
• Educational health content

Remember to always use a medically-approved blood pressure monitor for accurate readings.
''';
}