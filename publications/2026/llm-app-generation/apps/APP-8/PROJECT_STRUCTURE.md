# Project Structure Documentation

This document provides a detailed overview of the Duolingo Clone project structure, explaining the purpose and organization of each directory and key files.

## 📁 Root Directory Structure

```
duolingo_clone/
├── android/                    # Android-specific configuration and build files
├── assets/                     # Static assets (images, audio, animations, fonts)
├── ios/                        # iOS-specific configuration and build files
├── lib/                        # Main Dart source code
├── linux/                     # Linux desktop configuration (future support)
├── macos/                     # macOS desktop configuration (future support)
├── test/                      # Test files and test utilities
├── web/                       # Web-specific configuration and assets
├── windows/                   # Windows desktop configuration (future support)
├── pubspec.yaml              # Project dependencies and configuration
├── README.md                 # Project documentation and setup guide
└── PROJECT_STRUCTURE.md      # This file - project structure documentation
```

## 📱 Main Source Code (`lib/`)

### Core Directory (`lib/core/`)
Contains fundamental, app-wide functionality that doesn't belong to specific features.

```
lib/core/
├── constants/
│   └── app_constants.dart     # App-wide constants, colors, sizes, strings
├── theme/
│   └── app_theme.dart         # Material Design theme configuration
├── utils/                     # Utility functions and helpers (future)
└── services/                  # Core services like API clients (future)
```

**Key Files:**
- [`app_constants.dart`](lib/core/constants/app_constants.dart): Centralized constants including colors, spacing, font sizes, gamification values, and configuration
- [`app_theme.dart`](lib/core/theme/app_theme.dart): Complete Material Design theme with light/dark mode support

### Features Directory (`lib/features/`)
Feature-based organization following clean architecture principles. Each feature is self-contained with its own screens, widgets, and business logic.

```
lib/features/
├── auth/                      # Authentication and user management
│   ├── providers/            # State management for auth
│   ├── screens/              # Login, signup, password reset screens
│   └── widgets/              # Auth-specific UI components
├── learn/                     # Main learning interface
│   ├── providers/            # Learning progress state management
│   ├── screens/              # Learn screen with learning path
│   └── widgets/              # Learning path, lesson nodes, progress bars
├── lesson/                    # Individual lesson experience
│   ├── providers/            # Lesson state and progress
│   ├── screens/              # Lesson interface and exercise screens
│   └── widgets/              # Exercise types, answer checking, feedback
├── leaderboards/             # League system and competitions
│   ├── providers/            # Leaderboard data and rankings
│   ├── screens/              # League standings and competition views
│   └── widgets/              # Leaderboard entries, league badges
├── practice/                 # Practice hub and review sessions
│   ├── providers/            # Practice session management
│   ├── screens/              # Practice hub and targeted exercises
│   └── widgets/              # Practice categories, review cards
├── profile/                  # User profile and statistics
│   ├── providers/            # User data and achievements
│   ├── screens/              # Profile view, settings, statistics
│   └── widgets/              # Profile cards, achievement badges
└── stories/                  # Interactive story content
    ├── providers/            # Story progress and state
    ├── screens/              # Story reader and interaction
    └── widgets/              # Story parts, character dialogue
```

