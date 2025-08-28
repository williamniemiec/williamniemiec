class AppConstants {
  // App Information
  static const String appName = 'ChatGPT';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'AI-powered conversational assistant';
  
  // API Configuration
  static const String openAIBaseUrl = 'https://api.openai.com/v1';
  static const String dalleModel = 'dall-e-3';
  static const String defaultChatModel = 'gpt-3.5-turbo';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String authKey = 'is_authenticated';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String subscriptionKey = 'subscription_tier';
  static const String conversationsKey = 'conversations';
  static const String firstTimeKey = 'is_first_time';
  
  // Subscription
  static const double monthlyPrice = 20.0;
  static const double yearlyPrice = 200.0;
  static const int freeMessageLimit = 50;
  static const int freeImageLimit = 3;
  
  // Voice Settings
  static const String defaultLanguage = 'en-US';
  static const double defaultSpeechRate = 0.5;
  static const double defaultVolume = 1.0;
  static const double defaultPitch = 1.0;
  
  // Image Settings
  static const String defaultImageSize = '1024x1024';
  static const String defaultImageQuality = 'standard';
  static const int maxImageWidth = 1024;
  static const int maxImageHeight = 1024;
  static const int imageQuality = 85;
  
  // Chat Settings
  static const int maxTokens = 1000;
  static const double temperature = 0.7;
  static const Duration typingDelay = Duration(milliseconds: 50);
  static const Duration responseTimeout = Duration(seconds: 30);
  
  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 0.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 32.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Error Messages
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String apiKeyError = 'API key is invalid or missing.';
  static const String rateLimitError = 'Rate limit exceeded. Please try again later.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String permissionError = 'Permission denied. Please grant the required permissions.';
  
  // Success Messages
  static const String messageSent = 'Message sent successfully';
  static const String imageSaved = 'Image saved to gallery';
  static const String settingsSaved = 'Settings saved successfully';
  static const String subscriptionSuccess = 'Subscription activated successfully';
  
  // Placeholder Texts
  static const String messageHint = 'Message ChatGPT...';
  static const String searchHint = 'Search conversations...';
  static const String emptyConversations = 'No conversations yet';
  static const String emptyMessages = 'Start a new conversation';
  
  // Feature Flags
  static const bool enableVoiceMode = true;
  static const bool enableImageGeneration = true;
  static const bool enableImageAnalysis = true;
  static const bool enableCrossDeviceSync = true;
  static const bool enablePushNotifications = false;
  
  // URLs
  static const String privacyPolicyUrl = 'https://openai.com/privacy';
  static const String termsOfServiceUrl = 'https://openai.com/terms';
  static const String supportUrl = 'https://help.openai.com';
  static const String appStoreUrl = 'https://apps.apple.com/app/chatgpt';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.openai.chatgpt';
}