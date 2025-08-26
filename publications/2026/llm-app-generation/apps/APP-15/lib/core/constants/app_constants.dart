class AppConstants {
  // App Information
  static const String appName = 'Blink Fitness';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your digital gym companion';
  
  // API Configuration
  static const String baseUrl = 'https://api.blinkfitness.com';
  static const String apiVersion = 'v1';
  static const String apiTimeout = '30'; // seconds
  
  // Storage Keys
  static const String userKey = 'user_data';
  static const String membershipKey = 'membership_data';
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String darkModeKey = 'dark_mode';
  static const String lastSyncKey = 'last_sync';
  static const String contentCacheKey = 'content_cache';
  static const String fitnessGoalsKey = 'fitness_goals';
  
  // Hive Box Names
  static const String userBox = 'users';
  static const String contentBox = 'content';
  static const String membershipBox = 'memberships';
  static const String guestBox = 'guests';
  static const String settingsBox = 'settings';
  
  // Navigation Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String contentRoute = '/content';
  static const String accountRoute = '/account';
  static const String profileRoute = '/profile';
  static const String membershipRoute = '/membership';
  static const String billingRoute = '/billing';
  static const String guestRoute = '/guest';
  static const String settingsRoute = '/settings';
  static const String contentDetailRoute = '/content-detail';
  static const String videoPlayerRoute = '/video-player';
  static const String barcodeRoute = '/barcode';
  
  // Content Partners
  static const List<String> contentPartners = [
    'Aaptiv',
    'Daily Burn',
    'Sworkit',
    'Nike Training Club',
    'Peloton Digital',
    'Headspace',
    'Calm',
  ];
  
  // Fitness Goals
  static const List<String> fitnessGoals = [
    'Lose Weight',
    'Build Muscle',
    'Improve Cardio',
    'Increase Flexibility',
    'Reduce Stress',
    'Better Sleep',
    'General Fitness',
    'Athletic Performance',
    'Rehabilitation',
    'Maintain Health',
  ];
  
  // Content Categories
  static const List<String> contentCategories = [
    'Cardio',
    'Strength',
    'Yoga',
    'Meditation',
    'Nutrition',
    'Wellness',
    'HIIT',
    'Stretching',
  ];
  
  // Difficulty Levels
  static const List<String> difficultyLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
  ];
  
  // Membership Plans
  static const Map<String, double> membershipPrices = {
    'basic': 15.00,
    'premium': 25.00,
    'vip': 35.00,
  };
  
  // Guest Pass Limits
  static const Map<String, int> guestPassLimits = {
    'basic': 0,
    'premium': 2,
    'vip': 5,
  };
  
  // Barcode Configuration
  static const String barcodePrefix = 'BLINK';
  static const int barcodeLength = 12;
  static const Duration barcodeRefreshInterval = Duration(minutes: 5);
  
  // Content Configuration
  static const int contentPageSize = 20;
  static const Duration contentCacheExpiry = Duration(hours: 24);
  static const int maxRecentContent = 10;
  static const int maxFavoriteContent = 50;
  
  // Video Player Configuration
  static const Duration videoSeekInterval = Duration(seconds: 10);
  static const double videoPlaybackSpeed = 1.0;
  static const List<double> videoPlaybackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  
  // Health Integration
  static const List<String> healthDataTypes = [
    'steps',
    'distance',
    'calories',
    'heart_rate',
    'workout_time',
    'active_energy',
  ];
  
  // Notification Types
  static const String workoutReminderNotification = 'workout_reminder';
  static const String membershipExpiryNotification = 'membership_expiry';
  static const String newContentNotification = 'new_content';
  static const String guestApprovalNotification = 'guest_approval';
  static const String paymentDueNotification = 'payment_due';
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please log in again.';
  static const String membershipExpiredMessage = 'Your membership has expired. Please renew to continue.';
  static const String guestLimitReachedMessage = 'You have reached your guest pass limit for this month.';
  static const String invalidBarcodeMessage = 'Invalid barcode. Please try again.';
  static const String videoLoadErrorMessage = 'Unable to load video. Please check your connection.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registrationSuccessMessage = 'Account created successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';
  static const String paymentSuccessMessage = 'Payment processed successfully!';
  static const String guestInviteSuccessMessage = 'Guest invitation sent successfully!';
  static const String checkInSuccessMessage = 'Check-in successful! Enjoy your workout!';
  
  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]{10,}$';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  
  // Image Sizes
  static const double profileImageSize = 80.0;
  static const double thumbnailImageSize = 120.0;
  static const double contentImageHeight = 200.0;
  static const double barcodeSize = 250.0;
  
  // Timeouts and Intervals
  static const Duration splashScreenDuration = Duration(seconds: 3);
  static const Duration debounceDelay = Duration(milliseconds: 500);
  static const Duration refreshInterval = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 24);
  
  // Limits
  static const int maxSearchHistory = 10;
  static const int maxNotifications = 50;
  static const int maxTransactionHistory = 100;
  static const double maxFileSize = 10 * 1024 * 1024; // 10MB
  
  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableHealthKitIntegration = true;
  static const bool enablePushNotifications = true;
  static const bool enableVideoDownload = false;
  static const bool enableSocialSharing = true;
  static const bool enableAnalytics = true;
  
  // Development Configuration
  static const bool isDebugMode = true;
  static const bool enableLogging = true;
  static const bool enableCrashReporting = true;
  static const String logLevel = 'DEBUG';
}

