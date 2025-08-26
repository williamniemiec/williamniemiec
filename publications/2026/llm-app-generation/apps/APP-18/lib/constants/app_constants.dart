class AppConstants {
  // App Information
  static const String appName = 'Pinterest';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Visual discovery engine for finding and organizing inspiration';

  // API Configuration
  static const String baseApiUrl = 'https://api.pinterest.com/v1';
  static const String imageUploadUrl = '$baseApiUrl/upload/image';
  static const String visualSearchUrl = '$baseApiUrl/search/visual';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  static const int homeFeedPageSize = 25;
  static const int searchResultsPageSize = 30;

  // Image Configuration
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1920;
  static const int imageQuality = 85;
  static const int thumbnailSize = 200;
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];

  // Grid Configuration
  static const int gridColumns = 2;
  static const double gridSpacing = 8.0;
  static const double pinBorderRadius = 16.0;
  static const double cardElevation = 2.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration splashScreenDuration = Duration(seconds: 2);

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration imageLoadTimeout = Duration(seconds: 15);
  static const Duration cacheTimeout = Duration(hours: 24);

  // Cache Configuration
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const int maxCachedImages = 500;
  static const Duration cacheExpiration = Duration(days: 7);

  // Search Configuration
  static const int maxSearchHistoryItems = 20;
  static const int minSearchQueryLength = 2;
  static const int maxSearchQueryLength = 100;
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  // User Limits
  static const int maxBoardsPerUser = 500;
  static const int maxPinsPerBoard = 10000;
  static const int maxFollowingCount = 50000;
  static const int maxBoardNameLength = 50;
  static const int maxBoardDescriptionLength = 500;
  static const int maxPinTitleLength = 100;
  static const int maxPinDescriptionLength = 500;
  static const int maxCommentLength = 500;

  // Social Features
  static const int maxRecentSearches = 10;
  static const int maxSuggestedUsers = 20;
  static const int maxTrendingTopics = 15;

  // Notification Types
  static const String notificationTypeLike = 'like';
  static const String notificationTypeComment = 'comment';
  static const String notificationTypeFollow = 'follow';
  static const String notificationTypeSave = 'save';
  static const String notificationTypeMessage = 'message';

  // Deep Link Schemes
  static const String deepLinkScheme = 'pinterest';
  static const String webLinkDomain = 'pinterest.com';

  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String authErrorMessage = 'Please log in to continue.';
  static const String permissionErrorMessage = 'Permission required to access this feature.';
  static const String imageUploadErrorMessage = 'Failed to upload image. Please try again.';
  static const String searchErrorMessage = 'Search failed. Please try again.';

  // Success Messages
  static const String pinSavedMessage = 'Pin saved to board';
  static const String pinCreatedMessage = 'Pin created successfully';
  static const String boardCreatedMessage = 'Board created successfully';
  static const String profileUpdatedMessage = 'Profile updated successfully';

  // Validation Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String usernamePattern = r'^[a-zA-Z0-9_]{3,30}$';
  static const String urlPattern = r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

  // File Paths
  static const String imagesPath = 'assets/images/';
  static const String iconsPath = 'assets/icons/';
  static const String animationsPath = 'assets/animations/';
  static const String fontsPath = 'assets/fonts/';

  // Asset Names
  static const String logoImage = '${imagesPath}logo.png';
  static const String placeholderImage = '${imagesPath}placeholder.png';
  static const String emptyStateImage = '${imagesPath}empty_state.png';
  static const String errorImage = '${imagesPath}error.png';

  // Icon Names
  static const String homeIcon = '${iconsPath}home.svg';
  static const String searchIcon = '${iconsPath}search.svg';
  static const String createIcon = '${iconsPath}create.svg';
  static const String messagesIcon = '${iconsPath}messages.svg';
  static const String profileIcon = '${iconsPath}profile.svg';
  static const String cameraIcon = '${iconsPath}camera.svg';
  static const String heartIcon = '${iconsPath}heart.svg';
  static const String shareIcon = '${iconsPath}share.svg';

  // Animation Names
  static const String loadingAnimation = '${animationsPath}loading.json';
  static const String successAnimation = '${animationsPath}success.json';
  static const String errorAnimation = '${animationsPath}error.json';

  // SharedPreferences Keys
  static const String keyCurrentUser = 'current_user';
  static const String keyAccessToken = 'access_token';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keySearchHistory = 'search_history';
  static const String keyAppSettings = 'app_settings';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Database Tables
  static const String usersTable = 'users';
  static const String pinsTable = 'pins';
  static const String boardsTable = 'boards';
  static const String commentsTable = 'comments';
  static const String messagesTable = 'messages';
  static const String conversationsTable = 'conversations';
  static const String searchHistoryTable = 'search_history';
  static const String cachedPinsTable = 'cached_pins';

  // HTTP Status Codes
  static const int httpOk = 200;
  static const int httpCreated = 201;
  static const int httpBadRequest = 400;
  static const int httpUnauthorized = 401;
  static const int httpForbidden = 403;
  static const int httpNotFound = 404;
  static const int httpInternalServerError = 500;

  // Feature Flags
  static const bool enableVisualSearch = true;
  static const bool enableShopping = true;
  static const bool enableMessaging = true;
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Social Media Links
  static const String twitterUrl = 'https://twitter.com/pinterest';
  static const String facebookUrl = 'https://facebook.com/pinterest';
  static const String instagramUrl = 'https://instagram.com/pinterest';
  static const String youtubeUrl = 'https://youtube.com/pinterest';

  // Legal Links
  static const String privacyPolicyUrl = 'https://policy.pinterest.com/privacy-policy';
  static const String termsOfServiceUrl = 'https://policy.pinterest.com/terms-of-service';
  static const String communityGuidelinesUrl = 'https://policy.pinterest.com/community-guidelines';

  // Support
  static const String supportEmail = 'support@pinterest.com';
  static const String helpCenterUrl = 'https://help.pinterest.com';
  static const String feedbackUrl = 'https://help.pinterest.com/contact';

  // Regional Settings
  static const List<String> supportedLanguages = ['en', 'es', 'fr', 'de', 'it', 'pt', 'ja', 'ko'];
  static const String defaultLanguage = 'en';
  static const List<String> supportedCountries = ['US', 'CA', 'GB', 'AU', 'DE', 'FR', 'IT', 'ES', 'BR', 'MX', 'JP', 'KR'];
  static const String defaultCountry = 'US';

  // Monetization
  static const List<String> supportedCurrencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY', 'KRW', 'BRL', 'MXN'];
  static const String defaultCurrency = 'USD';

  // Content Guidelines
  static const List<String> prohibitedContent = [
    'spam',
    'hate_speech',
    'violence',
    'adult_content',
    'copyright_infringement',
    'misinformation',
  ];

  // Rate Limiting
  static const int maxApiRequestsPerMinute = 100;
  static const int maxImageUploadsPerHour = 50;
  static const int maxPinsCreatedPerDay = 100;
  static const int maxBoardsCreatedPerDay = 10;

  // Performance Metrics
  static const Duration maxAppStartupTime = Duration(seconds: 3);
  static const Duration maxImageLoadTime = Duration(seconds: 5);
  static const Duration maxSearchResponseTime = Duration(seconds: 2);

  // Accessibility
  static const double minTouchTargetSize = 44.0;
  static const double maxFontScale = 2.0;
  static const double minFontScale = 0.8;

  // Security
  static const Duration tokenExpirationTime = Duration(hours: 24);
  static const Duration refreshTokenExpirationTime = Duration(days: 30);
  static const int maxLoginAttempts = 5;
  static const Duration loginCooldownPeriod = Duration(minutes: 15);
}