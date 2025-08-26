class AppConstants {
  // App Information
  static const String appName = 'Crumbl';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Fresh, warm cookies delivered to your door';
  
  // API Configuration
  static const String baseUrl = 'https://api.crumbl.com/v1';
  static const String apiKey = 'your_api_key_here';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_data';
  static const String loyaltyDataKey = 'loyalty_data';
  static const String settingsKey = 'app_settings';
  
  // Cookie Box Sizes
  static const int fourPackSize = 4;
  static const int sixPackSize = 6;
  static const int twelvePackSize = 12;
  
  // Pricing
  static const double taxRate = 0.08; // 8%
  static const double deliveryFeeBase = 3.99;
  static const double freeDeliveryMinimum = 25.00;
  
  // Loyalty Program
  static const int pointsPerDollar = 1;
  static const int pointsForReward = 100;
  static const double rewardValue = 10.00; // $10 Crumbl Cash
  
  // Time Constants
  static const int orderTimeoutMinutes = 30;
  static const int cacheExpirationHours = 24;
  static const int locationUpdateIntervalSeconds = 30;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Network
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxAddressLength = 200;
  static const int maxSpecialInstructionsLength = 500;
  
  // Map Configuration
  static const double defaultZoom = 14.0;
  static const double maxDeliveryRadius = 10.0; // miles
  
  // Cookie Categories
  static const List<String> cookieCategories = [
    'Weekly Specials',
    'Classics',
    'Seasonal',
    'Limited Edition',
  ];
  
  // Fulfillment Methods
  static const List<String> fulfillmentMethods = [
    'Pickup',
    'Curbside',
    'Delivery',
    'Catering',
    'Shipping',
  ];
  
  // Order Status Messages
  static const Map<String, String> orderStatusMessages = {
    'pending': 'Order received and being processed',
    'confirmed': 'Order confirmed and being prepared',
    'preparing': 'Your cookies are being baked fresh',
    'ready': 'Order ready for pickup/delivery',
    'completed': 'Order completed successfully',
    'cancelled': 'Order has been cancelled',
  };
  
  // Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String locationError = 'Unable to get your location.';
  static const String paymentError = 'Payment processing failed.';
  static const String cartEmptyError = 'Your cart is empty.';
  static const String storeClosedError = 'Selected store is currently closed.';
  
  // Success Messages
  static const String orderPlacedSuccess = 'Order placed successfully!';
  static const String profileUpdatedSuccess = 'Profile updated successfully!';
  static const String paymentAddedSuccess = 'Payment method added successfully!';
  static const String addressAddedSuccess = 'Address added successfully!';
  
  // Notification Types
  static const String orderUpdateNotification = 'order_update';
  static const String promotionNotification = 'promotion';
  static const String weeklyMenuNotification = 'weekly_menu';
  static const String loyaltyNotification = 'loyalty';
  
  // Deep Link Routes
  static const String homeRoute = '/home';
  static const String orderRoute = '/order';
  static const String checkoutRoute = '/checkout';
  static const String locationsRoute = '/locations';
  static const String moreRoute = '/more';
  static const String profileRoute = '/profile';
  static const String orderHistoryRoute = '/order-history';
  static const String loyaltyRoute = '/loyalty';
  
  // Image Placeholders
  static const String cookiePlaceholder = 'assets/images/cookie_placeholder.png';
  static const String userPlaceholder = 'assets/images/user_placeholder.png';
  static const String storePlaceholder = 'assets/images/store_placeholder.png';
  
  // Social Media
  static const String instagramUrl = 'https://instagram.com/crumblcookies';
  static const String twitterUrl = 'https://twitter.com/crumblcookies';
  static const String facebookUrl = 'https://facebook.com/crumblcookies';
  static const String tiktokUrl = 'https://tiktok.com/@crumblcookies';
  
  // Support
  static const String supportEmail = 'support@crumbl.com';
  static const String supportPhone = '1-800-CRUMBL';
  static const String privacyPolicyUrl = 'https://crumbl.com/privacy';
  static const String termsOfServiceUrl = 'https://crumbl.com/terms';
  
  // Feature Flags
  static const bool enableLocationServices = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableBetaFeatures = false;
}