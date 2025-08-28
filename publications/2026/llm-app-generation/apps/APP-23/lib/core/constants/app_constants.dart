class AppConstants {
  // App Information
  static const String appName = 'Google Maps';
  static const String appVersion = '1.0.0';
  
  // API Keys (In production, these should be stored securely)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String placesApiKey = 'YOUR_PLACES_API_KEY';
  
  // Map Configuration
  static const double defaultZoom = 15.0;
  static const double minZoom = 3.0;
  static const double maxZoom = 20.0;
  
  // Location Settings
  static const double locationAccuracy = 100.0; // meters
  static const int locationUpdateInterval = 5000; // milliseconds
  
  // Search Configuration
  static const int maxSearchResults = 20;
  static const int searchHistoryLimit = 10;
  
  // Navigation
  static const double routeLineWidth = 5.0;
  static const double currentLocationRadius = 8.0;
  
  // UI Constants
  static const double bottomSheetBorderRadius = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 24.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  
  // Categories for Quick Search
  static const List<Map<String, String>> searchCategories = [
    {'name': 'Restaurants', 'icon': '🍽️', 'type': 'restaurant'},
    {'name': 'Gas', 'icon': '⛽', 'type': 'gas_station'},
    {'name': 'Groceries', 'icon': '🛒', 'type': 'grocery_or_supermarket'},
    {'name': 'Coffee', 'icon': '☕', 'type': 'cafe'},
    {'name': 'Hotels', 'icon': '🏨', 'type': 'lodging'},
    {'name': 'ATM', 'icon': '🏧', 'type': 'atm'},
    {'name': 'Hospital', 'icon': '🏥', 'type': 'hospital'},
    {'name': 'Pharmacy', 'icon': '💊', 'type': 'pharmacy'},
  ];
  
  // Default Locations (San Francisco as example)
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  
  // Storage Keys
  static const String keySearchHistory = 'search_history';
  static const String keySavedPlaces = 'saved_places';
  static const String keyUserPreferences = 'user_preferences';
  static const String keyLocationPermission = 'location_permission';
  
  // Error Messages
  static const String errorLocationPermission = 'Location permission is required to use this feature';
  static const String errorLocationService = 'Location services are disabled';
  static const String errorNetworkConnection = 'No internet connection available';
  static const String errorSearchFailed = 'Search failed. Please try again';
  static const String errorRouteNotFound = 'Route not found';
  
  // Success Messages
  static const String successLocationSaved = 'Location saved successfully';
  static const String successRouteCalculated = 'Route calculated successfully';
}