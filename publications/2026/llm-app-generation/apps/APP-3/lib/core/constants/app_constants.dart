class AppConstants {
  // App Information
  static const String appName = 'Microsoft Teams';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Communication and collaboration platform';

  // API Configuration
  static const String baseUrl = 'https://api.teams.microsoft.com';
  static const String apiVersion = 'v1';
  static const Duration requestTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String settingsKey = 'app_settings';
  static const String themeKey = 'theme_mode';

  // Hive Box Names
  static const String userBox = 'users';
  static const String messageBox = 'messages';
  static const String chatBox = 'chats';
  static const String teamBox = 'teams';
  static const String meetingBox = 'meetings';
  static const String activityBox = 'activities';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB
  static const List<String> allowedImageTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];
  static const List<String> allowedVideoTypes = [
    'mp4', 'mov', 'avi', 'mkv', 'webm'
  ];
  static const List<String> allowedAudioTypes = [
    'mp3', 'wav', 'aac', 'm4a', 'ogg'
  ];
  static const List<String> allowedDocumentTypes = [
    'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'
  ];

  // Meeting Configuration
  static const Duration defaultMeetingDuration = Duration(hours: 1);
  static const Duration maxMeetingDuration = Duration(hours: 24);
  static const int maxMeetingParticipants = 1000;

  // Chat Configuration
  static const int maxMessageLength = 4000;
  static const int maxGroupChatParticipants = 250;
  static const Duration typingIndicatorTimeout = Duration(seconds: 3);

  // Notification Configuration
  static const String notificationChannelId = 'teams_notifications';
  static const String notificationChannelName = 'Teams Notifications';
  static const String notificationChannelDescription = 'Notifications for Teams app';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unknown error occurred. Please try again.';
  static const String authenticationErrorMessage = 'Authentication failed. Please sign in again.';

  // Success Messages
  static const String messageSentSuccess = 'Message sent successfully';
  static const String meetingCreatedSuccess = 'Meeting created successfully';
  static const String teamCreatedSuccess = 'Team created successfully';
  static const String fileUploadedSuccess = 'File uploaded successfully';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxDisplayNameLength = 50;
  static const int maxTeamNameLength = 100;
  static const int maxChannelNameLength = 50;

  // Feature Flags
  static const bool enableVideoCall = true;
  static const bool enableScreenSharing = true;
  static const bool enableFileSharing = true;
  static const bool enableMeetingRecording = true;
  static const bool enablePushNotifications = true;
}