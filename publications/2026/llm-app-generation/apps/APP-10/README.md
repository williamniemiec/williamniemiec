# DramaBox - Short-Form Drama Streaming App

DramaBox is a Flutter mobile application designed for streaming short-form, serialized dramatic content optimized for mobile viewing. The app provides a TikTok-like vertical scrolling experience for bite-sized drama episodes.

## 🎯 App Purpose

DramaBox caters to modern viewers' preference for quick, engaging, and emotionally charged entertainment that can be consumed on the go. The app offers:

- **Short-Form Content**: Episodes lasting 1-3 minutes each
- **Vertical Video Format**: Optimized for mobile viewing (9:16 aspect ratio)
- **Serialized Dramas**: Addictive, fast-paced storytelling
- **Exclusive Content**: Platform-exclusive original dramas
- **Monetization**: Freemium model with coins and subscriptions

## 🏗️ Architecture

The app follows a **feature-based architecture** with clean separation of concerns:

```
lib/
├── core/                    # Core app functionality
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theming and styling
│   ├── utils/             # Utility functions
│   └── services/          # Core services
├── features/              # Feature modules
│   ├── home/             # Home screen with vertical feed
│   ├── search/           # Search and discovery
│   ├── library/          # User's personal library
│   ├── profile/          # User profile and settings
│   ├── drama_detail/     # Drama details screen
│   ├── video_player/     # Video playback functionality
│   └── [feature]/
│       ├── screens/      # UI screens
│       ├── widgets/      # Reusable widgets
│       └── providers/    # State management
└── shared/               # Shared components
    ├── models/          # Data models
    ├── widgets/         # Common widgets
    └── services/        # Shared services
```

## 📱 Features Implemented

### ✅ Core Features
- **Navigation**: Bottom tab navigation with 4 main sections
- **Home Screen**: Vertical scrolling feed (TikTok-style)
- **Search Screen**: Genre browsing and content discovery
- **Library Screen**: Personal collection management
- **Profile Screen**: User account and settings

### ✅ Data Models
- **Drama**: Complete drama series information
- **Episode**: Individual episode details
- **User**: User profile and preferences
- **Subscription**: Premium subscription management

### ✅ UI/UX
- **Dark Theme**: Netflix-inspired dark design
- **Responsive Design**: Optimized for mobile devices
- **Smooth Animations**: Engaging user interactions
- **Modern UI**: Material Design 3 components

## 🎨 Design System

### Color Palette
- **Primary**: Netflix Red (`#E50914`)
- **Background**: Pure Black (`#000000`)
- **Surface**: Dark Gray (`#1A1A1A`)
- **Card**: Medium Gray (`#2D2D2D`)
- **Accent Gold**: Coin color (`#FFD700`)

### Typography
- **Font**: System default (Roboto/SF Pro)
- **Hierarchy**: 6 text sizes with proper contrast
- **Weight**: Regular to Bold variations

## 📊 Data Models

### Drama Model
```dart
class Drama {
  final String id;
  final String title;
  final String description;
  final List<Episode> episodes;
  final int freeEpisodes;
  final List<String> genres;
  final double rating;
  // ... additional properties
}
```

### Episode Model
```dart
class Episode {
  final String id;
  final int episodeNumber;
  final String title;
  final String videoUrl;
  final bool isFree;
  final int coinCost;
  // ... additional properties
}
```

### User Model
```dart
class User {
  final String id;
  final String email;
  final int coinBalance;
  final bool isPremiumSubscriber;
  final List<String> favoritesDramas;
  // ... additional properties
}
```

## 💰 Monetization Strategy

### Freemium Model
- **Free Episodes**: First 3 episodes of each drama
- **Paid Content**: Subsequent episodes require coins or subscription

### Coin System
- **Earn Coins**: Daily check-ins, watching ads
- **Spend Coins**: Unlock individual episodes
- **Purchase Packages**: Various coin bundles available

### Subscription Plans
- **Weekly**: $4.99 - Basic premium access
- **Monthly**: $14.99 - Full premium features
- **Yearly**: $149.99 - Best value with 50% savings

## 🛠️ Technical Stack

### Framework & Language
- **Flutter**: 3.8.1+
- **Dart**: Latest stable version

### Key Dependencies
```yaml
dependencies:
  # Navigation
  go_router: ^14.2.7
  
  # Video Playback
  video_player: ^2.8.6
  chewie: ^1.8.0
  
  # State Management
  provider: ^6.1.2
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Networking
  dio: ^5.4.3+1
  
  # UI Components
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  
  # Monetization
  in_app_purchase: ^3.1.13
  google_mobile_ads: ^5.0.0
```

