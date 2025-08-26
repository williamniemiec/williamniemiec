# Netflix App - Project Structure

This document provides a detailed overview of the Netflix mobile app project structure, explaining the organization of files, folders, and architectural decisions.

## 📁 Root Directory Structure

```
netflix_app/
├── android/                    # Android-specific configuration
├── ios/                       # iOS-specific configuration
├── lib/                       # Main Flutter application code
├── test/                      # Test files
├── web/                       # Web-specific configuration
├── assets/                    # Static assets (images, fonts, etc.)
├── pubspec.yaml              # Project dependencies and configuration
├── README.md                 # Project documentation
└── PROJECT_STRUCTURE.md      # This file
```

## 📱 Main Application Code (`lib/`)

### Core Architecture

```
lib/
├── main.dart                 # Application entry point
├── core/                     # Core application infrastructure
├── features/                 # Feature-based modules
└── shared/                   # Shared components and utilities
```

### Core Infrastructure (`lib/core/`)

```
core/
├── constants/
│   └── app_constants.dart    # App-wide constants and strings
├── theme/
│   └── app_theme.dart        # Netflix theme and styling
├── utils/                    # Utility functions and helpers
└── services/                 # Core services (API, storage, etc.)
```

**Purpose**: Contains foundational code that supports the entire application.

- **Constants**: Centralized configuration, strings, and static values
- **Theme**: Netflix's signature dark theme, colors, and typography
- **Utils**: Helper functions, extensions, and utilities
- **Services**: Core services like authentication, API clients, etc.

### Feature Modules (`lib/features/`)

Each feature follows a consistent structure with screens, widgets, and providers:

```
features/
├── home/                     # Home screen and content discovery
│   ├── screens/
│   │   └── home_screen.dart
│   ├── widgets/
│   │   ├── netflix_app_bar.dart
│   │   ├── featured_content.dart
│   │   └── content_carousel.dart
│   └── providers/            # State management for home
├── games/                    # Netflix Games section
│   ├── screens/
│   │   └── games_screen.dart
│   ├── widgets/
│   │   ├── game_card.dart
│   │   └── game_category_filter.dart
│   └── providers/
├── new_hot/                  # New & Hot content
│   ├── screens/
│   │   └── new_hot_screen.dart
│   ├── widgets/
│   └── providers/
├── my_netflix/               # User profile and personal content
│   ├── screens/
│   │   └── my_netflix_screen.dart
│   ├── widgets/
│   └── providers/
├── player/                   # Video player functionality
│   ├── screens/
│   ├── widgets/
│   └── providers/
├── search/                   # Search functionality
│   ├── screens/
│   ├── widgets/
│   └── providers/
└── profile/                  # Profile management
    ├── screens/
    ├── widgets/
    └── providers/
```

