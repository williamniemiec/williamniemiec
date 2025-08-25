class AppConstants {
  // App Information
  static const String appName = 'WhatsApp Business';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const String primaryColorHex = '#25D366';
  static const String secondaryColorHex = '#128C7E';
  static const String accentColorHex = '#DCF8C6';
  static const String backgroundColorHex = '#FFFFFF';
  static const String darkBackgroundColorHex = '#0B141A';
  static const String chatBubbleColorHex = '#E3F2FD';
  static const String businessBubbleColorHex = '#25D366';
  
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double avatarRadius = 20.0;
  static const double iconSize = 24.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Message Limits
  static const int maxMessageLength = 4096;
  static const int maxCatalogItems = 500;
  static const int maxQuickReplies = 50;
  static const int maxLabels = 20;
  
  // File Sizes (in bytes)
  static const int maxImageSize = 16 * 1024 * 1024; // 16MB
  static const int maxVideoSize = 64 * 1024 * 1024; // 64MB
  static const int maxAudioSize = 16 * 1024 * 1024; // 16MB
  static const int maxDocumentSize = 100 * 1024 * 1024; // 100MB
  
  // Business Categories
  static const List<String> businessCategories = [
    'Retail',
    'Food & Beverage',
    'Health & Beauty',
    'Automotive',
    'Education',
    'Real Estate',
    'Professional Services',
    'Technology',
    'Entertainment',
    'Travel & Tourism',
    'Fashion & Apparel',
    'Home & Garden',
    'Sports & Recreation',
    'Non-profit',
    'Other',
  ];
  
  // Currency Codes
  static const List<String> supportedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'BRL',
    'MXN',
    'ZAR',
  ];
  
  // Default Messages
  static const String defaultGreetingMessage = 
      'Hello! Thank you for contacting us. How can we help you today?';
  
  static const String defaultAwayMessage = 
      'Thank you for your message. We are currently away but will get back to you as soon as possible.';
  
  // Quick Reply Shortcuts
  static const Map<String, String> defaultQuickReplies = {
    '/thanks': 'Thank you for your message!',
    '/hours': 'Our business hours are Monday-Friday 9AM-6PM.',
    '/location': 'You can find us at our main location. Please check our profile for the address.',
    '/contact': 'You can reach us through this WhatsApp number or check our profile for other contact methods.',
  };
  
  // Database
  static const String databaseName = 'whatsapp_business.db';
  static const int databaseVersion = 1;
  
  // Storage Keys
  static const String businessProfileKey = 'business_profile';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  
  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.whatsappbusiness.com';
  static const String authEndpoint = '/auth';
  static const String messagesEndpoint = '/messages';
  static const String catalogEndpoint = '/catalog';
  static const String profileEndpoint = '/profile';
}