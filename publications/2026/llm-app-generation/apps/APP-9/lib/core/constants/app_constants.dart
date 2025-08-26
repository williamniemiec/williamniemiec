class AppConstants {
  // App Information
  static const String appName = 'Netflix';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Stream movies, TV shows, and more';

  // API Configuration
  static const String baseUrl = 'https://api.netflix.com/v1';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String videoBaseUrl = 'https://video.netflix.com/';
  
  // Image Sizes
  static const String posterSizeSmall = 'w185';
  static const String posterSizeMedium = 'w342';
  static const String posterSizeLarge = 'w500';
  static const String backdropSizeSmall = 'w300';
  static const String backdropSizeMedium = 'w780';
  static const String backdropSizeLarge = 'w1280';

  // Content Categories
  static const List<String> movieGenres = [
    'Action & Adventure',
    'Anime',
    'Children & Family',
    'Classic Movies',
    'Comedies',
    'Documentaries',
    'Dramas',
    'Horror Movies',
    'Independent Movies',
    'International Movies',
    'Music & Musicals',
    'Romantic Movies',
    'Sci-Fi & Fantasy',
    'Sports Movies',
    'Thrillers',
  ];

  static const List<String> tvGenres = [
    'Action & Adventure',
    'Anime Series',
    'British TV Shows',
    'Classic & Cult TV',
    'Crime TV Shows',
    'Docuseries',
    'International TV Shows',
    'Kids\' TV',
    'Korean TV Shows',
    'LGBTQ TV Shows',
    'Reality TV',
    'Romantic TV Shows',
    'Sci-Fi & Fantasy',
    'Spanish-Language TV Shows',
    'Stand-Up Comedy & Talk Shows',
    'Teen TV Shows',
    'TV Action & Adventure',
    'TV Comedies',
    'TV Dramas',
    'TV Horror',
    'TV Mysteries',
    'TV Sci-Fi & Fantasy',
    'TV Thrillers',
  ];

  static const List<String> gameCategories = [
    'Action',
    'Adventure',
    'Arcade',
    'Casual',
    'Puzzle',
    'Racing',
    'RPG',
    'Simulation',
    'Sports',
    'Strategy',
  ];

  // Content Rows
  static const List<String> homeRows = [
    'Continue Watching',
    'Trending Now',
    'Netflix Originals',
    'Top 10 in Your Country',
    'New Releases',
    'Popular on Netflix',
    'Award-Winning Films',
    'Because you watched',
    'My List',
    'Watch It Again',
    'Critically Acclaimed Movies',
    'Feel-Good Movies',
    'Blockbuster Movies',
    'International Movies',
  ];

  static const List<String> newAndHotCategories = [
    'Coming This Week',
    'Worth the Wait',
    'New on Netflix',
    'Coming Soon',
    'Top 10 Movies',
    'Top 10 TV Shows',
    'Trending',
  ];

  // Subscription Plans
  static const List<String> subscriptionPlans = [
    'Basic',
    'Standard',
    'Premium',
  ];

  // Maturity Ratings
  static const List<String> maturityRatings = [
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17',
    'TV-Y',
    'TV-Y7',
    'TV-G',
    'TV-PG',
    'TV-14',
    'TV-MA',
  ];

  // Languages
  static const List<String> supportedLanguages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Japanese',
    'Korean',
    'Chinese',
    'Hindi',
    'Arabic',
    'Russian',
    'Dutch',
    'Swedish',
    'Norwegian',
    'Danish',
    'Finnish',
    'Polish',
    'Turkish',
    'Thai',
  ];

  // Download Settings
  static const int maxDownloadsPerProfile = 100;
  static const int downloadExpiryDays = 30;
  static const List<String> downloadQualities = ['Standard', 'High'];

  // Video Player Settings
  static const List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  static const int skipIntroSeconds = 10;
  static const int skipCreditsSeconds = 30;

  // Profile Settings
  static const int maxProfilesPerAccount = 5;
  static const List<String> profileAvatars = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
    'assets/images/avatars/avatar3.png',
    'assets/images/avatars/avatar4.png',
    'assets/images/avatars/avatar5.png',
    'assets/images/avatars/avatar6.png',
    'assets/images/avatars/avatar7.png',
    'assets/images/avatars/avatar8.png',
    'assets/images/avatars/avatar9.png',
    'assets/images/avatars/avatar10.png',
  ];

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultBorderRadius = 8.0;
  static const double smallBorderRadius = 4.0;
  static const double largeBorderRadius = 12.0;

  static const double posterAspectRatio = 2 / 3;
  static const double backdropAspectRatio = 16 / 9;
  static const double profileAvatarSize = 80.0;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Cache Settings
  static const int imageCacheMaxAge = 7; // days
  static const int videoCacheMaxAge = 1; // days
  static const int apiCacheMaxAge = 30; // minutes

  // Error Messages
  static const String networkErrorMessage = 'Please check your internet connection and try again.';
  static const String serverErrorMessage = 'Something went wrong. Please try again later.';
  static const String contentNotFoundMessage = 'Content not found.';
  static const String downloadFailedMessage = 'Download failed. Please try again.';
  static const String playbackErrorMessage = 'Unable to play this content right now.';
  static const String profileLimitMessage = 'You can only have up to 5 profiles per account.';
  static const String downloadLimitMessage = 'You can only download up to 100 titles per profile.';

  // Success Messages
  static const String downloadStartedMessage = 'Download started';
  static const String downloadCompletedMessage = 'Download completed';
  static const String addedToListMessage = 'Added to My List';
  static const String removedFromListMessage = 'Removed from My List';
  static const String profileCreatedMessage = 'Profile created successfully';
  static const String profileUpdatedMessage = 'Profile updated successfully';

  // Feature Flags
  static const bool enableGames = true;
  static const bool enableDownloads = true;
  static const bool enableProfiles = true;
  static const bool enableSearch = true;
  static const bool enableNotifications = true;
  static const bool enableCasting = true;
  static const bool enableOfflineMode = true;

  // Regex Patterns
  static const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';

  // Local Storage Keys
  static const String userProfileKey = 'user_profile';
  static const String selectedProfileKey = 'selected_profile';
  static const String downloadsKey = 'downloads';
  static const String watchHistoryKey = 'watch_history';
  static const String myListKey = 'my_list';
  static const String settingsKey = 'settings';
  static const String cacheKey = 'cache';

  // Deep Link Schemes
  static const String deepLinkScheme = 'netflix';
  static const String webLinkDomain = 'netflix.com';

  // Social Sharing
  static const String shareTextTemplate = 'Check out {title} on Netflix!';
  static const String shareUrlTemplate = 'https://netflix.com/title/{id}';

  // Analytics Events
  static const String eventAppLaunch = 'app_launch';
  static const String eventContentView = 'content_view';
  static const String eventContentPlay = 'content_play';
  static const String eventContentPause = 'content_pause';
  static const String eventContentComplete = 'content_complete';
  static const String eventDownloadStart = 'download_start';
  static const String eventDownloadComplete = 'download_complete';
  static const String eventSearch = 'search';
  static const String eventProfileSwitch = 'profile_switch';
  static const String eventGameLaunch = 'game_launch';
}

