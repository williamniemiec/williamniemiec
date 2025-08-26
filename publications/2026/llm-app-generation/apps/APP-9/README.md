# Netflix Mobile App Clone

A complete Netflix mobile app clone built with Flutter, featuring a modern UI design, content streaming capabilities, offline downloads, games, and user profile management.

## 🎯 Features

### Core Features
- **🏠 Home Screen**: Personalized content discovery with horizontal carousels
- **🎮 Games**: Netflix Games integration with downloadable mobile games
- **🔥 New & Hot**: Coming soon content and trending shows/movies
- **👤 My Netflix**: Personal profile management, downloads, and viewing history
- **🔍 Search**: Advanced search functionality for content discovery
- **📱 Responsive Design**: Optimized for mobile devices with Netflix's signature dark theme

### Content Features
- **🎬 Content Streaming**: High-quality video streaming with adaptive bitrate
- **⬇️ Offline Downloads**: Download content for offline viewing
- **📺 Multiple Content Types**: Movies, TV shows, documentaries, anime, and originals
- **🎭 Personalized Recommendations**: AI-driven content suggestions
- **📋 My List**: Personal watchlist management
- **⏯️ Continue Watching**: Resume playback from where you left off

### User Experience
- **👥 Multiple Profiles**: Up to 5 profiles per account with personalized experiences
- **👶 Kids Profiles**: Safe, curated content for children
- **🌐 Multi-language Support**: Content available in multiple languages with subtitles
- **📱 Cross-platform**: Seamless experience across devices
- **🎨 Netflix UI/UX**: Authentic Netflix design and user experience

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and strings
│   ├── theme/             # App theme and styling
│   ├── utils/             # Utility functions
│   └── services/          # Core services
├── features/
│   ├── home/              # Home screen and widgets
│   ├── games/             # Games section
│   ├── new_hot/           # New & Hot content
│   ├── my_netflix/        # User profile and settings
│   ├── player/            # Video player
│   ├── search/            # Search functionality
│   └── profile/           # Profile management
├── shared/
│   ├── models/            # Data models
│   ├── widgets/           # Reusable widgets
│   └── services/          # Shared services
└── main.dart              # App entry point
```

### Key Models
- **User**: User account and subscription information
- **Profile**: Individual user profiles with preferences
- **Content**: Movies, TV shows, and other media content
- **Episode**: Individual episodes for TV series
- **Game**: Netflix Games with installation status
- **Download**: Offline content management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.1.0)
- Dart SDK (>=3.1.0)
- Android Studio / VS Code
- Chrome (for web testing)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd netflix_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Chrome (web)
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

### Development Setup

1. **Enable web support** (if not already enabled)
   ```bash
   flutter config --enable-web
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Build for production**
   ```bash
   # Web
   flutter build web
   
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## 📱 Screens Overview

### 1. Home Screen
- **Featured Content**: Large hero banner with play/add to list actions
- **Content Carousels**: Multiple rows of content organized by categories
- **Netflix App Bar**: Logo, category filters, search, and cast buttons
- **Personalized Rows**: "Continue Watching", "Because you watched", "My List"

### 2. Games Screen
- **Game Grid**: 2-column grid layout of available games
- **Category Filter**: Filter games by genre (Action, Puzzle, Strategy, etc.)
- **Game Cards**: Show game icon, title, rating, size, and install status
- **Install/Play Actions**: Download games or launch installed ones

### 3. New & Hot Screen
- **Coming Soon Tab**: Upcoming releases with reminder notifications
- **Everyone's Watching Tab**: Top 10 trending content
- **Release Calendar**: Visual calendar of upcoming content
- **Trailer Integration**: Auto-playing previews and trailers

### 4. My Netflix Screen
- **Profile Management**: Switch between profiles, manage settings
- **Downloads**: Offline content management and storage info
- **My List**: Personal watchlist with easy content management
- **Viewing History**: Complete watch history with resume options
- **Account Settings**: Subscription, notifications, and app preferences

## 🎨 Design System

### Color Palette
- **Primary**: Netflix Red (#E50914)
- **Background**: Netflix Black (#000000)
- **Surface**: Dark Gray (#141414)
- **Text**: White (#FFFFFF) and Light Gray (#F3F3F3)

### Typography
- **Display**: Bold headings for hero content
- **Headline**: Section titles and important text
- **Body**: Content descriptions and general text
- **Caption**: Metadata like ratings, years, genres

### Components
- **Content Cards**: Poster-style cards with hover effects
- **Carousels**: Horizontal scrolling content lists
- **Action Buttons**: Play, Download, Add to List, Info
- **Navigation**: Bottom tab bar with 4 main sections

## 🔧 Technical Implementation

### State Management
- **Provider Pattern**: Used for app-wide state management
- **Local State**: StatefulWidget for component-specific state
- **Future Integration**: Ready for advanced state management (Riverpod, Bloc)

### Networking
- **HTTP Client**: Dio for API communication
- **Image Caching**: Cached Network Image for optimized loading
- **Error Handling**: Comprehensive error states and retry mechanisms

### Storage
- **Local Storage**: SharedPreferences for user settings
- **Offline Content**: Hive for download management
- **Cache Management**: Automatic cache cleanup and optimization

### Performance
- **Lazy Loading**: Efficient content loading with pagination
- **Image Optimization**: Multiple image sizes and caching
- **Memory Management**: Proper disposal of resources

## 🧪 Testing

### Test Structure
```
test/
├── unit/              # Unit tests for models and services
├── widget/            # Widget tests for UI components
└── integration/       # End-to-end integration tests
```

### Running Tests
```bash
# All tests
flutter test

