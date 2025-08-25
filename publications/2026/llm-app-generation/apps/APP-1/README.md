# Audible Flutter App

A comprehensive Flutter mobile application that replicates the core functionality of the Audible app, providing users with access to audiobooks, podcasts, and exclusive audio content.

## Features

### Core Functionality
- **Vast Audio Library**: Access to audiobooks, podcasts, and exclusive original content
- **Personal Library Management**: Organize and manage your purchased and downloaded content
- **Advanced Audio Player**: Full-featured player with speed control, bookmarks, and sleep timer
- **Offline Listening**: Download content for offline playback
- **Cross-Platform Sync**: Seamless experience across devices
- **Collections & Organization**: Create custom collections and manage wishlists

### User Interface
- **Bottom Navigation**: Easy access to Home, Library, Discover, and Profile sections
- **Modern Design**: Clean, intuitive interface following Material Design principles
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Layout**: Optimized for various screen sizes

### Screens & Features

#### Home Screen
- Continue Listening section with progress tracking
- Featured content carousel
- Personalized recommendations
- New releases and bestsellers
- Genre-based browsing

#### Library Screen
- Tabbed interface (All, Audiobooks, Podcasts, Collections)
- Progress tracking for all content
- Search and filter functionality
- Download management

#### Discover Screen
- Browse by categories and genres
- Bestseller charts
- New releases
- Plus catalog highlights
- Advanced search functionality

#### Player Screen
- Full-screen player interface
- Chapter navigation
- Playback speed control
- Sleep timer
- Bookmark management
- Car mode for safe driving

## Technical Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   ├── utils/             # Utility functions
│   ├── services/          # Core services
│   └── providers/         # Global state providers
├── features/
│   ├── home/              # Home screen and widgets
│   ├── library/           # Library management
│   ├── discover/          # Content discovery
│   ├── player/            # Audio player functionality
│   ├── auth/              # Authentication
│   └── onboarding/        # User onboarding
├── shared/
│   ├── models/            # Data models
│   ├── widgets/           # Reusable UI components
│   └── services/          # Shared services
└── main.dart              # App entry point
```

### Key Technologies
- **Flutter**: Cross-platform mobile development framework
- **Riverpod**: State management solution
- **Hive**: Local database for offline storage
- **Just Audio**: Audio playback functionality
- **Go Router**: Navigation management
- **JSON Serialization**: Data serialization and deserialization

### Data Models
- **Audiobook**: Complete audiobook information with chapters
- **Podcast**: Podcast series with episodes
- **User**: User profile and preferences
- **PlaybackState**: Current playback status and controls
- **Collection**: User-created content collections

## Setup Instructions

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd audible_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code files**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For development (debug mode)
   flutter run
   
   # For web
   flutter run -d chrome
   
   # For specific device
   flutter run -d <device-id>
   ```

### Development Setup

1. **Code Generation**
   - Run `flutter pub run build_runner build` after modifying model files
   - Use `flutter pub run build_runner watch` for automatic generation during development

2. **State Management**
   - The app uses Riverpod for state management
   - Providers are organized by feature and functionality
   - Global state is managed in the core providers

3. **Theming**
   - Light and dark themes are defined in `lib/core/theme/app_theme.dart`
   - Custom colors and styles follow the Audible brand guidelines
   - Themes automatically switch based on system preferences

## Configuration

### App Constants
Key configuration values are defined in `lib/core/constants/app_constants.dart`:
- API endpoints and timeouts
- Storage keys for local data
- Playback settings and options
- UI constants and animations

### Dependencies
The app uses the following key dependencies:
- `flutter_riverpod`: State management
- `hive_flutter`: Local storage
- `just_audio`: Audio playback
- `go_router`: Navigation
- `cached_network_image`: Image caching
- `json_annotation`: JSON serialization

## Building for Production

### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter test integration_test/
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## Features Implementation Status

### ✅ Completed
- [x] Project structure and architecture
- [x] Core data models and serialization
- [x] Bottom navigation and routing
- [x] Home screen with content discovery
- [x] Library management with tabs
- [x] Discover screen with categories
- [x] Audio player interface (UI)
- [x] App theming and styling

### 🚧 In Progress
- [ ] Authentication and user management
- [ ] Audio playback functionality
- [ ] Offline download management
- [ ] Real API integration
- [ ] Push notifications

### 📋 Planned
- [ ] Advanced search functionality
- [ ] Social features and sharing
- [ ] Accessibility improvements
- [ ] Performance optimizations
- [ ] Analytics integration

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Code Style

- Follow Flutter/Dart style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent file organization
- Use proper error handling

## Performance Considerations

- Images are cached using `cached_network_image`
- Local data is stored efficiently with Hive
- State management is optimized with Riverpod
- Lazy loading is implemented for large lists
- Memory usage is monitored and optimized

## Security

- User data is stored securely using Hive encryption
- API calls use proper authentication tokens
- Sensitive information is not logged in production
- Network requests use HTTPS only

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review existing issues and discussions

## Acknowledgments

- Flutter team for the amazing framework
- Riverpod for excellent state management
- Just Audio for reliable audio playback
- The open-source community for various packages used
