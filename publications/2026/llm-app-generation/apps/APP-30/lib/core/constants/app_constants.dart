class AppConstants {
  // App Information
  static const String appName = 'Google Docs';
  static const String appVersion = '1.0.0';
  
  // Colors
  static const int primaryColorValue = 0xFF1976D2;
  static const int accentColorValue = 0xFF03DAC6;
  
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 8.0;
  
  // Animation Durations
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 300;
  static const int longAnimationDuration = 500;
  
  // Document Settings
  static const int maxDocumentNameLength = 100;
  static const int autoSaveInterval = 5; // seconds
  static const int maxVersionHistory = 100;
  
  // File Extensions
  static const List<String> supportedExportFormats = [
    'docx',
    'pdf',
    'txt',
    'odt',
    'html'
  ];
  
  // Storage Keys
  static const String documentsKey = 'documents';
  static const String templatesKey = 'templates';
  static const String userPreferencesKey = 'user_preferences';
  static const String offlineDocumentsKey = 'offline_documents';
  
  // API Endpoints (for future Google Drive integration)
  static const String baseApiUrl = 'https://www.googleapis.com/drive/v3';
  static const String authScope = 'https://www.googleapis.com/auth/drive.file';
  
  // Template Categories
  static const List<String> templateCategories = [
    'Resume',
    'Letter',
    'Report',
    'Proposal',
    'Invoice',
    'Meeting Notes',
    'Project Plan',
    'Blank Document'
  ];
  
  // Sharing Permissions
  static const String viewerPermission = 'viewer';
  static const String commenterPermission = 'commenter';
  static const String editorPermission = 'editor';
  
  // Document Status
  static const String draftStatus = 'draft';
  static const String publishedStatus = 'published';
  static const String archivedStatus = 'archived';
}