class AppConstants {
  // App Info
  static const String appName = 'Threads';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.threads.net';
  static const String instagramApiUrl = 'https://graph.instagram.com';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';
  
  // Pagination
  static const int postsPerPage = 20;
  static const int usersPerPage = 15;
  
  // Media
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxVideoSize = 50 * 1024 * 1024; // 50MB
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> supportedVideoFormats = ['mp4', 'mov', 'avi'];
  
  // Text Limits
  static const int maxThreadLength = 500;
  static const int maxBioLength = 150;
  static const int maxUsernameLength = 30;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double avatarSize = 40.0;
  static const double largeAvatarSize = 80.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkError = 'Network connection failed. Please try again.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String unknownError = 'An unknown error occurred.';
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String search = '/search';
  static const String compose = '/compose';
  static const String activity = '/activity';
  static const String profile = '/profile';
  static const String userProfile = '/user-profile';
  static const String threadDetail = '/thread-detail';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
}