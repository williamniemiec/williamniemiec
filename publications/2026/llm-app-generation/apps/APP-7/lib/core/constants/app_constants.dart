class AppConstants {
  // App Information
  static const String appName = 'ParentSquare';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'A unified communication platform connecting schools, districts, teachers, and parents.';
  
  // API Configuration
  static const String baseUrl = 'https://api.parentsquare.com/v1';
  static const String websocketUrl = 'wss://ws.parentsquare.com';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 10);
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String notificationSettingsKey = 'notification_settings';
  static const String languageKey = 'selected_language';
  static const String themeKey = 'selected_theme';
  static const String onboardingCompletedKey = 'onboarding_completed';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedVideoTypes = ['mp4', 'mov', 'avi'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'txt'];
  
  // Message Limits
  static const int maxMessageLength = 2000;
  static const int maxAttachmentsPerMessage = 5;
  
  // Post Limits
  static const int maxPostLength = 5000;
  static const int maxAttachmentsPerPost = 10;
  
  // Notification Types
  static const String notificationTypeAnnouncement = 'announcement';
  static const String notificationTypeMessage = 'message';
  static const String notificationTypeEvent = 'event';
  static const String notificationTypeAttendance = 'attendance';
  static const String notificationTypeForm = 'form';
  static const String notificationTypePayment = 'payment';
  
  // Deep Link Schemes
  static const String deepLinkScheme = 'parentsquare';
  static const String deepLinkHost = 'app';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Refresh Intervals
  static const Duration feedRefreshInterval = Duration(minutes: 5);
  static const Duration messageRefreshInterval = Duration(seconds: 30);
  static const Duration eventRefreshInterval = Duration(minutes: 15);
  
  // Cache Durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String unauthorizedErrorMessage = 'Please log in to continue.';
  static const String forbiddenErrorMessage = 'You don\'t have permission to perform this action.';
  static const String notFoundErrorMessage = 'The requested resource was not found.';
  
  // Success Messages
  static const String messageSentSuccess = 'Message sent successfully';
  static const String postCreatedSuccess = 'Post created successfully';
  static const String eventCreatedSuccess = 'Event created successfully';
  static const String rsvpUpdatedSuccess = 'RSVP updated successfully';
  static const String settingsUpdatedSuccess = 'Settings updated successfully';
  
  // Validation Messages
  static const String requiredFieldError = 'This field is required';
  static const String invalidEmailError = 'Please enter a valid email address';
  static const String invalidPhoneError = 'Please enter a valid phone number';
  static const String passwordTooShortError = 'Password must be at least 8 characters';
  static const String passwordMismatchError = 'Passwords do not match';
  
  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'h:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy h:mm a';
  static const String shortDateFormat = 'MM/dd/yyyy';
  static const String isoDateFormat = 'yyyy-MM-ddTHH:mm:ss.SSSZ';
  
  // Supported Languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'zh': '中文',
    'ja': '日本語',
    'ko': '한국어',
    'ar': 'العربية',
  };
  
  // Default Values
  static const String defaultLanguage = 'en';
  static const String defaultCountryCode = 'US';
  static const String defaultTimeZone = 'America/New_York';
  
  // Feature Flags
  static const bool enablePushNotifications = true;
  static const bool enableVideoMessages = true;
  static const bool enableVoiceMessages = true;
  static const bool enableFileSharing = true;
  static const bool enableTranslation = true;
  static const bool enableDarkMode = true;
  
  // Social Features
  static const int maxAppreciationsToShow = 5;
  static const int maxCommentsToShow = 3;
  
  // Search
  static const int minSearchLength = 2;
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);
  
  // Biometric Authentication
  static const String biometricReason = 'Please authenticate to access ParentSquare';
  
  // App Store URLs
  static const String appStoreUrl = 'https://apps.apple.com/app/parentsquare';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.parentsquare.app';
  
  // Support
  static const String supportEmail = 'support@parentsquare.com';
  static const String supportPhone = '+1-800-PARENT';
  static const String privacyPolicyUrl = 'https://parentsquare.com/privacy';
  static const String termsOfServiceUrl = 'https://parentsquare.com/terms';
  static const String helpCenterUrl = 'https://help.parentsquare.com';
}

class AppRoutes {
  // Authentication
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  
  // Onboarding
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  
  // Main Navigation
  static const String home = '/';
  static const String messages = '/messages';
  static const String events = '/events';
  static const String explore = '/explore';
  static const String more = '/more';
  
  // Detailed Views
  static const String postDetail = '/post/:id';
  static const String messageDetail = '/message/:id';
  static const String eventDetail = '/event/:id';
  static const String userProfile = '/profile/:id';
  
  // Forms and Actions
  static const String createPost = '/create-post';
  static const String createEvent = '/create-event';
  static const String signUp = '/signup/:id';
  static const String form = '/form/:id';
  static const String poll = '/poll/:id';
  
  // Settings
  static const String settings = '/settings';
  static const String notificationSettings = '/settings/notifications';
  static const String languageSettings = '/settings/language';
  static const String privacySettings = '/settings/privacy';
  static const String accountSettings = '/settings/account';
  
  // Help and Support
  static const String help = '/help';
  static const String support = '/support';
  static const String feedback = '/feedback';
  static const String about = '/about';
}

class AppAssets {
  // Images
  static const String logo = 'assets/images/logo.png';
  static const String logoWhite = 'assets/images/logo_white.png';
  static const String onboardingImage1 = 'assets/images/onboarding_1.png';
  static const String onboardingImage2 = 'assets/images/onboarding_2.png';
  static const String onboardingImage3 = 'assets/images/onboarding_3.png';
  static const String emptyState = 'assets/images/empty_state.png';
  static const String errorState = 'assets/images/error_state.png';
  
  // Icons
  static const String homeIcon = 'assets/icons/home.svg';
  static const String messagesIcon = 'assets/icons/messages.svg';
  static const String eventsIcon = 'assets/icons/events.svg';
  static const String exploreIcon = 'assets/icons/explore.svg';
  static const String moreIcon = 'assets/icons/more.svg';
  static const String notificationIcon = 'assets/icons/notification.svg';
  static const String appreciationIcon = 'assets/icons/appreciation.svg';
  
  // Fonts
  static const String primaryFont = 'Roboto';
}