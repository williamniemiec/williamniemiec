import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Duolingo Clone';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const Color primaryGreen = Color(0xFF58CC02);
  static const Color darkGreen = Color(0xFF46A302);
  static const Color lightGreen = Color(0xFF89E219);
  static const Color blue = Color(0xFF1CB0F6);
  static const Color darkBlue = Color(0xFF1899D6);
  static const Color red = Color(0xFFFF4B4B);
  static const Color orange = Color(0xFFFF9600);
  static const Color yellow = Color(0xFFFFC800);
  static const Color purple = Color(0xFFCE82FF);
  static const Color pink = Color(0xFFFF86D0);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF7F7F7);
  static const Color gray = Color(0xFFAFAFAF);
  static const Color darkGray = Color(0xFF777777);
  static const Color black = Color(0xFF3C3C3C);
  
  // Gamification
  static const int defaultHearts = 5;
  static const int defaultGems = 500;
  static const int defaultDailyXPGoal = 20;
  static const int lessonXPReward = 10;
  static const int storyXPReward = 15;
  static const int practiceXPReward = 5;
  
  // Hearts System
  static const int heartRefillTimeMinutes = 30;
  static const int heartRefillCostGems = 350;
  
  // Streak System
  static const int streakFreezeGemsCost = 200;
  
  // Leagues
  static const Map<String, Color> leagueColors = {
    'Bronze': Color(0xFFCD7F32),
    'Silver': Color(0xFFC0C0C0),
    'Gold': Color(0xFFFFD700),
    'Sapphire': Color(0xFF0F52BA),
    'Ruby': Color(0xFFE0115F),
    'Emerald': Color(0xFF50C878),
    'Amethyst': Color(0xFF9966CC),
    'Pearl': Color(0xFFF0EAD6),
    'Obsidian': Color(0xFF3C3C3C),
    'Diamond': Color(0xFFB9F2FF),
  };
  
  // Exercise Types
  static const List<String> exerciseTypes = [
    'Translation',
    'Multiple Choice',
    'Matching',
    'Listening',
    'Speaking',
    'Fill in the Blank',
    'Word Bank',
    'Image Selection',
  ];
  
  // Languages
  static const Map<String, String> supportedLanguages = {
    'Spanish': '🇪🇸',
    'French': '🇫🇷',
    'German': '🇩🇪',
    'Italian': '🇮🇹',
    'Portuguese': '🇵🇹',
    'Japanese': '🇯🇵',
    'Korean': '🇰🇷',
    'Chinese': '🇨🇳',
    'Russian': '🇷🇺',
    'Arabic': '🇸🇦',
  };
  
  // Animations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Font Sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 24.0;
  static const double fontSizeXXL = 32.0;
  
  // Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  
  // Achievement Rarities
  static const Map<String, Color> achievementRarityColors = {
    'common': Color(0xFF777777),
    'rare': Color(0xFF1CB0F6),
    'epic': Color(0xFFCE82FF),
    'legendary': Color(0xFFFFD700),
  };
  
  // Audio Settings
  static const double defaultSpeechRate = 0.8;
  static const double defaultVolume = 1.0;
  static const double defaultPitch = 1.0;
  
  // Local Storage Keys
  static const String userDataKey = 'user_data';
  static const String lessonsDataKey = 'lessons_data';
  static const String achievementsDataKey = 'achievements_data';
  static const String storiesDataKey = 'stories_data';
  static const String settingsKey = 'app_settings';
  static const String streakDataKey = 'streak_data';
  static const String heartsDataKey = 'hearts_data';
  
  // API Endpoints (for future backend integration)
  static const String baseUrl = 'https://api.duolingoClone.com';
  static const String authEndpoint = '/auth';
  static const String lessonsEndpoint = '/lessons';
  static const String leaderboardEndpoint = '/leaderboard';
  static const String achievementsEndpoint = '/achievements';
  static const String storiesEndpoint = '/stories';
  
  // Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String noHeartsError = 'You\'re out of hearts! Wait for them to refill or use gems.';
  static const String lessonLockedError = 'Complete previous lessons to unlock this one.';
  
  // Success Messages
  static const String lessonCompleted = 'Lesson completed! Great job!';
  static const String streakMaintained = 'Streak maintained! Keep it up!';
  static const String achievementUnlocked = 'Achievement unlocked!';
  static const String levelUp = 'Level up! You\'re making great progress!';
}