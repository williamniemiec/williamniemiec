# YouTube Music App - Flutter

A comprehensive YouTube Music streaming application built with Flutter, featuring a modern dark theme UI, music discovery, personalized playlists, and seamless audio/video playback switching.

## 🎵 Features

### Core Music & Video Streaming
- **Vast Content Catalog**: Access to millions of songs, albums, and music videos
- **Integrated Video Content**: Seamless access to music videos, live performances, covers, and remixes
- **Song/Video Switching**: Unique feature allowing users to switch between audio-only and video modes with a single tap
- **Real-Time Lyrics**: Display of synchronized, time-stamped lyrics (placeholder implementation)

### Personalization & Discovery
- **Personalized Home Feed**: Dynamic home screen with custom playlists and mixes tailored to user preferences
- **Smart Search**: Powerful search engine with real-time results for songs, artists, albums, and playlists
- **Explore Tab**: Dedicated section for discovering new music, including new releases, charts, and browsing by moods/genres

### Library & Playlist Management
- **Personal Library**: Central hub for users to save favorite songs, albums, artists, and playlists
- **Playlist Creation**: Users can create and manage their own playlists
- **Quick Access**: Easy access to Liked Music, Downloaded content, and Recently Played

### Premium Features (UI Implementation)
- **Ad-Free Experience**: Clean interface without advertisement placeholders
- **Background Play**: Designed for continuous playback when app is backgrounded
- **Downloads for Offline**: UI for downloading songs and playlists for offline listening
- **Audio-Only Mode**: Toggle between audio and video modes to save data

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart      # App-wide constants
│   │   └── app_colors.dart         # Color palette and theme colors
│   ├── theme/
│   │   └── app_theme.dart          # Material Design theme configuration
│   ├── utils/                      # Utility functions
│   ├── services/                   # Core services
│   └── providers/                  # Global providers
├── features/
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart    # Personalized home feed
│   ├── explore/
│   │   └── screens/
│   │       └── explore_screen.dart # Music discovery and charts
│   ├── search/
│   │   └── screens/
│   │       └── search_screen.dart  # Search functionality
│   ├── library/
│   │   └── screens/
│   │       └── library_screen.dart # User's music library
│   ├── player/
│   │   └── screens/
│   │       └── player_screen.dart  # Full-screen music player
│   └── auth/                       # Authentication (placeholder)
├── shared/
│   ├── models/
│   │   ├── song.dart              # Song data model
│   │   ├── artist.dart            # Artist data model
│   │   ├── playlist.dart          # Playlist data model
│   │   ├── album.dart             # Album data model
│   │   └── user.dart              # User data model
│   ├── widgets/                   # Reusable UI components
│   └── services/                  # Shared services
└── main_navigation.dart           # Bottom tab navigation
```

### State Management
- **Riverpod**: Used for state management across the application
- **Hive**: Local database for caching and offline storage
- **Provider Pattern**: Clean separation of business logic and UI

### Data Models
All models are built with Hive integration for local storage:
- **Song**: Complete song information with metadata
- **Artist**: Artist profiles with follower counts and verification status
- **Playlist**: User and system playlists with collaboration features
- **Album**: Album information with track listings
- **User**: User profiles with premium status and preferences

## 🎨 Design System

### Color Palette
- **Primary**: YouTube Red (#FF0000) for branding and active states
- **Background**: Deep black (#121212) for immersive dark experience
- **Surface**: Dark gray (#1E1E1E) for cards and elevated content
- **Text**: White (#FFFFFF) primary, gray variants for hierarchy
- **Accent**: Green (#1DB954) for liked content, various colors for genres/moods

### Typography
- **Google Fonts**: Roboto font family for consistency
- **Hierarchy**: Clear text sizing from display to body text
- **Contrast**: High contrast ratios for accessibility

### Components
- **Bottom Navigation**: Custom animated tab bar with active state indicators
- **Cards**: Rounded corners with subtle shadows and gradients
- **Buttons**: Material Design 3 button styles with proper touch targets
- **Search**: Prominent search bar with real-time results

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Chrome (for web development)
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd youtube_music_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run -d chrome
   ```

### Development Setup

1. **Enable web support** (if not already enabled)
   ```bash
   flutter config --enable-web
   ```

2. **Run with hot reload**
   ```bash
   flutter run -d chrome --web-port=8080
   ```

## 📱 Screens & Navigation

