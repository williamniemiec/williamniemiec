# ParentSquare - Project Structure

This document provides a detailed overview of the ParentSquare Flutter app's project structure and organization.

## Directory Structure

```
parent_square/
├── android/                    # Android-specific files
├── ios/                       # iOS-specific files
├── lib/                       # Main Dart source code
│   ├── main.dart             # App entry point
│   ├── core/                 # Core functionality
│   │   ├── constants/        # App constants and configuration
│   │   │   └── app_constants.dart
│   │   ├── theme/           # App theming and styling
│   │   │   └── app_theme.dart
│   │   ├── utils/           # Utility functions (future)
│   │   └── services/        # Core services (future)
│   ├── features/            # Feature-based modules
│   │   ├── home/           # Home feed functionality
│   │   │   ├── screens/    # Screen widgets
│   │   │   │   └── home_screen.dart
│   │   │   ├── widgets/    # Feature-specific widgets
│   │   │   │   ├── feed_filter.dart
│   │   │   │   └── post_card.dart
│   │   │   └── providers/  # State management (future)
│   │   ├── messages/       # Messaging system
│   │   │   ├── screens/
│   │   │   │   └── messages_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── conversation_tile.dart
│   │   │   └── providers/
│   │   ├── events/         # Calendar and events
│   │   │   ├── screens/
│   │   │   │   └── events_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── event_card.dart
│   │   │   └── providers/
│   │   ├── explore/        # Interactive features
│   │   │   ├── screens/
│   │   │   │   └── explore_screen.dart
│   │   │   ├── widgets/
│   │   │   │   └── explore_category_card.dart
│   │   │   └── providers/
│   │   └── more/           # Settings and profile
│   │       ├── screens/
│   │       │   └── more_screen.dart
│   │       ├── widgets/
│   │       └── providers/
│   └── shared/             # Shared components
│       ├── models/         # Data models
│       │   ├── user.dart
│       │   ├── post.dart
│       │   ├── message.dart
│       │   └── event.dart
│       ├── widgets/        # Reusable widgets (future)
│       └── services/       # Shared services (future)
├── test/                   # Unit and widget tests
├── assets/                 # Static assets
│   ├── images/            # Image files
│   ├── icons/             # Icon files
│   └── fonts/             # Font files
├── pubspec.yaml           # Project dependencies
├── README.md              # Main documentation
├── QUICK_START.md         # Quick start guide
└── PROJECT_STRUCTURE.md   # This file
```

## Core Architecture

### Feature-Based Organization

The app follows a feature-based architecture where each major functionality is organized into its own module:

