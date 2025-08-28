# Google App Clone

A comprehensive Google app clone built with Flutter, featuring search functionality, personalized Discover feed, Google Lens integration, and modern UI design.

## Features

### 🔍 Multi-Modal Search
- **Text Search**: Standard keyword-based web search with autocomplete suggestions
- **Voice Search**: Hands-free searching with speech recognition
- **Google Lens**: Visual search using camera to identify objects, translate text, and find products
- **Hum to Search**: Identify songs by humming (simulated)

### 📰 Personalized Content
- **Discover Feed**: AI-curated articles based on user interests
- **Customizable Topics**: Follow/unfollow topics to personalize content
- **Real-time Updates**: Fresh content with pull-to-refresh

### 🤖 AI-Powered Features
- **AI Overviews**: Comprehensive summaries for search queries
- **Smart Suggestions**: Context-aware search suggestions
- **Content Personalization**: Machine learning-driven content recommendations

### 🔒 Privacy & Security
- **Incognito Mode**: Private browsing without saving activity
- **Search History Management**: View and clear search history
- **Quick Delete**: Remove last 15 minutes of search activity
- **SafeSearch**: Filter explicit content

### 🎨 Modern UI/UX
- **Material Design 3**: Latest design system implementation
- **Dark/Light Theme**: System-aware theme switching
- **Responsive Layout**: Optimized for different screen sizes
- **Smooth Animations**: Fluid transitions and interactions

## Screenshots

### Home Screen
- Google logo with colorful letters
- Prominent search bar with voice and lens shortcuts
- Personalized Discover feed with article cards
- Incognito mode indicator

### Search Interface
- Real-time search suggestions
- Search history with quick access
- Filter tabs (All, Images, Videos, News, Shopping)
- AI Overview cards for comprehensive answers

### Google Lens
- Live camera preview
- Mode selector (Search, Translate, Text, Homework, Shopping)
- Real-time object detection with bounding boxes
- Results overlay with confidence scores

### Profile & Settings
- User account management
- Privacy controls and preferences
- Theme selection
- Search history management

## Technical Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # Theme and styling
│   ├── providers/         # State management
│   └── utils/             # Utility functions
├── features/
│   ├── home/              # Home screen and widgets
│   ├── search/            # Search functionality
│   ├── lens/              # Google Lens integration
│   ├── profile/           # User profile and settings
│   └── discover/          # Content discovery
├── shared/
│   ├── models/            # Data models
│   ├── services/          # API and business logic
│   └── widgets/           # Reusable UI components
└── main.dart              # App entry point
```

### Key Technologies
- **Flutter**: Cross-platform mobile development
- **Provider**: State management
- **Camera**: Camera integration for Lens
- **HTTP/Dio**: API communication
- **SharedPreferences**: Local data storage
- **Cached Network Image**: Efficient image loading
- **Permission Handler**: Runtime permissions

### State Management
The app uses Provider pattern for state management with a centralized `AppProvider` that manages:
- User authentication and preferences
- Search state and history
- Discover feed content
- Theme and app settings

## Setup Instructions

### Prerequisites
- Flutter SDK (3.1.0 or higher)
- Dart SDK (3.1.0 or higher)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd google_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure permissions**
   
   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.RECORD_AUDIO" />
   <uses-permission android:name="android.permission.INTERNET" />
   ```

   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access for Google Lens functionality</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>This app needs microphone access for voice search</string>
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable developer options**
   ```bash
   flutter config --enable-web  # For web development
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Build for production**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## Configuration

### API Integration
The app uses mock services for demonstration. To integrate with real APIs:

1. **Search API**: Update `SearchService` in `lib/shared/services/search_service.dart`
2. **Discover API**: Update `DiscoverService` in `lib/shared/services/discover_service.dart`
3. **User API**: Update `UserService` in `lib/shared/services/user_service.dart`

### Customization

#### Theme Customization
Modify colors and styling in `lib/core/theme/app_theme.dart`:
```dart
static const Color primaryBlue = Color(0xFF4285F4);
static const Color primaryRed = Color(0xFFEA4335);
// Add your custom colors
```

#### Feature Configuration
Update feature flags in `lib/core/constants/app_constants.dart`:
```dart
static const bool enableVoiceSearch = true;
static const bool enableLens = true;
// Configure features
```

## Usage Guide

### Basic Search
1. Tap the search bar on the home screen
2. Type your query or use voice search
3. View results with AI Overview
4. Filter by type (Images, Videos, News, etc.)

### Google Lens
1. Tap the camera icon in the search bar
2. Grant camera permissions
3. Select a mode (Search, Translate, Text, etc.)
4. Point camera at object and tap capture
5. View results with bounding boxes

### Discover Feed
1. Scroll through personalized articles on home screen
2. Tap articles to read full content
3. Use three-dot menu to customize feed
4. Follow/unfollow topics for personalization

### Privacy Controls
1. Access profile screen from home
2. Toggle incognito mode for private browsing
3. Manage search history
4. Configure privacy preferences

## Contributing

### Code Style
- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent file structure

### Pull Request Process
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Troubleshooting

### Common Issues

**Camera not working**
- Ensure camera permissions are granted
- Check device camera functionality
- Restart the app

**Search not loading**
- Check internet connection
- Verify API endpoints (if using real APIs)
- Clear app cache

**Theme not switching**
- Restart the app
- Check system theme settings
- Clear app preferences

### Performance Optimization
- Use `const` constructors where possible
- Implement lazy loading for large lists
- Optimize image loading with caching
- Use `ListView.builder` for dynamic content

## License

This project is created for educational and demonstration purposes. It showcases Flutter development capabilities and modern mobile app architecture.

## Acknowledgments

- Google for design inspiration
- Flutter team for the amazing framework
- Open source community for packages and resources

---

**Note**: This is a demonstration app and not affiliated with Google Inc. All Google trademarks and logos are property of Google Inc.
