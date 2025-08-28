class AppConstants {
  // App Information
  static const String appName = 'Spotify';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.spotify.com/v1';
  static const String authUrl = 'https://accounts.spotify.com';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String playlistsKey = 'playlists';
  static const String likedSongsKey = 'liked_songs';
  static const String recentlyPlayedKey = 'recently_played';
  static const String downloadedTracksKey = 'downloaded_tracks';
  static const String settingsKey = 'settings';
  
  // Audio Quality
  static const int lowQualityBitrate = 96;
  static const int normalQualityBitrate = 160;
  static const int highQualityBitrate = 320;
  
  // Playlist Limits
  static const int maxPlaylistNameLength = 100;
  static const int maxPlaylistDescriptionLength = 300;
  static const int maxTracksPerPlaylist = 10000;
  
  // Search
  static const int searchResultsLimit = 50;
  static const int searchHistoryLimit = 20;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Player Constants
  static const Duration seekDuration = Duration(seconds: 10);
  static const Duration fadeInDuration = Duration(milliseconds: 500);
  static const Duration fadeOutDuration = Duration(milliseconds: 300);
  
  // Network
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // Premium Features
  static const int freeSkipLimit = 6; // per hour
  static const Duration freeAdInterval = Duration(minutes: 30);
  
  // Social Features
  static const int maxFriendsVisible = 10;
  static const Duration friendActivityUpdateInterval = Duration(seconds: 30);
  
  // Offline
  static const int maxOfflineDownloads = 10000; // Premium
  static const int maxOfflineDownloadsFree = 0; // Free users can't download
  
  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection';
  static const String serverErrorMessage = 'Something went wrong. Please try again';
  static const String authErrorMessage = 'Please log in to continue';
  static const String premiumRequiredMessage = 'This feature requires Spotify Premium';
  
  // Success Messages
  static const String trackLikedMessage = 'Added to Liked Songs';
  static const String trackUnlikedMessage = 'Removed from Liked Songs';
  static const String playlistCreatedMessage = 'Playlist created';
  static const String playlistDeletedMessage = 'Playlist deleted';
  static const String trackAddedToPlaylistMessage = 'Added to playlist';
  
  // Genre Categories
  static const List<String> musicGenres = [
    'Pop',
    'Hip-Hop',
    'Rock',
    'Electronic',
    'Country',
    'R&B',
    'Jazz',
    'Classical',
    'Reggae',
    'Blues',
    'Folk',
    'Alternative',
    'Indie',
    'Metal',
    'Punk',
    'Funk',
    'Soul',
    'Gospel',
    'Latin',
    'World',
  ];
  
  static const List<String> podcastCategories = [
    'Arts',
    'Business',
    'Comedy',
    'Education',
    'Fiction',
    'Government',
    'Health & Fitness',
    'History',
    'Kids & Family',
    'Leisure',
    'Music',
    'News',
    'Religion & Spirituality',
    'Science',
    'Society & Culture',
    'Sports',
    'Technology',
    'True Crime',
    'TV & Film',
  ];
  
  // Mood Categories
  static const List<String> moods = [
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
    'Commute',
    'Cooking',
    'Gaming',
    'Road Trip',
    'Rainy Day',
  ];
  
  // Time-based Greetings
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
  
  // Format Duration
  static String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Format Number
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class AppImages {
  static const String logoPath = 'assets/images/spotify_logo.png';
  static const String defaultAlbumArt = 'assets/images/default_album.png';
  static const String defaultProfileImage = 'assets/images/default_profile.png';
  static const String defaultPlaylistCover = 'assets/images/default_playlist.png';
  static const String premiumBadge = 'assets/images/premium_badge.png';
}

class AppIcons {
  static const String home = 'assets/icons/home.svg';
  static const String search = 'assets/icons/search.svg';
  static const String library = 'assets/icons/library.svg';
  static const String play = 'assets/icons/play.svg';
  static const String pause = 'assets/icons/pause.svg';
  static const String next = 'assets/icons/next.svg';
  static const String previous = 'assets/icons/previous.svg';
  static const String shuffle = 'assets/icons/shuffle.svg';
  static const String repeat = 'assets/icons/repeat.svg';
  static const String heart = 'assets/icons/heart.svg';
  static const String heartFilled = 'assets/icons/heart_filled.svg';
  static const String download = 'assets/icons/download.svg';
  static const String share = 'assets/icons/share.svg';
  static const String more = 'assets/icons/more.svg';
  static const String add = 'assets/icons/add.svg';
  static const String close = 'assets/icons/close.svg';
  static const String back = 'assets/icons/back.svg';
  static const String forward = 'assets/icons/forward.svg';
  static const String volume = 'assets/icons/volume.svg';
  static const String devices = 'assets/icons/devices.svg';
  static const String queue = 'assets/icons/queue.svg';
  static const String lyrics = 'assets/icons/lyrics.svg';
}