**Feature Structure Explanation**:
- **screens/**: Main screen widgets for the feature
- **widgets/**: Reusable UI components specific to the feature
- **providers/**: State management and business logic

### Shared Components (`lib/shared/`)

```
shared/
├── models/                   # Data models used across features
│   ├── user.dart            # User and Profile models
│   ├── content.dart         # Content and Episode models
│   ├── download.dart        # Download management models
│   ├── game.dart            # Game-related models
│   └── models.dart          # Barrel file for all models
├── widgets/                  # Reusable UI components
│   ├── loading_indicator.dart
│   ├── error_widget.dart
│   └── custom_buttons.dart
└── services/                 # Shared services
    ├── api_service.dart     # HTTP API communication
    ├── storage_service.dart  # Local storage management
    └── download_service.dart # Download functionality
```

## 🎯 Feature-Based Architecture

### Home Feature (`lib/features/home/`)

**Purpose**: Content discovery and main landing experience

**Key Components**:
- `HomeScreen`: Main screen with content carousels
- `NetflixAppBar`: Custom app bar with Netflix branding
- `FeaturedContent`: Hero banner with featured content
- `ContentCarousel`: Horizontal scrolling content lists

**Responsibilities**:
- Display personalized content recommendations
- Handle content browsing and discovery
- Manage featured content presentation
- Provide navigation to other sections

### Games Feature (`lib/features/games/`)

**Purpose**: Netflix Games integration and management

**Key Components**:
- `GamesScreen`: Main games browsing interface
- `GameCard`: Individual game display component
- `GameCategoryFilter`: Genre-based filtering

**Responsibilities**:
- Display available Netflix games
- Handle game installation and launching
- Provide category-based filtering
- Manage game download states

### New & Hot Feature (`lib/features/new_hot/`)

**Purpose**: Trending and upcoming content discovery

**Key Components**:
- `NewHotScreen`: Tabbed interface for new content
- Coming Soon tab with release calendar
- Everyone's Watching tab with trending content

**Responsibilities**:
- Show upcoming releases with dates
- Display trending content rankings
- Handle reminder notifications
- Provide content previews

### My Netflix Feature (`lib/features/my_netflix/`)

**Purpose**: Personal content management and user settings

**Key Components**:
- `MyNetflixScreen`: Personal dashboard
- Profile management interface
- Downloads and My List sections

**Responsibilities**:
- Manage user profiles and settings
- Display personal content (downloads, watchlist)
- Handle account-related actions
- Provide access to viewing history

## 📊 Data Models (`lib/shared/models/`)

### Core Models

1. **User Model** (`user.dart`)
   - User account information
   - Subscription details
   - Multiple profile support

2. **Content Model** (`content.dart`)
   - Movies, TV shows, documentaries
   - Metadata (cast, genres, ratings)
   - Episode information for series

3. **Download Model** (`download.dart`)
   - Offline content management
   - Download progress tracking
   - Storage and expiry information

4. **Game Model** (`game.dart`)
   - Netflix Games information
   - Installation status
   - Game metadata and ratings

### Model Relationships

```
User (1) ──── (N) Profile
Profile (1) ──── (N) Download
Profile (1) ──── (N) MyList
Content (1) ──── (N) Episode
Content (1) ──── (N) Download
```

## 🎨 Theming and Styling

### Theme Structure (`lib/core/theme/app_theme.dart`)

```dart
AppTheme
├── Color Palette
│   ├── Netflix Red (#E50914)
│   ├── Netflix Black (#000000)
│   ├── Dark Gray (#141414)
│   └── Light Gray (#564D4D)
├── Typography
│   ├── Display Styles (Hero content)
│   ├── Headline Styles (Section titles)
│   ├── Body Styles (Content text)
│   └── Caption Styles (Metadata)
└── Component Themes
    ├── AppBar Theme
    ├── Button Themes
    ├── Card Theme
    └── Input Decoration
```

### Custom Text Styles

```dart
NetflixTextStyles
├── heroTitle        # Large featured content titles
├── sectionTitle     # Content section headers
├── contentTitle     # Individual content titles
├── contentSubtitle  # Content metadata
└── buttonText       # Action button text
```

## 🔧 Configuration and Constants

### App Constants (`lib/core/constants/app_constants.dart`)

**Categories**:
- App Information (name, version, description)
- API Configuration (endpoints, image sizes)
- Content Categories (genres, types)
- UI Constants (padding, border radius, aspect ratios)
- Feature Flags (enable/disable features)
- Error and Success Messages
- Local Storage Keys

### String Resources (`AppStrings` class)

**Categories**:
- Navigation labels
- Action button text
- Content-related strings
- Error messages
- Settings and profile strings

## 🧪 Testing Structure (`test/`)

```
test/
├── unit/                     # Unit tests
│   ├── models/              # Model tests
│   ├── services/            # Service tests
│   └── utils/               # Utility tests
├── widget/                   # Widget tests
│   ├── screens/             # Screen widget tests
│   └── widgets/             # Component widget tests
└── integration/              # Integration tests
    └── app_test.dart        # End-to-end tests
```

## 📦 Dependencies and Packages

### Core Dependencies
- `flutter`: Flutter framework
- `provider`: State management
- `go_router`: Navigation and routing

### UI Dependencies
- `cached_network_image`: Optimized image loading
- `shimmer`: Loading animations
- `carousel_slider`: Content carousels

### Media Dependencies
- `video_player`: Video playback
- `chewie`: Video player UI controls

### Storage Dependencies
- `shared_preferences`: Simple key-value storage
- `hive`: Local database for complex data
- `path_provider`: File system access

### Network Dependencies
- `http`: Basic HTTP requests
- `dio`: Advanced HTTP client with interceptors

## 🚀 Build Configuration

### Platform-Specific Configuration

**Android** (`android/`):
- App icons and splash screens
- Permissions and manifest configuration
- Build variants and signing

**iOS** (`ios/`):
- App icons and launch screens
- Info.plist configuration
- Provisioning and certificates

**Web** (`web/`):
- Index.html template
- Web-specific assets
- PWA configuration

### Asset Management

**Images**: Product screenshots, logos, placeholder images
**Icons**: App icons, UI icons, platform-specific icons
**Fonts**: Custom Netflix fonts (when available)

## 🔄 State Management Strategy

### Current Implementation
- **Provider Pattern**: Simple and effective for current needs
- **Local State**: StatefulWidget for component-specific state
- **Global State**: Provider for app-wide state

### Future Considerations
- **Riverpod**: For more complex state management needs
- **Bloc**: For event-driven architecture
- **GetX**: For rapid development and dependency injection

## 📈 Scalability Considerations

### Code Organization
- Feature-based architecture for easy scaling
- Consistent folder structure across features
- Clear separation of concerns

### Performance
- Lazy loading for content lists
- Image caching and optimization
- Efficient state management

### Maintainability
- Comprehensive documentation
- Consistent coding standards
- Modular component design

## 🔮 Future Enhancements

### Planned Architecture Improvements
1. **Dependency Injection**: Service locator pattern
2. **Repository Pattern**: Data layer abstraction
3. **Clean Architecture**: Domain, data, and presentation layers
4. **Microservices**: Feature-based service architecture

### Technical Debt Management
- Regular code reviews and refactoring
- Performance monitoring and optimization
- Dependency updates and security patches
- Test coverage improvements

---

This project structure is designed to be scalable, maintainable, and follows Flutter best practices while maintaining the authentic Netflix user experience.