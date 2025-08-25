class AppConstants {
  // App Information
  static const String appName = 'Canva Mobile';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional design made simple';

  // API Configuration
  static const String baseUrl = 'https://api.canva.com/v1';
  static const String apiKey = 'your_api_key_here';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Design Canvas
  static const double defaultCanvasWidth = 1080.0;
  static const double defaultCanvasHeight = 1920.0;
  static const double minZoom = 0.1;
  static const double maxZoom = 5.0;
  static const double defaultZoom = 1.0;

  // Template Categories
  static const List<String> templateCategories = [
    'Social Media',
    'Presentations',
    'Documents',
    'Marketing',
    'Personal',
    'Business',
    'Education',
    'Events',
  ];

  // Design Formats
  static const Map<String, Map<String, double>> designFormats = {
    'Instagram Post': {'width': 1080, 'height': 1080},
    'Instagram Story': {'width': 1080, 'height': 1920},
    'Facebook Post': {'width': 1200, 'height': 630},
    'Twitter Post': {'width': 1024, 'height': 512},
    'LinkedIn Post': {'width': 1200, 'height': 627},
    'YouTube Thumbnail': {'width': 1280, 'height': 720},
    'Presentation': {'width': 1920, 'height': 1080},
    'A4 Document': {'width': 2480, 'height': 3508},
    'Business Card': {'width': 1050, 'height': 600},
    'Flyer': {'width': 2480, 'height': 3508},
    'Logo': {'width': 500, 'height': 500},
    'Banner': {'width': 1500, 'height': 500},
  };

  // File Formats
  static const List<String> supportedImageFormats = [
    'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'
  ];
  
  static const List<String> supportedVideoFormats = [
    'mp4', 'mov', 'avi', 'mkv', 'webm'
  ];

  static const List<String> exportFormats = [
    'PNG', 'JPG', 'PDF', 'MP4', 'GIF'
  ];

  // AI Features
  static const List<String> aiFeatures = [
    'Magic Design',
    'Magic Edit',
    'Magic Eraser',
    'Text to Image',
    'Background Remover',
    'Magic Translate',
  ];

  // Subscription Tiers
  static const Map<String, List<String>> subscriptionFeatures = {
    'Free': [
      '250,000+ free templates',
      '100+ design types',
      '5GB cloud storage',
      'Basic photo editing',
    ],
    'Pro': [
      'Everything in Free',
      'Premium templates',
      '100GB cloud storage',
      'Background remover',
      'Magic resize',
      'Brand kit',
      'Team collaboration',
    ],
    'Teams': [
      'Everything in Pro',
      'Unlimited storage',
      'Advanced team features',
      'Brand controls',
      'Priority support',
    ],
  };

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Grid Constants
  static const int templatesPerRow = 2;
  static const int assetsPerRow = 3;
  static const double gridSpacing = 12.0;

  // Search
  static const int maxSearchResults = 50;
  static const Duration searchDebounce = Duration(milliseconds: 500);

  // Cache
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB

  // Error Messages
  static const String networkError = 'Network connection failed. Please check your internet connection.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String fileNotFound = 'File not found or corrupted.';
  static const String permissionDenied = 'Permission denied. Please grant necessary permissions.';
  static const String storageError = 'Storage error. Please check available space.';
}