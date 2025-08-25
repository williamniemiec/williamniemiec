import '../../../shared/models/design_style.dart';
import '../../../shared/models/room_type.dart';
import '../../../shared/models/subscription.dart';

class AppConstants {
  // App Info
  static const String appName = 'AI Home Design';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Transform your space with AI-powered interior and exterior design';

  // API Configuration
  static const String baseApiUrl = 'https://api.aihomedesign.com';
  static const String aiGenerationEndpoint = '/api/v1/generate';
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration aiProcessingTimeout = Duration(minutes: 5);

  // Storage Keys
  static const String userSubscriptionKey = 'user_subscription';
  static const String savedProjectsKey = 'saved_projects';
  static const String appSettingsKey = 'app_settings';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String lastUsedRoomTypeKey = 'last_used_room_type';
  static const String lastUsedStyleKey = 'last_used_style';

  // Free Tier Limits
  static const int freeGenerationsPerDay = 3;
  static const int freeGenerationsPerWeek = 10;
  static const int maxSavedProjectsFree = 20;

  // Premium Features
  static const int premiumMaxResolution = 2048;
  static const int freeMaxResolution = 1024;
  static const List<String> premiumOnlyStyles = [
    'luxury_modern',
    'art_deco',
    'maximalist',
    'gothic',
    'futuristic',
  ];

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double buttonHeight = 48.0;
  static const double iconSize = 24.0;
  static const double largeIconSize = 48.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Image Processing
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const double imageCompressionQuality = 0.8;

  // Default Room Types
  static const List<RoomType> defaultRoomTypes = [
    // Interior Rooms
    RoomType(
      id: 'living_room',
      name: 'Living Room',
      description: 'Main living and entertainment space',
      iconPath: 'assets/icons/living_room.png',
      category: RoomCategory.interior,
      suggestedStyles: ['modern', 'scandinavian', 'minimalist', 'bohemian'],
    ),
    RoomType(
      id: 'bedroom',
      name: 'Bedroom',
      description: 'Personal sleeping and relaxation space',
      iconPath: 'assets/icons/bedroom.png',
      category: RoomCategory.interior,
      suggestedStyles: ['scandinavian', 'minimalist', 'bohemian', 'coastal'],
    ),
    RoomType(
      id: 'kitchen',
      name: 'Kitchen',
      description: 'Cooking and dining preparation area',
      iconPath: 'assets/icons/kitchen.png',
      category: RoomCategory.interior,
      suggestedStyles: ['modern', 'farmhouse', 'industrial', 'scandinavian'],
    ),
    RoomType(
      id: 'bathroom',
      name: 'Bathroom',
      description: 'Personal hygiene and bathing space',
      iconPath: 'assets/icons/bathroom.png',
      category: RoomCategory.interior,
      suggestedStyles: ['modern', 'minimalist', 'spa', 'industrial'],
    ),
    RoomType(
      id: 'dining_room',
      name: 'Dining Room',
      description: 'Formal dining and entertaining space',
      iconPath: 'assets/icons/dining_room.png',
      category: RoomCategory.interior,
      suggestedStyles: ['modern', 'farmhouse', 'traditional', 'industrial'],
    ),
    RoomType(
      id: 'office',
      name: 'Home Office',
      description: 'Work and study space',
      iconPath: 'assets/icons/office.png',
      category: RoomCategory.interior,
      suggestedStyles: ['modern', 'minimalist', 'industrial', 'scandinavian'],
    ),
    
    // Exterior Spaces
    RoomType(
      id: 'house_exterior',
      name: 'House Exterior',
      description: 'Front and side views of the house',
      iconPath: 'assets/icons/house_exterior.png',
      category: RoomCategory.exterior,
      suggestedStyles: ['modern', 'farmhouse', 'colonial', 'contemporary'],
    ),
    RoomType(
      id: 'garden',
      name: 'Garden',
      description: 'Outdoor landscaping and garden space',
      iconPath: 'assets/icons/garden.png',
      category: RoomCategory.exterior,
      suggestedStyles: ['tropical', 'zen', 'cottage', 'modern'],
    ),
    RoomType(
      id: 'patio',
      name: 'Patio',
      description: 'Outdoor entertaining and relaxation area',
      iconPath: 'assets/icons/patio.png',
      category: RoomCategory.exterior,
      suggestedStyles: ['coastal', 'tropical', 'modern', 'rustic'],
    ),
    RoomType(
      id: 'balcony',
      name: 'Balcony',
      description: 'Small outdoor space attached to building',
      iconPath: 'assets/icons/balcony.png',
      category: RoomCategory.exterior,
      suggestedStyles: ['minimalist', 'bohemian', 'urban', 'coastal'],
    ),
  ];