### Storage
- **Hive**: Local database for offline data
- **Shared Preferences**: User settings and preferences

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Chrome (for web testing)

### Installation
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd dramabox_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   # For Chrome (web)
   flutter run -d chrome
   
   # For Android
   flutter run -d android
   
   # For iOS
   flutter run -d ios
   ```

## 📱 Screens Overview

### 1. Home Screen (`/home`)
- **Vertical Feed**: TikTok-style drama discovery
- **Auto-play**: Seamless episode transitions
- **Interaction**: Like, save, share functionality
- **Coin Display**: Current user balance

### 2. Search Screen (`/search`)
- **Genre Browsing**: Visual genre categories
- **Trending Content**: Popular dramas
- **Search Functionality**: Find specific content
- **Recent Searches**: Quick access to previous searches

### 3. Library Screen (`/library`)
- **Continue Watching**: Resume interrupted content
- **Favorites**: Liked dramas collection
- **Watch Later**: Saved for later viewing
- **Progress Tracking**: Visual progress indicators

### 4. Profile Screen (`/profile`)
- **User Info**: Profile picture and details
- **Coin Balance**: Current coins with top-up option
- **Statistics**: Watch time and episode count
- **Settings**: Account and app preferences
- **Subscription**: Premium plan management

## 🔧 Configuration

### App Constants
Key configuration values are centralized in [`AppConstants`](lib/core/constants/app_constants.dart):

```dart
class AppConstants {
  // Monetization
  static const int dailyCheckInReward = 5;
  static const int maxFreeEpisodesPerDrama = 3;
  
  // Video Settings
  static const int minEpisodeDuration = 30; // seconds
  static const int maxEpisodeDuration = 300; // 5 minutes
  
  // UI Configuration
  static const double cardAspectRatio = 16 / 9;
  static const int itemsPerPage = 20;
}
```

### Theme Configuration
The app uses a comprehensive theme system defined in [`AppTheme`](lib/core/theme/app_theme.dart):

- **Dark Theme**: Primary theme optimized for video content
- **Light Theme**: Alternative theme for accessibility
- **Color System**: Consistent color palette throughout
- **Typography**: Scalable text system

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Test Structure
- **Unit Tests**: Model and utility testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end user flows

## 📈 Performance Considerations

### Optimization Strategies
- **Lazy Loading**: Content loaded on demand
- **Image Caching**: Efficient image management
- **Memory Management**: Proper disposal of resources
- **Network Optimization**: Efficient API calls

### Video Performance
- **Adaptive Streaming**: Quality based on connection
- **Preloading**: Next episode preparation
- **Compression**: Optimized video formats

## 🔒 Security & Privacy

### Data Protection
- **Local Encryption**: Sensitive data protection
- **Secure Storage**: User credentials safety
- **Privacy Compliance**: GDPR/CCPA adherence

### Content Security
- **DRM Protection**: Premium content security
- **API Security**: Authenticated requests
- **User Verification**: Account validation

## 🚧 Future Enhancements

### Planned Features
- [ ] **Drama Detail Screen**: Comprehensive series information
- [ ] **Video Player**: Full-featured playback experience
- [ ] **Offline Downloads**: Content for offline viewing
- [ ] **Social Features**: Comments and sharing
- [ ] **Push Notifications**: New episode alerts
- [ ] **Multi-language Support**: Subtitles and dubbing
- [ ] **Chromecast Support**: TV streaming capability

### Technical Improvements
- [ ] **State Management**: Advanced state solutions
- [ ] **Performance**: Further optimization
- [ ] **Testing**: Comprehensive test coverage
- [ ] **CI/CD**: Automated deployment pipeline

## 📞 Support & Contact

### Development Team
- **Project**: DramaBox Mobile App
- **Framework**: Flutter
- **Version**: 1.0.0
- **Last Updated**: 2025

### Resources
- **Flutter Documentation**: https://docs.flutter.dev/
- **Material Design**: https://m3.material.io/
- **Hive Database**: https://docs.hivedb.dev/

## 📄 License

This project is developed as a demonstration of Flutter mobile app development capabilities, showcasing modern app architecture and design patterns.

---

**DramaBox** - *Bringing short-form drama to your fingertips* 🎭📱
