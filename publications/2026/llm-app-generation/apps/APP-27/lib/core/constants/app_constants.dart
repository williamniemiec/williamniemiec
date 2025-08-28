class AppConstants {
  // App Information
  static const String appName = 'CapCut';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Professional Video Editor';
  
  // File Extensions
  static const List<String> supportedVideoFormats = [
    'mp4',
    'mov',
    'avi',
    'mkv',
    'wmv',
    'flv',
    '3gp',
    'webm',
  ];
  
  static const List<String> supportedAudioFormats = [
    'mp3',
    'aac',
    'wav',
    'flac',
    'ogg',
    'm4a',
    'wma',
  ];
  
  static const List<String> supportedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
  ];
  
  // Video Settings
  static const List<String> aspectRatios = [
    '16:9',
    '9:16',
    '1:1',
    '4:3',
    '3:4',
    '21:9',
  ];
  
  static const List<int> frameRates = [
    24,
    25,
    30,
    50,
    60,
  ];
  
  static const List<String> resolutions = [
    '480p',
    '720p',
    '1080p',
    '1440p',
    '4K',
  ];
  
  static const Map<String, Map<String, int>> resolutionDimensions = {
    '480p': {'width': 854, 'height': 480},
    '720p': {'width': 1280, 'height': 720},
    '1080p': {'width': 1920, 'height': 1080},
    '1440p': {'width': 2560, 'height': 1440},
    '4K': {'width': 3840, 'height': 2160},
  };
  
  // Timeline Settings
  static const double timelineHeight = 120.0;
  static const double trackHeight = 40.0;
  static const double timelineRulerHeight = 30.0;
  static const double pixelsPerSecond = 50.0;
  static const double minZoomLevel = 0.1;
  static const double maxZoomLevel = 10.0;
  
  // Editor Settings
  static const int maxUndoSteps = 50;
  static const int thumbnailCount = 10;
  static const int previewQuality = 720;
  static const double defaultVolume = 1.0;
  static const double defaultSpeed = 1.0;
  
  // Export Settings
  static const List<String> exportFormats = [
    'MP4',
    'MOV',
    'AVI',
    'MKV',
  ];
  
  static const List<int> exportBitrates = [
    1000,
    2000,
    5000,
    10000,
    20000,
  ];
  
  // Template Categories
  static const List<String> templateCategories = [
    'Trending',
    'Social',
    'Business',
    'Travel',
    'Food',
    'Fashion',
    'Fitness',
    'Education',
    'Entertainment',
    'Music',
    'Gaming',
    'Lifestyle',
  ];
  
  // Effects Categories
  static const List<String> effectCategories = [
    'Basic',
    'Glitch',
    'Vintage',
    'Cinematic',
    'Beauty',
    'Artistic',
    'Transition',
    'Color',
    'Blur',
    'Distortion',
  ];
  
  // Audio Effects
  static const List<String> audioEffects = [
    'Fade In',
    'Fade Out',
    'Echo',
    'Reverb',
    'Bass Boost',
    'Treble Boost',
    'Normalize',
    'Noise Reduction',
  ];
  
  // Text Animations
  static const List<String> textAnimations = [
    'None',
    'Fade In',
    'Slide In Left',
    'Slide In Right',
    'Slide In Top',
    'Slide In Bottom',
    'Scale In',
    'Rotate In',
    'Bounce In',
    'Typewriter',
  ];
  
  // Transition Types
  static const List<String> transitionTypes = [
    'Cut',
    'Fade',
    'Dissolve',
    'Wipe Left',
    'Wipe Right',
    'Wipe Up',
    'Wipe Down',
    'Slide Left',
    'Slide Right',
    'Zoom In',
    'Zoom Out',
    'Spin',
  ];
  
  // Filter Types
  static const List<String> filterTypes = [
    'None',
    'Brightness',
    'Contrast',
    'Saturation',
    'Hue',
    'Blur',
    'Sharpen',
    'Vintage',
    'Black & White',
    'Sepia',
    'Vignette',
    'Film Grain',
  ];
  
  // Speed Options
  static const List<double> speedOptions = [
    0.1,
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    2.0,
    3.0,
    4.0,
    5.0,
    10.0,
  ];
  
  // Font Families
  static const List<String> fontFamilies = [
    'Roboto',
    'Arial',
    'Helvetica',
    'Times New Roman',
    'Georgia',
    'Verdana',
    'Comic Sans MS',
    'Impact',
    'Trebuchet MS',
    'Courier New',
  ];
  
  // Color Presets
  static const List<int> colorPresets = [
    0xFFFFFFFF, // White
    0xFF000000, // Black
    0xFFFF0000, // Red
    0xFF00FF00, // Green
    0xFF0000FF, // Blue
    0xFFFFFF00, // Yellow
    0xFFFF00FF, // Magenta
    0xFF00FFFF, // Cyan
    0xFFFF8000, // Orange
    0xFF8000FF, // Purple
    0xFF80FF00, // Lime
    0xFF0080FF, // Sky Blue
  ];
  
  // Storage Paths
  static const String projectsFolder = 'projects';
  static const String exportsFolder = 'exports';
  static const String templatesFolder = 'templates';
  static const String thumbnailsFolder = 'thumbnails';
  static const String tempFolder = 'temp';
  
  // API Endpoints (for future use)
  static const String baseApiUrl = 'https://api.capcut.com/v1';
  static const String templatesEndpoint = '/templates';
  static const String effectsEndpoint = '/effects';
  static const String musicEndpoint = '/music';
  static const String fontsEndpoint = '/fonts';
  
  // Limits
  static const int maxProjectDuration = 3600; // 1 hour in seconds
  static const int maxClipsPerProject = 100;
  static const int maxAudioTracksPerProject = 10;
  static const int maxTextOverlaysPerProject = 50;
  static const int maxEffectsPerProject = 50;
  static const int maxFileSize = 1024 * 1024 * 1024; // 1GB
  
  // Performance Settings
  static const int previewFrameRate = 30;
  static const int thumbnailSize = 200;
  static const int maxCacheSize = 500 * 1024 * 1024; // 500MB
  static const int backgroundProcessingThreads = 2;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Keyboard Shortcuts
  static const Map<String, String> keyboardShortcuts = {
    'Space': 'Play/Pause',
    'Ctrl+Z': 'Undo',
    'Ctrl+Y': 'Redo',
    'Ctrl+S': 'Save',
    'Ctrl+N': 'New Project',
    'Ctrl+O': 'Open Project',
    'Ctrl+E': 'Export',
    'Delete': 'Delete Selected',
    'Ctrl+C': 'Copy',
    'Ctrl+V': 'Paste',
    'Ctrl+X': 'Cut',
    'Ctrl+A': 'Select All',
    '+': 'Zoom In',
    '-': 'Zoom Out',
    'Home': 'Go to Start',
    'End': 'Go to End',
  };
  
  // Error Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorFileNotFound = 'File not found.';
  static const String errorUnsupportedFormat = 'Unsupported file format.';
  static const String errorInsufficientStorage = 'Insufficient storage space.';
  static const String errorExportFailed = 'Export failed. Please try again.';
  static const String errorProjectCorrupted = 'Project file is corrupted.';
  static const String errorNetworkConnection = 'Network connection error.';
  
  // Success Messages
  static const String successProjectSaved = 'Project saved successfully.';
  static const String successProjectExported = 'Project exported successfully.';
  static const String successProjectCreated = 'Project created successfully.';
  static const String successProjectDeleted = 'Project deleted successfully.';
  static const String successEffectApplied = 'Effect applied successfully.';
}