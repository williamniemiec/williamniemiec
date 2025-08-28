class AppConstants {
  // App Information
  static const String appName = 'Waze';
  static const String appVersion = '1.0.0';
  
  // API Keys (Replace with actual keys)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  static const String placesApiKey = 'YOUR_PLACES_API_KEY';
  
  // Map Configuration
  static const double defaultZoom = 15.0;
  static const double navigationZoom = 18.0;
  static const double maxZoom = 20.0;
  static const double minZoom = 5.0;
  
  // Location Settings
  static const double locationAccuracy = 10.0; // meters
  static const int locationUpdateInterval = 5000; // milliseconds
  static const int fastestLocationInterval = 2000; // milliseconds
  
  // Navigation Settings
  static const double routeRecalculationThreshold = 50.0; // meters
  static const int voiceInstructionDistance = 200; // meters
  static const double arrivalThreshold = 20.0; // meters
  
  // Report Settings
  static const int reportExpirationTime = 30; // minutes
  static const double reportVisibilityRadius = 5000.0; // meters
  static const int maxReportsPerUser = 10;
  
  // UI Constants
  static const double bottomSheetHeight = 300.0;
  static const double searchBarHeight = 56.0;
  static const double reportButtonSize = 60.0;
  static const double speedometerSize = 80.0;
  
  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 400;
  static const int longAnimationDuration = 800;
  
  // Storage Keys
  static const String userPrefsKey = 'user_preferences';
  static const String savedPlacesKey = 'saved_places';
  static const String recentSearchesKey = 'recent_searches';
  static const String userProfileKey = 'user_profile';
  
  // Network Settings
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds
  static const String baseUrl = 'https://api.waze.com/v1';
  
  // Audio Settings
  static const double defaultVolume = 0.8;
  static const String defaultVoice = 'en-US';
  
  // Speed Limits and Alerts
  static const double speedLimitTolerance = 5.0; // km/h
  static const double speedWarningThreshold = 10.0; // km/h over limit
  
  // Report Types
  static const List<String> reportTypes = [
    'Police',
    'Accident',
    'Traffic',
    'Hazard',
    'Construction',
    'Speed Camera',
    'Red Light Camera',
  ];
  
  // Traffic Levels
  static const List<String> trafficLevels = [
    'Light',
    'Moderate',
    'Heavy',
    'Standstill',
  ];
  
  // Voice Commands
  static const List<String> voiceCommands = [
    'Navigate to',
    'Report police',
    'Report accident',
    'Report traffic',
    'Go home',
    'Go to work',
    'Find gas station',
    'Find parking',
  ];
}

class AppColors {
  // Primary Colors
  static const int wazeBlue = 0xFF00D4FF;
  static const int wazeOrange = 0xFFFF6B35;
  static const int wazeGreen = 0xFF00C851;
  static const int wazeRed = 0xFFFF4444;
  static const int wazeYellow = 0xFFFFBB33;
  
  // Map Colors
  static const int roadColor = 0xFF4A90E2;
  static const int trafficGreen = 0xFF00C851;
  static const int trafficYellow = 0xFFFFBB33;
  static const int trafficRed = 0xFFFF4444;
  static const int trafficDarkRed = 0xFFCC0000;
  
  // UI Colors
  static const int backgroundColor = 0xFFF5F5F5;
  static const int surfaceColor = 0xFFFFFFFF;
  static const int primaryTextColor = 0xFF212121;
  static const int secondaryTextColor = 0xFF757575;
  static const int dividerColor = 0xFFE0E0E0;
  
  // Status Colors
  static const int successColor = 0xFF4CAF50;
  static const int warningColor = 0xFFFF9800;
  static const int errorColor = 0xFFF44336;
  static const int infoColor = 0xFF2196F3;
}

class AppStrings {
  // Navigation
  static const String whereToHint = 'Where to?';
  static const String searchPlaces = 'Search places';
  static const String home = 'Home';
  static const String work = 'Work';
  static const String goNow = 'Go now';
  static const String routes = 'Routes';
  static const String eta = 'ETA';
  static const String distance = 'Distance';
  static const String duration = 'Duration';
  
  // Reports
  static const String reportHazard = 'Report';
  static const String police = 'Police';
  static const String accident = 'Accident';
  static const String traffic = 'Traffic';
  static const String hazard = 'Hazard';
  static const String construction = 'Construction';
  static const String speedCamera = 'Speed Camera';
  static const String redLightCamera = 'Red Light Camera';
  static const String reportSent = 'Report sent!';
  static const String thankYou = 'Thank you for helping the community';
  
  // Voice Instructions
  static const String turnLeft = 'Turn left';
  static const String turnRight = 'Turn right';
  static const String goStraight = 'Continue straight';
  static const String makeUTurn = 'Make a U-turn';
  static const String exitRight = 'Take the exit on the right';
  static const String exitLeft = 'Take the exit on the left';
  static const String arrivedDestination = 'You have arrived at your destination';
  static const String recalculating = 'Recalculating route';
  
  // Alerts
  static const String policeAhead = 'Police reported ahead';
  static const String accidentAhead = 'Accident reported ahead';
  static const String trafficAhead = 'Heavy traffic ahead';
  static const String hazardAhead = 'Hazard reported ahead';
  static const String speedingAlert = 'You are exceeding the speed limit';
  static const String speedCameraAhead = 'Speed camera ahead';
  
  // Settings
  static const String settings = 'Settings';
  static const String profile = 'Profile';
  static const String voiceNavigation = 'Voice Navigation';
  static const String mapDisplay = 'Map Display';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy';
  static const String about = 'About';
  
  // Errors
  static const String locationPermissionDenied = 'Location permission denied';
  static const String locationServiceDisabled = 'Location service disabled';
  static const String noInternetConnection = 'No internet connection';
  static const String routeNotFound = 'Route not found';
  static const String searchFailed = 'Search failed';
  static const String reportFailed = 'Failed to send report';
}