class AppStrings {
  // General
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String skip = 'Skip';
  static const String getStarted = 'Get Started';
  static const String continueText = 'Continue';
  static const String back = 'Back';
  static const String close = 'Close';
  static const String ok = 'OK';
  static const String yes = 'Yes';
  static const String no = 'No';
  
  // Authentication
  static const String login = 'Log In';
  static const String logout = 'Log Out';
  static const String register = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String phoneNumber = 'Phone Number';
  
  // Navigation
  static const String home = 'Home';
  static const String content = 'Content';
  static const String workouts = 'Workouts';
  static const String account = 'Account';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  
  // Home Screen
  static const String welcomeBack = 'Welcome back';
  static const String checkInToGym = 'Check in to gym';
  static const String todaysWorkout = "Today's Workout";
  static const String featuredContent = 'Featured Content';
  static const String recentActivity = 'Recent Activity';
  static const String quickActions = 'Quick Actions';
  
  // Content
  static const String allContent = 'All Content';
  static const String videos = 'Videos';
  static const String audio = 'Audio';
  static const String articles = 'Articles';
  static const String recipes = 'Recipes';
  static const String searchContent = 'Search content...';
  static const String filterBy = 'Filter by';
  static const String sortBy = 'Sort by';
  static const String duration = 'Duration';
  static const String difficulty = 'Difficulty';
  static const String category = 'Category';
  static const String partner = 'Partner';
  
  // Account
  static const String membership = 'Membership';
  static const String billing = 'Billing';
  static const String guestPasses = 'Guest Passes';
  static const String transactionHistory = 'Transaction History';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy';
  static const String support = 'Support';
  static const String about = 'About';
  
  // Membership
  static const String membershipStatus = 'Membership Status';
  static const String memberSince = 'Member Since';
  static const String nextBilling = 'Next Billing';
  static const String monthlyFee = 'Monthly Fee';
  static const String freezeMembership = 'Freeze Membership';
  static const String cancelMembership = 'Cancel Membership';
  static const String upgradeMembership = 'Upgrade Membership';
  
  // Guest Passes
  static const String inviteGuest = 'Invite Guest';
  static const String guestName = 'Guest Name';
  static const String visitDate = 'Visit Date';
  static const String guestEmail = 'Guest Email';
  static const String sendInvitation = 'Send Invitation';
  static const String guestPassesRemaining = 'Guest Passes Remaining';
  
  // Error States
  static const String noInternetConnection = 'No internet connection';
  static const String somethingWentWrong = 'Something went wrong';
  static const String noContentFound = 'No content found';
  static const String noResultsFound = 'No results found';
  static const String tryAgainLater = 'Please try again later';
  
  // Empty States
  static const String noFavorites = 'No favorites yet';
  static const String noRecentContent = 'No recent content';
  static const String noNotifications = 'No notifications';
  static const String noTransactions = 'No transactions';
  static const String noGuests = 'No guest passes';
}