class AppStrings {
  // Navigation
  static const String home = 'Home';
  static const String games = 'Games';
  static const String newAndHot = 'New & Hot';
  static const String myNetflix = 'My Netflix';

  // Actions
  static const String play = 'Play';
  static const String download = 'Download';
  static const String myList = 'My List';
  static const String share = 'Share';
  static const String info = 'Info';
  static const String remove = 'Remove';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String retry = 'Retry';
  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String sort = 'Sort';

  // Content
  static const String episodes = 'Episodes';
  static const String trailers = 'Trailers & More';
  static const String moreLikeThis = 'More Like This';
  static const String details = 'Details';
  static const String cast = 'Cast';
  static const String director = 'Director';
  static const String genre = 'Genre';
  static const String year = 'Year';
  static const String duration = 'Duration';
  static const String rating = 'Rating';
  static const String season = 'Season';
  static const String episode = 'Episode';

  // Profile
  static const String profiles = 'Profiles';
  static const String addProfile = 'Add Profile';
  static const String editProfile = 'Edit Profile';
  static const String deleteProfile = 'Delete Profile';
  static const String kidsProfile = 'Kids Profile';
  static const String manageProfiles = 'Manage Profiles';

  // Downloads
  static const String downloads = 'Downloads';
  static const String downloading = 'Downloading';
  static const String downloaded = 'Downloaded';
  static const String downloadFailed = 'Download Failed';
  static const String smartDownloads = 'Smart Downloads';
  static const String downloadSettings = 'Download Settings';

  // Settings
  static const String settings = 'Settings';
  static const String account = 'Account';
  static const String notifications = 'Notifications';
  static const String privacy = 'Privacy';
  static const String help = 'Help';
  static const String about = 'About';
  static const String signOut = 'Sign Out';

  // Games
  static const String install = 'Install';
  static const String installing = 'Installing';
  static const String installed = 'Installed';
  static const String update = 'Update';
  static const String open = 'Open';

  // Search
  static const String searchHint = 'Search for shows, movies, games...';
  static const String recentSearches = 'Recent Searches';
  static const String popularSearches = 'Popular Searches';
  static const String noResults = 'No results found';
  static const String searchResults = 'Search Results';

  // Error States
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String contentUnavailable = 'Content unavailable';
  static const String tryAgainLater = 'Please try again later';

  // Empty States
  static const String noDownloads = 'No downloads yet';
  static const String emptyMyList = 'Your list is empty';
  static const String noContinueWatching = 'Nothing to continue watching';
  static const String noGamesInstalled = 'No games installed';
}