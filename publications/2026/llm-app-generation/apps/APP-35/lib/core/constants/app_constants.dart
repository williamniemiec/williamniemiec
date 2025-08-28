class AppConstants {
  // App Info
  static const String appName = 'Sleeper';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.sleeper.app/v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Sports
  static const List<String> supportedSports = ['nfl', 'nba', 'soccer'];
  
  // League Types
  static const List<String> leagueTypes = ['redraft', 'keeper', 'dynasty'];
  
  // Draft Types
  static const List<String> draftTypes = ['snake', 'linear', 'auction'];
  
  // Roster Positions
  static const Map<String, List<String>> rosterPositions = {
    'nfl': ['QB', 'RB', 'WR', 'TE', 'K', 'DEF', 'FLEX', 'SUPER_FLEX'],
    'nba': ['PG', 'SG', 'SF', 'PF', 'C', 'G', 'F', 'UTIL'],
    'soccer': ['GK', 'DEF', 'MID', 'FWD', 'UTIL'],
  };
  
  // Scoring Types
  static const List<String> scoringTypes = ['standard', 'ppr', 'half_ppr', 'custom'];
  
  // Waiver Types
  static const List<String> waiverTypes = ['faab', 'rolling', 'reverse_standings'];
  
  // Chat & Social
  static const int maxMessageLength = 500;
  static const int maxGroupChatMembers = 50;
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'gif'];
  
  // Real Money Gaming (Sleeper Picks)
  static const double minPickAmount = 1.0;
  static const double maxPickAmount = 1000.0;
  static const int maxPicksPerEntry = 10;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Cache Keys
  static const String userCacheKey = 'user_data';
  static const String leaguesCacheKey = 'leagues_data';
  static const String playersCacheKey = 'players_data';
  static const String newsCacheKey = 'news_data';
  
  // Notification Types
  static const String tradeNotification = 'trade';
  static const String waiverNotification = 'waiver';
  static const String draftNotification = 'draft';
  static const String gameNotification = 'game';
  static const String messageNotification = 'message';
  
  // Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String authError = 'Authentication failed. Please log in again.';
  
  // Success Messages
  static const String leagueCreated = 'League created successfully!';
  static const String tradeProposed = 'Trade proposal sent!';
  static const String playerAdded = 'Player added to your team!';
  static const String messageSent = 'Message sent!';
}