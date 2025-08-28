class AppConstants {
  // App Info
  static const String appName = 'SHEIN';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Comprehensive E-commerce Mobile Application';

  // API Configuration
  static const String baseUrl = 'https://api.shein.com/v1';
  static const String apiKey = 'your_api_key_here';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_data';
  static const String wishlistDataKey = 'wishlist_data';
  static const String recentSearchesKey = 'recent_searches';
  static const String onboardingCompletedKey = 'onboarding_completed';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 20.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Product Categories
  static const List<String> mainCategories = [
    'Women',
    'Men',
    'Kids',
    'Home & Living',
    'Beauty',
    'Accessories',
    'Shoes',
    'Sports',
  ];

  static const Map<String, List<String>> subCategories = {
    'Women': [
      'Dresses',
      'Tops',
      'Bottoms',
      'Outerwear',
      'Lingerie',
      'Swimwear',
      'Activewear',
    ],
    'Men': [
      'T-Shirts',
      'Shirts',
      'Pants',
      'Shorts',
      'Outerwear',
      'Underwear',
      'Activewear',
    ],
    'Kids': [
      'Girls',
      'Boys',
      'Baby',
      'Shoes',
      'Accessories',
    ],
    'Home & Living': [
      'Bedding',
      'Bath',
      'Kitchen',
      'Decor',
      'Storage',
      'Lighting',
    ],
    'Beauty': [
      'Makeup',
      'Skincare',
      'Hair Care',
      'Fragrance',
      'Tools',
    ],
    'Accessories': [
      'Bags',
      'Jewelry',
      'Watches',
      'Sunglasses',
      'Hats',
      'Belts',
    ],
    'Shoes': [
      'Sneakers',
      'Heels',
      'Flats',
      'Boots',
      'Sandals',
      'Athletic',
    ],
    'Sports': [
      'Activewear',
      'Equipment',
      'Outdoor',
      'Fitness',
    ],
  };

  // Size Options
  static const List<String> clothingSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'XXXL',
  ];

  static const List<String> shoeSizes = [
    '5',
    '5.5',
    '6',
    '6.5',
    '7',
    '7.5',
    '8',
    '8.5',
    '9',
    '9.5',
    '10',
    '10.5',
    '11',
    '11.5',
    '12',
  ];

  // Colors
  static const List<String> availableColors = [
    'Black',
    'White',
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Pink',
    'Purple',
    'Orange',
    'Brown',
    'Gray',
    'Navy',
    'Beige',
    'Khaki',
  ];

  // Price Ranges for Filtering
  static const List<Map<String, dynamic>> priceRanges = [
    {'label': 'Under \$10', 'min': 0, 'max': 10},
    {'label': '\$10 - \$25', 'min': 10, 'max': 25},
    {'label': '\$25 - \$50', 'min': 25, 'max': 50},
    {'label': '\$50 - \$100', 'min': 50, 'max': 100},
    {'label': 'Over \$100', 'min': 100, 'max': 999999},
  ];

  // Sort Options
  static const List<String> sortOptions = [
    'Recommended',
    'Price: Low to High',
    'Price: High to Low',
    'Newest',
    'Best Selling',
    'Customer Rating',
  ];

  // Payment Methods
  static const List<String> paymentMethods = [
    'Credit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
    'Afterpay',
    'Klarna',
  ];

  // Shipping Options
  static const List<Map<String, dynamic>> shippingOptions = [
    {
      'name': 'Standard Shipping',
      'price': 0.0,
      'duration': '7-10 business days',
      'description': 'Free standard shipping on orders over \$35'
    },
    {
      'name': 'Express Shipping',
      'price': 9.99,
      'duration': '3-5 business days',
      'description': 'Faster delivery for urgent orders'
    },
    {
      'name': 'Next Day Delivery',
      'price': 19.99,
      'duration': '1 business day',
      'description': 'Get your order tomorrow'
    },
  ];

  // Order Status
  static const List<String> orderStatuses = [
    'Processing',
    'Confirmed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
    'Returned',
  ];

  // Flash Sale Configuration
  static const Duration flashSaleDuration = Duration(hours: 3);
  static const int maxFlashSaleDiscount = 90;
  static const int minFlashSaleDiscount = 30;

  // Pagination
  static const int productsPerPage = 20;
  static const int reviewsPerPage = 10;
  static const int ordersPerPage = 15;

  // Image Configuration
  static const int maxImageQuality = 85;
  static const double maxImageWidth = 1200;
  static const double maxImageHeight = 1200;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxReviewLength = 500;
  static const int maxAddressLength = 200;

  // Social Media Links
  static const String facebookUrl = 'https://facebook.com/shein';
  static const String instagramUrl = 'https://instagram.com/shein';
  static const String twitterUrl = 'https://twitter.com/shein';
  static const String youtubeUrl = 'https://youtube.com/shein';

  // Customer Service
  static const String supportEmail = 'support@shein.com';
  static const String supportPhone = '+1-800-SHEIN-01';
  static const String liveChatUrl = 'https://shein.com/chat';

  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String authErrorMessage = 'Authentication failed. Please login again.';
  static const String validationErrorMessage = 'Please check your input and try again.';
}