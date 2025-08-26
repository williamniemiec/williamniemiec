# DramaBox Project Structure

This document outlines the complete project structure for the DramaBox Flutter application.

## 📁 Root Directory Structure

```
dramabox_app/
├── android/                    # Android-specific files
├── ios/                       # iOS-specific files
├── lib/                       # Main Dart source code
├── test/                      # Test files
├── web/                       # Web-specific files
├── assets/                    # App assets (images, fonts, etc.)
├── pubspec.yaml              # Project dependencies and metadata
├── README.md                 # Project documentation
└── PROJECT_STRUCTURE.md      # This file
```

## 📱 Main Source Code (`lib/`)

### Core Architecture
```
lib/
├── main.dart                 # App entry point
├── core/                     # Core app functionality
│   ├── constants/
│   │   └── app_constants.dart    # App-wide constants
│   ├── theme/
│   │   └── app_theme.dart        # App theming system
│   ├── utils/                    # Utility functions
│   └── services/                 # Core services
├── features/                     # Feature-based modules
└── shared/                       # Shared components
```

### Feature Modules (`lib/features/`)
Each feature follows a consistent structure:

```
features/
├── home/                     # Home screen with vertical feed
│   ├── screens/
│   │   └── home_screen.dart      # Main home screen
│   ├── widgets/                  # Home-specific widgets
│   └── providers/                # State management
├── search/                   # Search and discovery
│   ├── screens/
│   │   └── search_screen.dart    # Search interface
│   ├── widgets/                  # Search widgets
│   └── providers/                # Search state
├── library/                  # User's personal library
│   ├── screens/
│   │   └── library_screen.dart   # Library management
│   ├── widgets/                  # Library widgets
│   └── providers/                # Library state
├── profile/                  # User profile and settings
│   ├── screens/
│   │   └── profile_screen.dart   # Profile interface
│   ├── widgets/                  # Profile widgets
│   └── providers/                # Profile state
├── drama_detail/             # Drama details (planned)
│   ├── screens/
│   ├── widgets/
│   └── providers/
└── video_player/             # Video playback (planned)
    ├── screens/
    ├── widgets/
    └── providers/
```

### Shared Components (`lib/shared/`)
```
shared/
├── models/                   # Data models
│   ├── drama.dart               # Drama model with Hive adapter
│   ├── episode.dart             # Episode model with Hive adapter
│   ├── user.dart                # User model with Hive adapter
│   └── subscription.dart        # Subscription model with Hive adapter
├── widgets/                  # Reusable UI components
└── services/                 # Shared business logic
```

## 🎨 Assets Structure (`assets/`)

```
assets/
├── images/                   # App images and graphics
├── icons/                    # Custom icons
├── videos/                   # Sample video content
└── fonts/                    # Custom fonts (if any)
```

## 🧪 Testing Structure (`test/`)

```
test/
├── widget_test.dart          # Basic widget tests
├── unit/                     # Unit tests
│   ├── models/               # Model tests
│   └── services/             # Service tests
├── widget/                   # Widget tests
│   └── screens/              # Screen widget tests
└── integration/              # Integration tests
```

## 📦 Dependencies Overview

### Core Dependencies
- **flutter**: Framework
- **go_router**: Navigation and routing
- **hive_flutter**: Local database
- **provider**: State management

### UI & Media
- **video_player**: Video playback
- **chewie**: Video player UI
- **cached_network_image**: Image caching
- **shimmer**: Loading animations

### Networking & Storage
- **dio**: HTTP client
- **shared_preferences**: Simple storage
- **hive**: NoSQL database

### Monetization
- **in_app_purchase**: App store purchases
- **google_mobile_ads**: Advertisement integration

### Development
- **build_runner**: Code generation
- **hive_generator**: Hive adapter generation
- **flutter_lints**: Code quality

## 🏗️ Architecture Patterns

### Feature-Based Architecture
- Each feature is self-contained
- Clear separation of concerns
- Scalable and maintainable structure

### Layer Separation
```
Presentation Layer (Screens/Widgets)
        ↓
Business Logic Layer (Providers/Services)
        ↓
Data Layer (Models/Repositories)
```

### State Management
- **Provider**: Simple state management
- **Local State**: Widget-level state with StatefulWidget
- **Global State**: App-level state with Provider

## 📊 Data Flow

### Local Data Storage
```
Hive Database
├── Drama Box (dramas)
├── Episode Box (episodes)
├── User Box (user data)
├── Subscription Box (subscriptions)
└── Settings Box (app settings)
```

### Navigation Flow
```
Main App
├── Home (/home) - Default route
├── Search (/search)
├── Library (/library)
└── Profile (/profile)
```

## 🎯 Key Design Decisions

### 1. Feature-Based Structure
- **Why**: Scalability and maintainability
- **Benefit**: Easy to add new features without affecting existing code

### 2. Hive for Local Storage
- **Why**: Fast, lightweight NoSQL database
- **Benefit**: Offline capability and quick data access

### 3. Go Router for Navigation
- **Why**: Declarative routing with URL support
- **Benefit**: Better navigation management and web support

### 4. Dark Theme First
- **Why**: Video content consumption preference
- **Benefit**: Better user experience for media apps

### 5. Vertical Feed Design
- **Why**: Modern mobile UX (TikTok-style)
- **Benefit**: Engaging content discovery experience

## 🔧 Development Guidelines

### File Naming Conventions
- **Screens**: `*_screen.dart`
- **Widgets**: `*_widget.dart` or descriptive names
- **Models**: `*.dart` (singular noun)
- **Services**: `*_service.dart`
- **Providers**: `*_provider.dart`

### Code Organization
- **Imports**: External packages first, then internal imports
- **Classes**: One main class per file
- **Constants**: Centralized in `app_constants.dart`
- **Themes**: Centralized in `app_theme.dart`

### State Management Rules
- **Local State**: Use StatefulWidget for simple UI state
- **Feature State**: Use Provider for feature-specific state
- **Global State**: Use Provider for app-wide state

## 🚀 Build & Deployment

### Development Commands
```bash
# Install dependencies
flutter pub get

# Generate code (Hive adapters)
flutter packages pub run build_runner build

# Run app
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS

# Run tests
flutter test

# Build for production
flutter build apk      # Android APK
flutter build ios      # iOS
flutter build web      # Web
```

### Environment Setup
- **Flutter SDK**: 3.8.1+
- **Dart SDK**: Latest stable
- **IDE**: VS Code or Android Studio
- **Platforms**: Android, iOS, Web

## 📈 Performance Considerations

### Optimization Strategies
- **Lazy Loading**: Load content on demand
- **Image Caching**: Efficient image management
- **Widget Rebuilds**: Minimize unnecessary rebuilds
- **Memory Management**: Proper resource disposal

### Monitoring
- **Performance**: Flutter DevTools
- **Crashes**: Firebase Crashlytics (planned)
- **Analytics**: Firebase Analytics (planned)

## 🔮 Future Enhancements

### Planned Features
- Drama detail screens
- Video player implementation
- Offline download capability
- Social features (comments, sharing)
- Push notifications
- Multi-language support

### Technical Improvements
- Advanced state management (Riverpod/Bloc)
- Comprehensive testing suite
- CI/CD pipeline
- Performance monitoring
- Error tracking

---

This structure provides a solid foundation for a scalable, maintainable Flutter application following modern development practices and patterns.