**Current Implementation Status:**
- ✅ **learn/**: Fully implemented with learning path visualization
- 🔄 **lesson/**: Basic structure, exercises in development
- 📋 **auth/**: Planned for future implementation
- 📋 **leaderboards/**: Basic screen created, full implementation pending
- 📋 **practice/**: Basic screen created, full implementation pending
- 📋 **profile/**: Basic screen created, full implementation pending
- 📋 **stories/**: Basic screen created, full implementation pending

### Shared Directory (`lib/shared/`)
Reusable components, models, and services used across multiple features.

```
lib/shared/
├── models/                    # Data models and entities
│   ├── achievement.dart      # Achievement and badge system
│   ├── leaderboard.dart      # League and ranking system
│   ├── lesson.dart           # Lesson and exercise structures
│   ├── story.dart            # Interactive story content
│   └── user.dart             # User profile and progress data
├── services/                 # Shared services and utilities
│   ├── audio_service.dart    # Audio playback and TTS (future)
│   └── storage_service.dart  # Local data persistence (future)
└── widgets/                  # Reusable UI components
    └── custom_bottom_navigation_bar.dart  # App navigation bar
```

**Key Models:**
- [`User`](lib/shared/models/user.dart): Complete user profile with gamification data
- [`Lesson`](lib/shared/models/lesson.dart): Lesson structure with exercises and metadata
- [`Achievement`](lib/shared/models/achievement.dart): Badge system with progress tracking
- [`Story`](lib/shared/models/story.dart): Interactive narrative content
- [`Leaderboard`](lib/shared/models/leaderboard.dart): League system with rankings

### Application Entry Points
- [`main.dart`](lib/main.dart): Application entry point and root widget configuration
- [`app.dart`](lib/app.dart): Main navigation structure with bottom tab bar

## 🎨 Assets Directory (`assets/`)

```
assets/
├── animations/               # Lottie animations and motion graphics
├── audio/                   # Sound effects and pronunciation audio
├── fonts/                   # Custom fonts (Nunito family)
├── icons/                   # App icons and custom illustrations
└── images/                  # Static images and graphics
```

**Note:** Asset directories are created but currently empty. Assets will be added as features are implemented.

## 🧪 Testing (`test/`)

```
test/
├── unit/                    # Unit tests for business logic (future)
├── widget/                  # Widget tests for UI components (future)
├── integration/             # Integration tests (future)
└── widget_test.dart         # Basic widget test example
```

## 📋 Configuration Files

### `pubspec.yaml`
Project configuration including:
- **Dependencies**: Flutter packages and external libraries
- **Assets**: Asset declarations for images, fonts, audio
- **Metadata**: App name, version, description
- **Build Configuration**: Platform-specific settings

### Platform-Specific Directories
- **`android/`**: Android build configuration, permissions, app icons
- **`ios/`**: iOS build configuration, Info.plist, app icons
- **`web/`**: Web deployment configuration and assets
- **`linux/`, `macos/`, `windows/`**: Desktop platform configurations (future support)

## 🏗️ Architecture Patterns

### Feature-Based Organization
Each feature is organized as a self-contained module with:
- **Screens**: UI layer with page-level widgets
- **Widgets**: Feature-specific reusable components
- **Providers**: State management and business logic
- **Models**: Feature-specific data structures (when needed)

### Separation of Concerns
- **Core**: App-wide configuration and utilities
- **Features**: Business logic and feature-specific UI
- **Shared**: Reusable components and cross-cutting concerns

### State Management
- **Provider Pattern**: Used for state management across the app
- **Local State**: Widget-level state for simple UI interactions
- **Global State**: App-wide state for user data and preferences

## 🔄 Development Workflow

### Adding New Features
1. Create feature directory in `lib/features/`
2. Implement screens, widgets, and providers
3. Add models to `lib/shared/models/` if reusable
4. Update navigation in `app.dart`
5. Add tests in corresponding `test/` directories

### Adding New Models
1. Create model file in `lib/shared/models/`
2. Implement data class with JSON serialization
3. Add factory constructors and utility methods
4. Update related providers and services

### Adding Assets
1. Place assets in appropriate `assets/` subdirectory
2. Declare assets in `pubspec.yaml`
3. Reference assets using asset paths in code
4. Optimize assets for mobile performance

## 📚 Key Dependencies

### State Management
- **provider**: Primary state management solution
- **flutter/material**: UI framework and widgets

### Navigation
- **go_router**: Declarative routing (configured but not yet implemented)

### UI/UX
- **google_fonts**: Nunito font family
- **lottie**: Vector animations

### Audio/Media
- **audioplayers**: Audio playback for exercises
- **speech_to_text**: Speech recognition
- **flutter_tts**: Text-to-speech synthesis

### Storage
- **shared_preferences**: Simple key-value storage
- **sqflite**: Local SQLite database

### Utilities
- **uuid**: Unique identifier generation
- **intl**: Internationalization support

## 🚀 Getting Started with Development

1. **Understand the Architecture**: Review this document and the main README
2. **Explore Existing Code**: Start with `lib/features/learn/` for a complete example
3. **Follow Patterns**: Use existing features as templates for new development
4. **Test Early**: Write tests alongside feature development
5. **Document Changes**: Update documentation when adding new features

## 📖 Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)
- [Provider Package Documentation](https://pub.dev/packages/provider)

---

This structure is designed to be scalable, maintainable, and easy to understand for developers of all experience levels. Each component has a clear purpose and follows Flutter best practices.