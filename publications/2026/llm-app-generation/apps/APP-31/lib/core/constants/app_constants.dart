class AppConstants {
  // App Info
  static const String appName = 'Temu';
  static const String appSlogan = 'Shop like a Billionaire';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.temu.com';
  static const String apiVersion = 'v1';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartKey = 'cart_items';
  static const String wishlistKey = 'wishlist_items';
  static const String recentSearchesKey = 'recent_searches';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Image Placeholders
  static const String productPlaceholder = 'assets/images/product_placeholder.png';
  static const String userPlaceholder = 'assets/images/user_placeholder.png';
  static const String categoryPlaceholder = 'assets/images/category_placeholder.png';

  // Game Constants
  static const int dailyCheckInReward = 10;
  static const int referralReward = 50;
  static const int gameCompletionReward = 25;

  // Shipping
  static const double freeShippingThreshold = 0.0;
  static const int standardShippingDays = 7;
  static const int expressShippingDays = 3;

  // Categories
  static const List<String> mainCategories = [
    'Women\'s Clothing',
    'Men\'s Clothing',
    'Home & Kitchen',
    'Health & Beauty',
    'Electronics',
    'Sports & Outdoors',
    'Toys & Games',
    'Automotive',
    'Books & Media',
    'Jewelry & Accessories',
  ];

  // Flash Sale Duration
  static const int flashSaleDurationHours = 24;
  static const int lightningDealDurationMinutes = 60;

  // Review Constants
  static const int maxReviewLength = 500;
  static const int maxReviewImages = 5;

  // Search
  static const int maxRecentSearches = 10;
  static const int searchSuggestionLimit = 8;
}