# Specific test file
flutter test test/widget/home_screen_test.dart

# Coverage report
flutter test --coverage
```

## 📦 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `provider`: State management
- `go_router`: Navigation and routing
- `cached_network_image`: Image caching
- `video_player`: Video playback
- `chewie`: Video player UI

### UI Dependencies
- `shimmer`: Loading animations
- `carousel_slider`: Content carousels
- `font_awesome_flutter`: Icons

### Storage Dependencies
- `shared_preferences`: Simple key-value storage
- `hive`: Local database
- `path_provider`: File system access

### Network Dependencies
- `http`: Basic HTTP client
- `dio`: Advanced HTTP client

## 🚀 Deployment

### Web Deployment
```bash
flutter build web --release
# Deploy the build/web folder to your hosting service
```

### Mobile App Stores
```bash
# Android Play Store
flutter build appbundle --release

# iOS App Store
flutter build ios --release
```

## 🔮 Future Enhancements

### Planned Features
- [ ] **Video Player**: Full-featured video player with controls
- [ ] **Content Details**: Detailed content information screens
- [ ] **Advanced Search**: Filters, voice search, and suggestions
- [ ] **Download Management**: Smart downloads and storage optimization
- [ ] **Profile Customization**: Avatar selection and preferences
- [ ] **Social Features**: Sharing and recommendations
- [ ] **Chromecast Support**: Cast to TV devices
- [ ] **Offline Mode**: Full offline experience

### Technical Improvements
- [ ] **Advanced State Management**: Riverpod or Bloc implementation
- [ ] **API Integration**: Real Netflix-like API integration
- [ ] **Performance Optimization**: Advanced caching and preloading
- [ ] **Accessibility**: Screen reader and keyboard navigation support
- [ ] **Internationalization**: Multi-language support
- [ ] **Analytics**: User behavior tracking and insights

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter/Dart style guidelines
- Write tests for new features
- Update documentation for significant changes
- Use meaningful commit messages

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Netflix**: For the inspiration and design reference
- **Flutter Team**: For the amazing framework
- **Community**: For the open-source packages and resources

## 📞 Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review existing issues and discussions

---

**Note**: This is a clone/educational project and is not affiliated with Netflix, Inc. All Netflix trademarks and content references are used for educational purposes only.
