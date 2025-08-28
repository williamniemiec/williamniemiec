class AppConstants {
  // App Info
  static const String appName = 'Google';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const int primaryBlue = 0xFF4285F4;
  static const int primaryRed = 0xFFEA4335;
  static const int primaryYellow = 0xFFFBBC05;
  static const int primaryGreen = 0xFF34A853;
  
  // API Endpoints
  static const String baseUrl = 'https://api.google.com';
  static const String searchEndpoint = '/search';
  static const String discoverEndpoint = '/discover';
  static const String lensEndpoint = '/lens';
  
  // Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String searchHistoryKey = 'search_history';
  static const String discoverInterestsKey = 'discover_interests';
  static const String privacySettingsKey = 'privacy_settings';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double searchBarHeight = 48.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Search Constants
  static const int maxSearchHistory = 50;
  static const int maxSearchSuggestions = 10;
  static const Duration searchDebounce = Duration(milliseconds: 300);
  
  // Lens Constants
  static const List<String> lensModes = [
    'Search',
    'Translate',
    'Text',
    'Homework',
    'Shopping',
  ];
  
  // Discover Constants
  static const int discoverPageSize = 20;
  static const Duration refreshInterval = Duration(minutes: 30);
  
  // Privacy Constants
  static const Duration incognitoTimeout = Duration(hours: 1);
  static const Duration quickDeleteDuration = Duration(minutes: 15);
}