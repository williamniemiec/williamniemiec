class AppConstants {
  // App Info
  static const String appName = 'X';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.x.com/v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Character Limits
  static const int maxPostLength = 280;
  static const int maxPostLengthPremium = 25000;
  static const int maxBioLength = 160;
  static const int maxUsernameLength = 15;
  static const int maxDisplayNameLength = 50;
  
  // Media Limits
  static const int maxImagesPerPost = 4;
  static const int maxVideoSizeMB = 512;
  static const int maxImageSizeMB = 5;
  
  // Pagination
  static const int postsPerPage = 20;
  static const int usersPerPage = 20;
  static const int messagesPerPage = 50;
  
  // Cache Keys
  static const String userCacheKey = 'user_cache';
  static const String postsCacheKey = 'posts_cache';
  static const String settingsCacheKey = 'settings_cache';
  
  // Routes
  static const String homeRoute = '/';
  static const String exploreRoute = '/explore';
  static const String communitiesRoute = '/communities';
  static const String notificationsRoute = '/notifications';
  static const String messagesRoute = '/messages';
  static const String profileRoute = '/profile';
  static const String composeRoute = '/compose';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String spacesRoute = '/spaces';
  static const String settingsRoute = '/settings';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double avatarRadius = 20.0;
  static const double largeAvatarRadius = 40.0;
  
  // Post Types
  static const String textPost = 'text';
  static const String imagePost = 'image';
  static const String videoPost = 'video';
  static const String pollPost = 'poll';
  static const String repost = 'repost';
  static const String quote = 'quote';
  
  // Notification Types
  static const String likeNotification = 'like';
  static const String repostNotification = 'repost';
  static const String replyNotification = 'reply';
  static const String followNotification = 'follow';
  static const String mentionNotification = 'mention';
  
  // Premium Features
  static const List<String> premiumFeatures = [
    'Edit posts',
    'Longer posts',
    'Higher quality videos',
    'Reduced ads',
    'Blue checkmark',
    'Priority support',
  ];
  
  // Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String validationError = 'Please check your input and try again.';
  
  // Success Messages
  static const String postCreated = 'Post created successfully!';
  static const String postDeleted = 'Post deleted successfully!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String followSuccess = 'User followed successfully!';
  static const String unfollowSuccess = 'User unfollowed successfully!';
}