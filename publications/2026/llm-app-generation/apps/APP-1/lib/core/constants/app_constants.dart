class AppConstants {
  // App Info
  static const String appName = 'Audible';
  static const String appVersion = '1.0.0';
  
  // API
  static const String baseUrl = 'https://api.audible.com/v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String userKey = 'user_data';
  static const String playbackStateKey = 'playback_state';
  static const String preferencesKey = 'user_preferences';
  static const String libraryKey = 'user_library';
  static const String downloadsKey = 'downloads';
  static const String bookmarksKey = 'bookmarks';
  static const String collectionsKey = 'collections';
  static const String wishlistKey = 'wishlist';
  
  // Playback
  static const Duration skipForwardDuration = Duration(seconds: 30);
  static const Duration skipBackwardDuration = Duration(seconds: 30);
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 3.5];
  static const double defaultPlaybackSpeed = 1.0;
  
  // Sleep Timer Options (in minutes)
  static const List<int> sleepTimerOptions = [5, 10, 15, 30, 45, 60, 90, 120];
  
  // UI
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;
  
  // Download
  static const int maxConcurrentDownloads = 3;
  static const int downloadRetryAttempts = 3;
  
  // Cache
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
  
  // Image Sizes
  static const int thumbnailSize = 150;
  static const int mediumImageSize = 300;
  static const int largeImageSize = 600;
  
  // Genres
  static const List<String> genres = [
    'Fiction',
    'Non-Fiction',
    'Mystery & Thriller',
    'Romance',
    'Science Fiction & Fantasy',
    'Biography & Memoir',
    'Business',
    'Self Development',
    'History',
    'Science',
    'Politics & Social Sciences',
    'Religion & Spirituality',
    'Health & Wellness',
    'Parenting & Relationships',
    'Education & Learning',
    'Arts & Entertainment',
    'Travel & Adventure',
    'True Crime',
    'Young Adult',
    'Children\'s',
  ];
  
  // Podcast Categories
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
  
  // Error Messages
  static const String networkError = 'Network connection error. Please check your internet connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
  static const String authError = 'Authentication failed. Please sign in again.';
  static const String downloadError = 'Download failed. Please try again.';
  static const String playbackError = 'Playback error. Please try again.';
  
  // Success Messages
  static const String downloadComplete = 'Download completed successfully.';
  static const String addedToLibrary = 'Added to your library.';
  static const String addedToWishlist = 'Added to your wishlist.';
  static const String removedFromWishlist = 'Removed from your wishlist.';
  static const String bookmarkAdded = 'Bookmark added.';
  static const String bookmarkRemoved = 'Bookmark removed.';
  
  // Membership
  static const int freeTrialDays = 30;
  static const int premiumPlusCredits = 1;
  static const double memberDiscount = 0.3; // 30% discount
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String home = '/home';
  static const String library = '/library';
  static const String discover = '/discover';
  static const String player = '/player';
  static const String bookDetails = '/book-details';
  static const String podcastDetails = '/podcast-details';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String downloads = '/downloads';
  static const String wishlist = '/wishlist';
  static const String collections = '/collections';
  static const String search = '/search';
  static const String genres = '/genres';
  static const String bookmarks = '/bookmarks';
}

class AppImages {
  static const String logo = 'assets/images/logo.png';
  static const String logoWhite = 'assets/images/logo_white.png';
  static const String placeholder = 'assets/images/placeholder.png';
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String emptyLibrary = 'assets/images/empty_library.png';
  static const String emptyWishlist = 'assets/images/empty_wishlist.png';
  static const String noInternet = 'assets/images/no_internet.png';
}

class AppIcons {
  static const String home = 'assets/icons/home.svg';
  static const String library = 'assets/icons/library.svg';
  static const String discover = 'assets/icons/discover.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String play = 'assets/icons/play.svg';
  static const String pause = 'assets/icons/pause.svg';
  static const String skipForward = 'assets/icons/skip_forward.svg';
  static const String skipBackward = 'assets/icons/skip_backward.svg';
  static const String download = 'assets/icons/download.svg';
  static const String bookmark = 'assets/icons/bookmark.svg';
  static const String heart = 'assets/icons/heart.svg';
  static const String share = 'assets/icons/share.svg';
  static const String settings = 'assets/icons/settings.svg';
}