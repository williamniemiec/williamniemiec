class AppConstants {
  // App Info
  static const String appName = 'Tea';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your AI-powered dating wingman';

  // API Configuration
  static const String baseUrl = 'https://api.tea-app.com';
  static const String aiEndpoint = '/ai/chat';
  static const String subscriptionEndpoint = '/subscription';
  
  // Free Tier Limits
  static const int dailyFreeAnalyses = 3;
  static const int dailyFreeRoasts = 2;
  static const int dailyFreeBios = 2;
  static const int dailyFreeRizz = 5;
  
  // Premium Features
  static const List<String> premiumFeatures = [
    'Unlimited chat analyses',
    'Unlimited profile roasts',
    'Unlimited bio generation',
    'Unlimited rizz lines',
    'Priority AI responses',
    'Advanced conversation insights',
    'Profile optimization tips',
    'Dating success analytics',
  ];

  // Subscription Product IDs
  static const String weeklySubscriptionId = 'tea_weekly_premium';
  static const String monthlySubscriptionId = 'tea_monthly_premium';
  static const String lifetimeSubscriptionId = 'tea_lifetime_premium';

  // Storage Keys
  static const String userKey = 'user_data';
  static const String subscriptionKey = 'subscription_data';
  static const String chatHistoryKey = 'chat_history';
  static const String profilesKey = 'dating_profiles';
  static const String settingsKey = 'app_settings';

  // Feature Prompts
  static const String chatAnalysisPrompt = '''
Analyze this dating conversation screenshot and provide:
1. A brief summary of the conversation tone and context
2. 3-5 creative, engaging reply suggestions that match the conversation style
3. Tips for keeping the conversation flowing

Be witty, authentic, and helpful. Consider the person's personality shown in the chat.
''';

  static const String profileRoastPrompt = '''
Roast this dating profile with constructive humor:
1. Give an honest, funny critique of the bio and photos
2. Provide specific, actionable improvement suggestions
3. Rate the profile out of 10 and explain the score
4. Suggest 2-3 alternative bio options

Be brutally honest but helpful. The goal is improvement, not just roasting.
''';

  static const String bioGeneratorPrompt = '''
Create 3 unique dating profile bios based on these interests and personality traits:
1. A witty, short bio (2-3 sentences)
2. A more detailed, storytelling bio (4-5 sentences)
3. A playful, conversation-starter bio (2-3 sentences)

Make each bio authentic, engaging, and likely to start conversations.
''';

  static const String rizzGeneratorPrompt = '''
Generate creative pickup lines and conversation starters:
1. 3 clever, personalized openers based on their profile
2. 2 witty responses to common situations
3. 1 charming way to ask for a date

Be original, respectful, and genuinely engaging. Avoid clichés.
''';

  // Error Messages
  static const String networkError = 'Network connection failed. Please check your internet and try again.';
  static const String aiError = 'AI service temporarily unavailable. Please try again in a moment.';
  static const String subscriptionError = 'Subscription service unavailable. Please try again later.';
  static const String imageUploadError = 'Failed to upload image. Please try again.';
  static const String dailyLimitReached = 'Daily limit reached. Upgrade to Premium for unlimited access.';
  static const String premiumRequired = 'This feature requires Premium. Upgrade now for unlimited access.';

  // Success Messages
  static const String subscriptionSuccess = 'Welcome to Premium! Enjoy unlimited access to all features.';
  static const String profileSaved = 'Profile saved successfully!';
  static const String feedbackSent = 'Thank you for your feedback!';

  // Onboarding
  static const List<String> onboardingTitles = [
    'Welcome to Tea',
    'AI-Powered Analysis',
    'Profile Optimization',
    'Unlimited Rizz',
  ];

  static const List<String> onboardingDescriptions = [
    'Your personal dating wingman powered by AI',
    'Upload chat screenshots for instant, witty reply suggestions',
    'Get your dating profile roasted and improved by AI',
    'Never run out of clever pickup lines and conversation starters',
  ];

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // UI Constants
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double avatarSize = 40.0;
}