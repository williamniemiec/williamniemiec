class AppConstants {
  // App Information
  static const String appName = 'Google Home';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const int primaryColorValue = 0xFF4285F4;
  static const int secondaryColorValue = 0xFF34A853;
  static const int accentColorValue = 0xFFEA4335;
  static const int warningColorValue = 0xFFFBBC04;
  
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Device Types
  static const List<String> deviceTypes = [
    'Light',
    'Thermostat',
    'Camera',
    'Speaker',
    'Display',
    'Smart Plug',
    'Lock',
    'Sensor',
    'Switch',
    'Fan',
  ];
  
  // Room Types
  static const List<String> roomTypes = [
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Bathroom',
    'Dining Room',
    'Office',
    'Garage',
    'Basement',
    'Attic',
    'Hallway',
    'Outdoor',
  ];
  
  // Device Categories for Spaces
  static const List<String> deviceCategories = [
    'Cameras',
    'Lighting',
    'Climate',
    'Security',
    'Entertainment',
    'Wifi',
  ];
  
  // Routine Starters
  static const List<String> routineStarters = [
    'Voice command',
    'Time of day',
    'Sunrise',
    'Sunset',
    'Device state change',
    'Location',
  ];
  
  // Routine Actions
  static const List<String> routineActions = [
    'Adjust lights',
    'Set thermostat',
    'Play media',
    'Broadcast message',
    'Control devices',
    'Send notification',
  ];
  
  // API Endpoints (Mock)
  static const String baseUrl = 'https://api.googlehome.com';
  static const String devicesEndpoint = '/devices';
  static const String routinesEndpoint = '/routines';
  static const String activityEndpoint = '/activity';
  
  // Shared Preferences Keys
  static const String keyFirstLaunch = 'first_launch';
  static const String keyUserName = 'user_name';
  static const String keyHomeName = 'home_name';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  
  // Default Values
  static const String defaultHomeName = 'My Home';
  static const String defaultUserName = 'User';
  
  // Error Messages
  static const String errorGeneral = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorDeviceNotFound = 'Device not found.';
  static const String errorPermissionDenied = 'Permission denied.';
}