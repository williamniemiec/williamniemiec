# Spotify Clone - Flutter Mobile App

A comprehensive Spotify-like music streaming application built with Flutter, featuring a modern dark theme, audio playback, playlist management, and social features.

## Features

### 🎵 Core Audio Streaming
- **Vast Content Library**: Access to music, albums, podcasts, and audiobooks
- **Multi-Format Support**: Seamlessly integrates different audio content types
- **High-Quality Audio**: Streaming with quality options
- **Audio Controls**: Play, pause, skip, shuffle, repeat functionality

### 🎯 Personalization & Discovery
- **Algorithmic Playlists**: Discover Weekly, Release Radar, Daily Mixes
- **Made For You Hub**: Personalized playlists and recommendations
- **Advanced Search**: Powerful search with filters by genre, mood, and categories
- **Browse Categories**: Organized content discovery

### 📚 Library & Playlist Management
- **Your Library**: Personal organized space for all saved content
- **Liked Songs**: Automatic playlist for hearted tracks
- **Playlist Creation**: Create unlimited personal playlists
- **Collaborative Playlists**: Shared playlists with multiple users
- **Playlist Folders**: Organize playlists efficiently

### 👥 Social & Interactive Features
- **Friend Activity**: See what friends are listening to
- **Artist Following**: Follow creators for updates
- **Sharing**: Share tracks, albums, and playlists

### 💎 Premium Features
- **Ad-Free Listening**: Uninterrupted playback
- **Offline Downloads**: Listen without internet connection
- **On-Demand Playback**: Play any song anytime
- **Unlimited Skips**: Skip tracks without restrictions

## Screenshots

*Note: Add screenshots of your app here*

## Architecture

The app follows a clean architecture pattern with the following structure:

```
lib/
├── core/
│   ├── constants/          # App constants and configurations
│   ├── theme/             # App theming and styling
│   └── utils/             # Utility functions
├── features/
│   ├── auth/              # Authentication feature
│   ├── home/              # Home screen and discovery
│   ├── search/            # Search functionality
│   ├── library/           # User library management
│   ├── player/            # Audio player controls
│   └── profile/           # User profile management
├── shared/
│   ├── models/            # Data models
│   ├── services/          # Business logic services
│   └── widgets/           # Reusable UI components
└── main.dart              # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd spotify_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Enable developer options** on your device
2. **Connect your device** via USB or use an emulator
3. **Verify device connection**
   ```bash
   flutter devices
   ```

## Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `riverpod`: Advanced state management
- `hive`: Local storage
- `shared_preferences`: Simple key-value storage

### UI & Navigation
- `google_fonts`: Custom fonts
- `flutter_svg`: SVG support
- `cached_network_image`: Image caching
- `shimmer`: Loading animations

### Audio & Media
- `just_audio`: Audio playback
- `audio_service`: Background audio
- `audio_session`: Audio session management

### Network & API
- `http`: HTTP requests
- `dio`: Advanced HTTP client
- `connectivity_plus`: Network connectivity

### Utilities
- `uuid`: Unique identifiers
- `intl`: Internationalization
- `permission_handler`: Device permissions
- `share_plus`: Content sharing
- `url_launcher`: External URLs

## Configuration

### Audio Setup

The app uses `just_audio` for audio playback. For production use, you'll need to:

1. **Configure audio session** in `lib/shared/services/audio_service.dart`
2. **Set up proper audio URLs** in your data models
3. **Handle audio permissions** for different platforms

### API Integration

To connect with a real music API:

1. **Update base URL** in `lib/core/constants/app_constants.dart`
2. **Implement authentication** in `lib/features/auth/providers/auth_provider.dart`
3. **Replace mock data** with real API calls in providers

### Platform-Specific Setup

#### Android
- Add internet permission in `android/app/src/main/AndroidManifest.xml`
- Configure audio focus and media session

#### iOS
- Add audio background mode in `ios/Runner/Info.plist`
- Configure audio session category

## State Management

The app uses Provider pattern for state management:

- **AudioService**: Manages audio playback state
- **AuthProvider**: Handles user authentication
- **HomeProvider**: Manages home screen data
- **SearchProvider**: Handles search functionality
- **LibraryProvider**: Manages user library
- **PlayerProvider**: Controls player UI state

## Theming

The app features a dark theme inspired by Spotify's design:

- **Primary Color**: Spotify Green (#1DB954)
- **Background**: Dark (#191414)
- **Surface**: Dark Grey (#121212)
- **Typography**: Inter font family

Customize colors in `lib/core/theme/app_theme.dart`.

## Testing

Run tests with:

```bash
flutter test
```

For widget tests:
```bash
flutter test test/widget_test.dart
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Performance Optimization

- **Image Caching**: Uses `cached_network_image` for efficient image loading
- **Lazy Loading**: Implements lazy loading for large lists
- **State Management**: Efficient state updates with Provider
- **Memory Management**: Proper disposal of controllers and streams

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by Spotify's mobile app design
- Flutter community for excellent packages
- Material Design guidelines

## Support

For support, email support@example.com or create an issue in the repository.

---

**Note**: This is a demo application for educational purposes. It does not stream real music content and is not affiliated with Spotify.
