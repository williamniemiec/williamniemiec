class AppConstants {
  // App Information
  static const String appName = 'YouTube Music';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Stream music and videos from YouTube';

  // API Configuration
  static const String baseApiUrl = 'https://api.youtubemusic.com/v1';
  static const String youtubeApiKey = 'YOUR_YOUTUBE_API_KEY';
  static const String firebaseProjectId = 'youtube-music-app';

  // Storage Keys
  static const String userBoxKey = 'user_box';
  static const String songsBoxKey = 'songs_box';
  static const String playlistsBoxKey = 'playlists_box';
  static const String artistsBoxKey = 'artists_box';
  static const String albumsBoxKey = 'albums_box';
  static const String settingsBoxKey = 'settings_box';
  static const String cacheBoxKey = 'cache_box';

  // Shared Preferences Keys
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String isDarkModeKey = 'is_dark_mode';
  static const String audioQualityKey = 'audio_quality';
  static const String downloadQualityKey = 'download_quality';
  static const String isOfflineModeKey = 'is_offline_mode';
  static const String lastPlayedSongKey = 'last_played_song';
  static const String playbackPositionKey = 'playback_position';
  static const String shuffleModeKey = 'shuffle_mode';
  static const String repeatModeKey = 'repeat_mode';

  // Audio Quality Settings
  static const String audioQualityLow = 'low';
  static const String audioQualityMedium = 'medium';
  static const String audioQualityHigh = 'high';
  static const String audioQualityLossless = 'lossless';

  // Repeat Modes
  static const String repeatModeOff = 'off';
  static const String repeatModeOne = 'one';
  static const String repeatModeAll = 'all';

  // Premium Features
  static const List<String> premiumFeatures = [
    'Ad-free listening',
    'Background play',
    'Offline downloads',
    'Audio-only mode',
    'High-quality audio',
    'YouTube Originals access',
  ];

  // Subscription Plans
  static const Map<String, dynamic> subscriptionPlans = {
    'individual': {
      'name': 'Individual',
      'price': 9.99,
      'currency': 'USD',
      'duration': 'month',
      'features': premiumFeatures,
    },
    'family': {
      'name': 'Family',
      'price': 14.99,
      'currency': 'USD',
      'duration': 'month',
      'features': premiumFeatures,
      'maxMembers': 6,
    },
    'student': {
      'name': 'Student',
      'price': 4.99,
      'currency': 'USD',
      'duration': 'month',
      'features': premiumFeatures,
    },
  };

  // Default Playlists
  static const List<String> defaultPlaylistNames = [
    'Liked Music',
    'Downloaded',
    'Recently Played',
    'Your Mix',
    'Discover Mix',
    'New Release Mix',
  ];

  // Music Categories
  static const List<String> musicCategories = [
    'Pop',
    'Rock',
    'Hip Hop',
    'Electronic',
    'Country',
    'R&B',
    'Jazz',
    'Classical',
    'Reggae',
    'Folk',
    'Blues',
    'Punk',
    'Metal',
    'Alternative',
    'Indie',
  ];

  // Mood Categories
  static const List<String> moodCategories = [
    'Happy',
    'Sad',
    'Energetic',
    'Chill',
    'Focus',
    'Workout',
    'Party',
    'Romance',
    'Sleep',
    'Study',
    'Motivation',
    'Relaxation',
  ];

  // Activity Categories
  static const List<String> activityCategories = [
    'Commute',
    'Cooking',
    'Gaming',
    'Running',
    'Yoga',
    'Cleaning',
    'Reading',
    'Working',
    'Driving',
    'Walking',
  ];

  // Network Configuration
  static const int connectionTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // Cache Configuration
  static const int maxCacheSize = 500; // MB
  static const int maxCacheAge = 7; // days
  static const int maxRecentlyPlayedItems = 50;
  static const int maxSearchHistoryItems = 20;

  // Player Configuration
  static const double defaultVolume = 0.8;
  static const Duration seekForwardDuration = Duration(seconds: 15);
  static const Duration seekBackwardDuration = Duration(seconds: 15);
  static const Duration crossfadeDuration = Duration(milliseconds: 500);

  // UI Configuration
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double bottomSheetBorderRadius = 20.0;
  static const int animationDurationMs = 300;
  static const int shimmerAnimationDurationMs = 1500;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // File Extensions
  static const List<String> supportedAudioFormats = [
    'mp3',
    'aac',
    'm4a',
    'flac',
    'wav',
    'ogg',
  ];

  static const List<String> supportedVideoFormats = [
    'mp4',
    'webm',
    'mkv',
    'avi',
  ];

  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String serverErrorMessage = 'Server error. Please try again later';
  static const String unauthorizedErrorMessage = 'Please sign in to continue';
  static const String premiumRequiredMessage = 'This feature requires YouTube Music Premium';
  static const String downloadFailedMessage = 'Download failed. Please try again';
  static const String playbackErrorMessage = 'Unable to play this song';

  // Success Messages
  static const String downloadCompleteMessage = 'Download completed';
  static const String playlistCreatedMessage = 'Playlist created successfully';
  static const String songAddedToPlaylistMessage = 'Song added to playlist';
  static const String songRemovedFromPlaylistMessage = 'Song removed from playlist';
}