  // Default Design Styles
  static const List<DesignStyle> defaultDesignStyles = [
    DesignStyle(
      id: 'modern',
      name: 'Modern',
      description: 'Clean lines, neutral colors, and contemporary furniture',
      thumbnailUrl: 'assets/sample_designs/modern_thumb.jpg',
      category: 'Contemporary',
      tags: ['clean', 'minimal', 'contemporary'],
    ),
    DesignStyle(
      id: 'minimalist',
      name: 'Minimalist',
      description: 'Less is more - simple, uncluttered spaces',
      thumbnailUrl: 'assets/sample_designs/minimalist_thumb.jpg',
      category: 'Contemporary',
      tags: ['simple', 'clean', 'uncluttered'],
    ),
    DesignStyle(
      id: 'scandinavian',
      name: 'Scandinavian',
      description: 'Light woods, cozy textures, and hygge vibes',
      thumbnailUrl: 'assets/sample_designs/scandinavian_thumb.jpg',
      category: 'Nordic',
      tags: ['cozy', 'light', 'natural'],
    ),
    DesignStyle(
      id: 'bohemian',
      name: 'Bohemian',
      description: 'Eclectic mix of colors, patterns, and textures',
      thumbnailUrl: 'assets/sample_designs/bohemian_thumb.jpg',
      category: 'Eclectic',
      tags: ['colorful', 'eclectic', 'artistic'],
    ),
    DesignStyle(
      id: 'industrial',
      name: 'Industrial',
      description: 'Raw materials, exposed brick, and metal accents',
      thumbnailUrl: 'assets/sample_designs/industrial_thumb.jpg',
      category: 'Urban',
      tags: ['raw', 'metal', 'urban'],
    ),
    DesignStyle(
      id: 'farmhouse',
      name: 'Farmhouse',
      description: 'Rustic charm with vintage and country elements',
      thumbnailUrl: 'assets/sample_designs/farmhouse_thumb.jpg',
      category: 'Rustic',
      tags: ['rustic', 'vintage', 'country'],
    ),
    DesignStyle(
      id: 'coastal',
      name: 'Coastal',
      description: 'Beach-inspired with blues, whites, and natural textures',
      thumbnailUrl: 'assets/sample_designs/coastal_thumb.jpg',
      category: 'Natural',
      tags: ['beach', 'blue', 'natural'],
    ),
    DesignStyle(
      id: 'tropical',
      name: 'Tropical',
      description: 'Lush greens, natural materials, and exotic vibes',
      thumbnailUrl: 'assets/sample_designs/tropical_thumb.jpg',
      category: 'Natural',
      tags: ['green', 'exotic', 'natural'],
    ),
  ];

  // Default Subscription Plans
  static const List<SubscriptionPlan> defaultSubscriptionPlans = [
    SubscriptionPlan(
      id: 'premium_weekly',
      name: 'Premium Weekly',
      description: 'Full access for one week',
      tier: SubscriptionTier.premium,
      period: SubscriptionPeriod.weekly,
      price: 4.99,
      features: [
        'Unlimited design generations',
        'All premium styles',
        'High resolution exports',
        'Ad-free experience',
        'Priority processing',
      ],
    ),
    SubscriptionPlan(
      id: 'premium_monthly',
      name: 'Premium Monthly',
      description: 'Full access for one month',
      tier: SubscriptionTier.premium,
      period: SubscriptionPeriod.monthly,
      price: 14.99,
      features: [
        'Unlimited design generations',
        'All premium styles',
        'High resolution exports',
        'Ad-free experience',
        'Priority processing',
        'Save unlimited projects',
      ],
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'premium_yearly',
      name: 'Premium Yearly',
      description: 'Full access for one year',
      tier: SubscriptionTier.premium,
      period: SubscriptionPeriod.yearly,
      price: 99.99,
      features: [
        'Unlimited design generations',
        'All premium styles',
        'High resolution exports',
        'Ad-free experience',
        'Priority processing',
        'Save unlimited projects',
        'Early access to new features',
      ],
      discountText: 'Save 44%',
    ),
  ];
}