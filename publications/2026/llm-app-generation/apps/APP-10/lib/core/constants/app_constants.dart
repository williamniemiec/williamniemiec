class AppConstants {
  // App Information
  static const String appName = 'DramaBox';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Stream short-form dramatic content';
  
  // API Configuration
  static const String baseUrl = 'https://api.dramabox.com';
  static const String apiVersion = 'v1';
  static const String apiKey = 'your_api_key_here';
  
  // Storage Keys
  static const String userBoxKey = 'user_box';
  static const String dramaBoxKey = 'drama_box';
  static const String episodeBoxKey = 'episode_box';
  static const String subscriptionBoxKey = 'subscription_box';
  static const String settingsBoxKey = 'settings_box';
  
  // Shared Preferences Keys
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String currentUserIdKey = 'current_user_id';
  static const String themePreferenceKey = 'theme_preference';
  static const String languagePreferenceKey = 'language_preference';
  static const String autoPlayKey = 'auto_play_enabled';
  static const String notificationsKey = 'notifications_enabled';
  static const String videoQualityKey = 'video_quality_preference';
  
  // Monetization
  static const int dailyCheckInReward = 5; // coins
  static const int adWatchReward = 3; // coins
  static const int maxAdWatchesPerDay = 10;
  static const int maxFreeEpisodesPerDrama = 3;
  
  // Coin Packages
  static const Map<String, Map<String, dynamic>> coinPackages = {
    'small': {
      'coins': 100,
      'price': 1.99,
      'currency': 'USD',
      'bonus': 0,
    },
    'medium': {
      'coins': 500,
      'price': 7.99,
      'currency': 'USD',
      'bonus': 50,
    },
    'large': {
      'coins': 1000,
      'price': 14.99,
      'currency': 'USD',
      'bonus': 150,
    },
    'mega': {
      'coins': 2500,
      'price': 29.99,
      'currency': 'USD',
      'bonus': 500,
    },
  };
  
  // Subscription Plans
  static const Map<String, Map<String, dynamic>> subscriptionPlans = {
    'weekly': {
      'name': 'Weekly Premium',
      'price': 4.99,
      'currency': 'USD',
      'duration': 7,
      'features': [
        'Unlimited access to all content',
        'Ad-free viewing',
        'HD quality streaming',
        'Early access to new episodes',
      ],
    },
    'monthly': {
      'name': 'Monthly Premium',
      'price': 14.99,
      'currency': 'USD',
      'duration': 30,
      'features': [
        'Unlimited access to all content',
        'Ad-free viewing',
        'HD quality streaming',
        'Early access to new episodes',
        'Offline downloads',
      ],
    },
    'yearly': {
      'name': 'Yearly Premium',
      'price': 149.99,
      'currency': 'USD',
      'duration': 365,
      'features': [
        'Unlimited access to all content',
        'Ad-free viewing',
        'HD quality streaming',
        'Early access to new episodes',
        'Offline downloads',
        '50% savings compared to monthly',
      ],
    },
  };
  
  // Video Quality Settings
  static const Map<String, Map<String, dynamic>> videoQualities = {
    'auto': {
      'name': 'Auto',
      'description': 'Adjusts based on connection',
      'bitrate': 0,
    },
    'low': {
      'name': 'Low (360p)',
      'description': 'Data saver mode',
      'bitrate': 500000,
    },
    'medium': {
      'name': 'Medium (480p)',
      'description': 'Standard quality',
      'bitrate': 1000000,
    },
    'high': {
      'name': 'High (720p)',
      'description': 'HD quality',
      'bitrate': 2500000,
    },
    'ultra': {
      'name': 'Ultra (1080p)',
      'description': 'Full HD quality',
      'bitrate': 5000000,
    },
  };
  
  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ru': 'Русский',
    'ja': '日本語',
    'ko': '한국어',
    'zh': '中文',
    'ar': 'العربية',
    'hi': 'हिन्दी',
  };
  
  // Drama Genres
  static const List<String> dramaGenres = [
    'Romance',
    'Thriller',
    'Fantasy',
    'Comedy',
    'Suspense',
    'Drama',
    'Action',
    'Mystery',
    'Horror',
    'Sci-Fi',
    'Historical',
    'Crime',
    'Adventure',
    'Family',
    'Musical',
  ];
  
  // Content Rating
  static const Map<String, String> contentRatings = {
    'G': 'General Audiences',
    'PG': 'Parental Guidance',
    'PG-13': 'Parents Strongly Cautioned',
    'R': 'Restricted',
    'NC-17': 'Adults Only',
  };
  
  // Episode Duration Limits (in seconds)
  static const int minEpisodeDuration = 30; // 30 seconds
  static const int maxEpisodeDuration = 300; // 5 minutes
  static const int averageEpisodeDuration = 120; // 2 minutes
  
  // UI Constants
  static const double cardAspectRatio = 16 / 9;
  static const double posterAspectRatio = 2 / 3;
  static const int maxRecentSearches = 10;
  static const int maxRecommendations = 20;
  static const int itemsPerPage = 20;
  
  // Animation Durations (in milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
  
  // Network Configuration
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int maxRetries = 3;
  
  // Cache Configuration
  static const int maxCacheSize = 100 * 1024 * 1024; // 100 MB
  static const int cacheValidityDuration = 24 * 60 * 60 * 1000; // 24 hours
  
  // Ad Configuration
  static const String adMobAppId = 'ca-app-pub-3940256099942544~3347511713'; // Test ID
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String interstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String rewardedAdUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID
  
  // Social Media Links
  static const Map<String, String> socialMediaLinks = {
    'facebook': 'https://facebook.com/dramabox',
    'twitter': 'https://twitter.com/dramabox',
    'instagram': 'https://instagram.com/dramabox',
    'youtube': 'https://youtube.com/dramabox',
    'tiktok': 'https://tiktok.com/@dramabox',
  };
  
  // Support Information
  static const String supportEmail = 'support@dramabox.com';
  static const String privacyPolicyUrl = 'https://dramabox.com/privacy';
  static const String termsOfServiceUrl = 'https://dramabox.com/terms';
  static const String faqUrl = 'https://dramabox.com/faq';
  
  // Feature Flags
  static const bool enableOfflineDownloads = true;
  static const bool enableSocialSharing = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableBetaFeatures = false;
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Server error occurred. Please try again later.';
  static const String unknownErrorMessage = 'An unexpected error occurred. Please try again.';
  static const String noContentMessage = 'No content available at the moment.';
  static const String subscriptionRequiredMessage = 'Premium subscription required to access this content.';
  static const String insufficientCoinsMessage = 'Insufficient coins. Please purchase more coins to continue.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String subscriptionSuccessMessage = 'Subscription activated successfully!';
  static const String coinPurchaseSuccessMessage = 'Coins added to your account!';
  static const String episodeUnlockedMessage = 'Episode unlocked successfully!';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  // Default Values
  static const String defaultLanguage = 'en';
  static const String defaultVideoQuality = 'auto';
  static const bool defaultAutoPlay = true;
  static const bool defaultNotifications = true;
  static const String defaultTheme = 'dark';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Rating System
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  static const double defaultRating = 0.0;
}