- **home/**: Main feed with posts and announcements
- **messages/**: Direct and group messaging
- **events/**: Calendar and event management
- **explore/**: Interactive features (forms, sign-ups, polls)
- **more/**: User settings and profile management

### Layer Separation

Each feature module is organized into layers:

- **screens/**: UI screens and pages
- **widgets/**: Feature-specific reusable widgets
- **providers/**: State management (Riverpod providers)

## Key Files

### Entry Point
- [`lib/main.dart`](lib/main.dart): App initialization, routing, and main widget

### Core Configuration
- [`lib/core/constants/app_constants.dart`](lib/core/constants/app_constants.dart): App-wide constants, routes, and configuration
- [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart): Material Design theme configuration

### Data Models
- [`lib/shared/models/user.dart`](lib/shared/models/user.dart): User profile and authentication
- [`lib/shared/models/post.dart`](lib/shared/models/post.dart): Posts, announcements, and interactions
- [`lib/shared/models/message.dart`](lib/shared/models/message.dart): Messages and conversations
- [`lib/shared/models/event.dart`](lib/shared/models/event.dart): Calendar events and RSVPs

### Main Screens
- [`lib/features/home/screens/home_screen.dart`](lib/features/home/screens/home_screen.dart): Main feed interface
- [`lib/features/messages/screens/messages_screen.dart`](lib/features/messages/screens/messages_screen.dart): Message inbox
- [`lib/features/events/screens/events_screen.dart`](lib/features/events/screens/events_screen.dart): Calendar interface
- [`lib/features/explore/screens/explore_screen.dart`](lib/features/explore/screens/explore_screen.dart): Interactive features hub
- [`lib/features/more/screens/more_screen.dart`](lib/features/more/screens/more_screen.dart): Settings and profile

## Design Patterns

### State Management
- **Riverpod**: Used for state management across the app
- **Provider Pattern**: Centralized state management for each feature
- **Consumer Widgets**: Reactive UI updates based on state changes

### Navigation
- **GoRouter**: Declarative routing with type-safe navigation
- **Shell Routes**: Persistent bottom navigation wrapper
- **Deep Linking**: Support for URL-based navigation

### Data Flow
```
UI Layer (Screens/Widgets)
    ↕
State Layer (Providers)
    ↕
Service Layer (API/Local Storage)
    ↕
Data Layer (Models)
```

## Widget Hierarchy

### Main App Structure
```
ParentSquareApp
├── MaterialApp.router
└── MainNavigationWrapper
    ├── BottomNavigationBar
    └── Screen Content
        ├── HomeScreen
        ├── MessagesScreen
        ├── EventsScreen
        ├── ExploreScreen
        └── MoreScreen
```

### Feature Widget Structure
```
FeatureScreen
├── AppBar
├── Body Content
│   ├── Feature-specific widgets
│   ├── Shared widgets
│   └── Custom components
└── FloatingActionButton (if needed)
```

## Naming Conventions

### Files and Directories
- **snake_case**: For file and directory names
- **Feature prefix**: For feature-specific files (e.g., `home_screen.dart`)
- **Descriptive names**: Clear indication of purpose

### Classes and Variables
- **PascalCase**: For class names (e.g., `HomeScreen`)
- **camelCase**: For variable and method names (e.g., `currentFilter`)
- **SCREAMING_SNAKE_CASE**: For constants (e.g., `API_BASE_URL`)

### Widgets
- **Descriptive names**: Clear indication of widget purpose
- **Screen suffix**: For main screen widgets (e.g., `HomeScreen`)
- **Card suffix**: For card-style widgets (e.g., `PostCard`)

## Dependencies Organization

### Core Dependencies
```yaml
# Framework
flutter_riverpod: State management
go_router: Navigation

# Networking
dio: HTTP client
connectivity_plus: Network status

# Storage
hive_flutter: Local database
shared_preferences: Simple storage
```

### UI Dependencies
```yaml
# Calendar
table_calendar: Calendar widget

# Images
cached_network_image: Image caching
image_picker: Image selection

# Animations
shimmer: Loading animations
flutter_staggered_animations: List animations
```

### Platform Dependencies
```yaml
# Firebase
firebase_core: Firebase initialization
firebase_messaging: Push notifications

# Permissions
permission_handler: Runtime permissions

# Files
file_picker: File selection
path_provider: File system paths
```

## Testing Structure

### Test Organization
```
test/
├── unit/              # Unit tests
│   ├── models/       # Model tests
│   ├── services/     # Service tests
│   └── utils/        # Utility tests
├── widget/           # Widget tests
│   ├── screens/      # Screen tests
│   └── widgets/      # Widget tests
└── integration/      # Integration tests
```

### Test Naming
- **Feature prefix**: Tests prefixed with feature name
- **Descriptive names**: Clear test purpose
- **Test suffix**: All test files end with `_test.dart`

## Asset Organization

### Images
```
assets/images/
├── logos/            # App logos and branding
├── onboarding/       # Onboarding screens
├── illustrations/    # UI illustrations
└── backgrounds/      # Background images
```

### Icons
```
assets/icons/
├── navigation/       # Bottom navigation icons
├── actions/          # Action button icons
└── categories/       # Category icons
```

### Fonts
```
assets/fonts/
└── roboto/          # Primary font family
    ├── Roboto-Regular.ttf
    ├── Roboto-Medium.ttf
    └── Roboto-Bold.ttf
```

## Future Expansion

### Planned Modules
- **auth/**: Authentication and onboarding
- **notifications/**: Push notification management
- **settings/**: Advanced settings and preferences
- **offline/**: Offline data synchronization
- **analytics/**: Usage analytics and reporting

### Service Layer
- **api_service.dart**: HTTP API communication
- **storage_service.dart**: Local data persistence
- **notification_service.dart**: Push notification handling
- **sync_service.dart**: Data synchronization

### Utility Layer
- **date_utils.dart**: Date formatting and manipulation
- **validation_utils.dart**: Form validation helpers
- **network_utils.dart**: Network connectivity helpers
- **permission_utils.dart**: Permission handling

This structure provides a scalable foundation for the ParentSquare app, allowing for easy maintenance, testing, and future feature additions.