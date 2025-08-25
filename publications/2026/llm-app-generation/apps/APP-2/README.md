# Color by Number App

A relaxing and engaging digital coloring experience built with Flutter. This app provides a therapeutic color-by-number experience for users of all ages, helping to reduce stress and anxiety through creative expression.

## Features

### Core Functionality
- **Color-by-Number System**: Select numbered colors from a palette and tap corresponding areas on the image
- **Extensive Image Library**: Large collection of free coloring pages organized by categories
- **Multiple Categories**: 
  - Animals
  - Mandalas
  - Floral patterns
  - Nature scenes
  - Fantasy & Unicorns
  - Famous Paintings
  - Abstract
  - Geometric

### User Experience
- **No Special Skills Required**: Accessible to beginners and advanced users alike
- **Offline Accessibility**: Color pictures anytime, anywhere without internet connection
- **Progress Saving**: Automatic saving of progress on any picture
- **Zoom and Pan**: Pinch-to-zoom and pan gestures for precise coloring of small details
- **Hint System**: Magic wand tool to help locate hard-to-find numbered areas
- **Completion Animation**: Satisfying animation when finishing a picture

### Personal Gallery
- **My Works Section**: View in-progress and completed artworks
- **Progress Tracking**: Visual progress indicators on all images
- **Favorites System**: Mark and organize favorite coloring pages
- **Recently Viewed**: Quick access to recently opened pages

### Social Features
- **Social Sharing**: Share completed artworks on social media platforms
- **Save to Device**: Export finished creations to device gallery

## Technical Architecture

### Project Structure
```
lib/
├── constants/          # App constants and theme configuration
├── models/            # Data models (ColoringPage, UserProgress, etc.)
├── providers/         # State management with Provider pattern
├── screens/           # Main app screens
├── services/          # Database and storage services
└── widgets/           # Reusable UI components
```

### Key Technologies
- **Flutter**: Cross-platform mobile development framework
- **Provider**: State management solution
- **SQLite**: Local database for storing progress and artworks
- **SharedPreferences**: User settings and preferences storage
- **GoRouter**: Navigation and routing
- **Custom Painting**: Canvas rendering for coloring functionality

### Dependencies
- `provider`: State management
- `go_router`: Navigation
- `sqflite`: Local database
- `shared_preferences`: Local storage
- `share_plus`: Social sharing
- `flutter_staggered_animations`: UI animations
- `path_provider`: File system access
- `permission_handler`: Device permissions

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd color_by_number_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (if needed)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Desktop (Linux, macOS, Windows)

## App Screens

### 1. Home/Library Screen
- **Layout**: Scrollable grid view serving as the main gallery
- **Components**:
  - Top navigation with tabs for "Library" and "My Works"
  - Category filters (horizontal scrollable list)
  - Search functionality
  - Statistics banner showing progress overview
  - Recently viewed section
  - Main image grid with progress indicators

### 2. Coloring Screen
- **Layout**: Full-screen view focused on the artwork
- **Components**:
  - Interactive canvas with zoom/pan support
  - Color palette at the bottom with numbered colors
  - Top bar with page title and progress
  - Toolbar with hint, zoom reset, and share buttons
  - Progress bar showing completion percentage

### 3. My Works Screen
- **Layout**: Gallery view for personal artwork
- **Components**:
  - Tab bar with "In Progress" and "Completed" sections
  - Grid view of user's artwork
  - Progress indicators for in-progress items
  - Quick access to resume coloring or view completed works

## User Interaction Flow

1. **App Launch**: User opens app and sees the Home/Library screen
2. **Browse & Select**: User browses categories or searches for specific images
3. **Start Coloring**: Tap on an image to enter the coloring screen
4. **Color Process**:
   - Select a numbered color from the palette
   - Corresponding areas are highlighted on the canvas
   - Tap highlighted areas to fill with color
   - Use zoom/pan for detailed work
   - Use hint system if needed
5. **Progress Saving**: App automatically saves progress
6. **Completion**: When finished, completion animation plays
7. **Share & Save**: Option to share on social media or save to device

## Data Models

### ColoringPage
- Unique ID and metadata (title, category, difficulty)
- Image and thumbnail paths
- Color regions with coordinates and color codes
- Color palette with numbered colors and names

### UserProgress
- Page ID reference
- Colored regions tracking
- Progress percentage
- Last modified timestamp
- Completion status

### UserArtwork
- Completed artwork metadata
- Thumbnail and full image paths
- Completion timestamp
- Time spent coloring

## State Management

The app uses the Provider pattern for state management with two main providers:

### LibraryProvider
- Manages the coloring pages library
- Handles filtering, searching, and categorization
- Tracks user progress and favorites
- Provides statistics and recently viewed items

### ColoringProvider
- Manages the active coloring session
- Handles color selection and region coloring
- Controls canvas zoom and pan state
- Manages hint system and completion detection
- Handles progress saving and artwork creation

## Database Schema

### Tables
1. **coloring_pages**: Stores all available coloring pages
2. **user_progress**: Tracks user progress on each page
3. **user_artworks**: Stores completed artwork metadata

### Storage
- **SQLite**: Structured data (progress, artworks, pages)
- **SharedPreferences**: User settings and preferences
- **File System**: Image assets and completed artwork files

## Customization

### Adding New Categories
1. Add category name to `AppConstants.categories`
2. Create sample pages with the new category
3. Update category icons in `ColoringPageCard` widget

### Adding New Coloring Pages
1. Create `ColoringPage` model with regions and palette
2. Insert into database using `DatabaseService`
3. Add corresponding image assets

### Theming
- Modify colors in `AppConstants`
- Update `AppTheme.lightTheme` for comprehensive theming
- Add dark theme support by extending theme configuration

## Performance Considerations

- **Lazy Loading**: Images and data loaded on demand
- **Efficient Rendering**: Custom painting optimized for smooth performance
- **Memory Management**: Proper disposal of controllers and resources
- **Database Optimization**: Indexed queries and efficient data structures

## Future Enhancements

### Planned Features
- **Dark Mode**: Complete dark theme implementation
- **Cloud Sync**: Backup progress and artworks to cloud
- **Custom Images**: Allow users to import their own images
- **Advanced Tools**: Additional coloring tools and effects
- **Social Features**: Community sharing and challenges
- **Premium Content**: Subscription-based premium coloring pages
- **Accessibility**: Enhanced accessibility features
- **Offline Mode**: Complete offline functionality

### Technical Improvements
- **Performance**: Further optimization for large images
- **Testing**: Comprehensive unit and integration tests
- **CI/CD**: Automated testing and deployment pipeline
- **Analytics**: User behavior tracking and analytics
- **Crash Reporting**: Error tracking and reporting system

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@colorbyNumberapp.com or create an issue in the repository.

## Acknowledgments

- Flutter team for the amazing framework
- Community contributors and testers
- Design inspiration from various digital art applications
- Color palette selections from art therapy research

---

**Note**: This is a demonstration app showcasing Flutter development capabilities. The coloring canvas uses simplified region detection for demo purposes. In a production app, you would implement proper SVG path parsing and hit testing for accurate region detection.
