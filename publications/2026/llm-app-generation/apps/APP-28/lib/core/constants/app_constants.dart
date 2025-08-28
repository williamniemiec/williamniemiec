class AppConstants {
  // App Information
  static const String appName = 'Google Photos';
  static const String appVersion = '1.0.0';
  
  // Navigation
  static const int photosTabIndex = 0;
  static const int searchTabIndex = 1;
  static const int libraryTabIndex = 2;
  
  // Grid Settings
  static const int defaultGridCrossAxisCount = 3;
  static const int maxGridCrossAxisCount = 5;
  static const int minGridCrossAxisCount = 2;
  static const double gridSpacing = 2.0;
  static const double gridAspectRatio = 1.0;
  
  // Photo Viewer
  static const double photoViewerMinScale = 0.5;
  static const double photoViewerMaxScale = 4.0;
  
  // Memories
  static const int memoriesCarouselHeight = 120;
  static const int maxMemoriesCount = 10;
  
  // Search
  static const int searchHistoryLimit = 20;
  static const int searchResultsLimit = 100;
  
  // Albums
  static const int maxAlbumNameLength = 50;
  static const int maxAlbumDescriptionLength = 200;
  
  // Sharing
  static const int maxSharedAlbumMembers = 100;
  
  // Storage
  static const String photosStorageKey = 'photos_storage';
  static const String albumsStorageKey = 'albums_storage';
  static const String settingsStorageKey = 'settings_storage';
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  
  // File Types
  static const List<String> supportedImageExtensions = [
    'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic', 'heif'
  ];
  
  static const List<String> supportedVideoExtensions = [
    'mp4', 'mov', 'avi', 'mkv', 'webm', '3gp', 'flv'
  ];
  
  // Error Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String networkErrorMessage = 'Please check your internet connection.';
  static const String permissionErrorMessage = 'Permission denied. Please grant the required permissions.';
  static const String storageErrorMessage = 'Not enough storage space available.';
  
  // Success Messages
  static const String photoSavedMessage = 'Photo saved successfully';
  static const String albumCreatedMessage = 'Album created successfully';
  static const String photoSharedMessage = 'Photo shared successfully';
  
  // Placeholder Texts
  static const String searchPlaceholder = 'Search your photos';
  static const String noPhotosMessage = 'No photos found';
  static const String noAlbumsMessage = 'No albums found';
  static const String noSearchResultsMessage = 'No results found';
  
  // Feature Flags
  static const bool enableCloudSync = true;
  static const bool enableFaceRecognition = true;
  static const bool enableLocationServices = true;
  static const bool enableAutoBackup = true;
  static const bool enableMagicEraser = true;
  static const bool enablePhotoUnblur = true;
  static const bool enablePortraitLight = true;
}

class AppRoutes {
  static const String home = '/';
  static const String photoViewer = '/photo-viewer';
  static const String photoEditor = '/photo-editor';
  static const String albumViewer = '/album-viewer';
  static const String albumEditor = '/album-editor';
  static const String search = '/search';
  static const String settings = '/settings';
  static const String sharing = '/sharing';
  static const String backup = '/backup';
}

class AppAssets {
  // Icons
  static const String icPhotos = 'assets/icons/ic_photos.png';
  static const String icSearch = 'assets/icons/ic_search.png';
  static const String icLibrary = 'assets/icons/ic_library.png';
  static const String icShare = 'assets/icons/ic_share.png';
  static const String icEdit = 'assets/icons/ic_edit.png';
  static const String icDelete = 'assets/icons/ic_delete.png';
  static const String icFavorite = 'assets/icons/ic_favorite.png';
  static const String icDownload = 'assets/icons/ic_download.png';
  static const String icInfo = 'assets/icons/ic_info.png';
  static const String icSettings = 'assets/icons/ic_settings.png';
  
  // Images
  static const String imgPlaceholder = 'assets/images/placeholder.png';
  static const String imgEmptyState = 'assets/images/empty_state.png';
  static const String imgLogo = 'assets/images/logo.png';
  
  // Sample Photos (for demo purposes)
  static const List<String> samplePhotos = [
    'assets/images/sample_1.jpg',
    'assets/images/sample_2.jpg',
    'assets/images/sample_3.jpg',
    'assets/images/sample_4.jpg',
    'assets/images/sample_5.jpg',
    'assets/images/sample_6.jpg',
    'assets/images/sample_7.jpg',
    'assets/images/sample_8.jpg',
    'assets/images/sample_9.jpg',
    'assets/images/sample_10.jpg',
  ];
}