### Home Screen
- **Greeting**: Time-based greeting (Good morning/afternoon/evening)
- **Quick Picks**: Grid of frequently accessed playlists and features
- **Personalized Sections**: Recently played, made for you, new releases, trending
- **Horizontal Scrolling**: Smooth carousel navigation for content discovery

### Explore Screen
- **Tabbed Interface**: New releases, Charts, Moods & genres
- **New Releases**: Grid layout for albums and singles
- **Charts**: Top songs and artists with ranking
- **Categories**: Color-coded genre and mood selection

### Search Screen
- **Real-time Search**: Instant results as user types
- **Search History**: Recent searches with clear functionality
- **Browse Categories**: Genre and mood tiles for discovery
- **Result Types**: Songs, artists, albums, and playlists clearly differentiated

### Library Screen
- **Tabbed Organization**: Recently played, Playlists, Artists, Albums
- **Quick Access**: Liked Music, Downloaded, History with colored icons
- **Create Playlist**: Prominent button for playlist creation
- **Empty States**: Helpful guidance when sections are empty

### Player Screen
- **Full-Screen Experience**: Immersive player with gradient background
- **Audio/Video Toggle**: Seamless switching between modes
- **Animated Album Art**: Rotating animation during playback
- **Progress Control**: Scrubbing with time display
- **Action Bar**: Like, dislike, add to playlist, share, download

## 🔧 Technical Implementation

### Key Features Implemented

1. **Navigation System**
   - Bottom tab navigation with IndexedStack for state preservation
   - Animated tab indicators and smooth transitions
   - Proper back navigation handling

2. **Search Functionality**
   - Real-time search with debouncing
   - Search history management
   - Category-based browsing
   - Mock search results with proper typing

3. **Player Interface**
   - Audio/video mode switching
   - Playback controls with state management
   - Progress tracking and seeking
   - Shuffle and repeat modes

4. **Data Management**
   - Hive local database integration
   - Type-safe model definitions
   - Efficient caching strategies

5. **UI/UX Excellence**
   - Material Design 3 principles
   - Dark theme optimization
   - Responsive layouts
   - Smooth animations and transitions

### Mock Data
The application uses comprehensive mock data to demonstrate functionality:
- Sample songs with metadata
- Artist profiles with follower counts
- Playlist collections
- Search results across all content types

## 🎯 User Interaction Flows

### Music Discovery Flow
1. User opens app → Home screen with personalized content
2. Taps "Discover Mix" → Playlist opens with songs
3. Plays song → Full-screen player with audio/video toggle
4. Likes song → Added to Liked Music automatically
5. Adds to playlist → Playlist selection modal

### Search Flow
1. User taps Search tab → Search screen with categories
2. Types query → Real-time results appear
3. Selects result → Navigates to appropriate detail screen
4. Search saved to history → Available for quick access

### Library Management Flow
1. User accesses Library → Organized content tabs
2. Creates new playlist → Playlist creation interface
3. Adds songs → Search and selection interface
4. Downloads for offline → Premium feature indication

## 🔮 Future Enhancements

### Planned Features
- **Real Audio Playback**: Integration with just_audio package
- **Video Streaming**: Video player implementation
- **Authentication**: Firebase Auth integration
- **Cloud Sync**: User data synchronization
- **Offline Mode**: Complete offline functionality
- **Social Features**: Playlist sharing and collaboration
- **Recommendations**: AI-powered music suggestions

### Technical Improvements
- **Performance**: Lazy loading and virtualization
- **Accessibility**: Screen reader support and keyboard navigation
- **Testing**: Unit, widget, and integration tests
- **CI/CD**: Automated testing and deployment
- **Analytics**: User behavior tracking
- **Error Handling**: Comprehensive error management

## 📄 License

This project is created for educational and demonstration purposes. It showcases Flutter development best practices and modern mobile app architecture.

## 🤝 Contributing

This is a demonstration project. For educational purposes, you can:
1. Fork the repository
2. Create feature branches
3. Implement additional functionality
4. Submit pull requests with improvements

## 📞 Support

For questions about the implementation or Flutter development:
- Check Flutter documentation: https://docs.flutter.dev/
- Review Riverpod documentation: https://riverpod.dev/
- Explore Material Design 3: https://m3.material.io/

---

**Built with ❤️ using Flutter**

*This YouTube Music clone demonstrates modern Flutter development practices, state management with Riverpod, local data persistence with Hive, and Material Design 3 principles.*
