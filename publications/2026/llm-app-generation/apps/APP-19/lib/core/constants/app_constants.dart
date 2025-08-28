class AppConstants {
  // App Information
  static const String appName = 'MyChart';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.mychart.com';
  static const String apiVersion = 'v1';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String notificationsEnabledKey = 'notifications_enabled';
  
  // Navigation
  static const String homeRoute = '/home';
  static const String appointmentsRoute = '/appointments';
  static const String messagesRoute = '/messages';
  static const String recordsRoute = '/records';
  static const String billingRoute = '/billing';
  static const String authRoute = '/auth';
  static const String loginRoute = '/login';
  
  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'h:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy h:mm a';
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxMessageLength = 1000;
}