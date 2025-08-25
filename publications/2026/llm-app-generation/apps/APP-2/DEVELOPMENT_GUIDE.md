# Color by Number App - Development Guide

This guide provides detailed information for developers working on the Color by Number app.

## Project Overview

The Color by Number app is a Flutter-based mobile application that provides a relaxing digital coloring experience. The app follows a clean architecture pattern with clear separation of concerns.

## Architecture

### Folder Structure
```
lib/
├── constants/
│   └── app_constants.dart          # App-wide constants and theme
├── models/
│   ├── coloring_page.dart          # ColoringPage, ColorRegion, ColorPalette models
│   └── user_progress.dart          # UserProgress, UserArtwork models
├── providers/
│   ├── coloring_provider.dart      # State management for coloring session
│   └── library_provider.dart      # State management for library/gallery
├── screens/
│   ├── home_screen.dart           # Main library/gallery screen
│   ├── coloring_screen.dart       # Interactive coloring screen
│   └── my_works_screen.dart       # User's personal gallery
├── services/
│   ├── database_service.dart      # SQLite database operations
│   └── storage_service.dart       # SharedPreferences operations
├── widgets/
│   ├── coloring_canvas.dart       # Interactive coloring canvas
│   ├── coloring_page_card.dart    # Coloring page thumbnail card
│   ├── coloring_toolbar.dart      # Toolbar with coloring tools
│   ├── color_palette.dart         # Color selection palette
│   ├── category_filter.dart       # Category filter chips
│   └── search_bar_widget.dart     # Search input widget
└── main.dart                      # App entry point and routing
```

## State Management

The app uses the Provider pattern for state management with two main providers:

### LibraryProvider
**Purpose**: Manages the coloring pages library and user's collection

**Key Responsibilities**:
- Loading and filtering coloring pages
- Managing categories and search functionality
- Tracking user progress and favorites
- Providing statistics and recently viewed items

**Key Methods**:
- `initialize()`: Loads sample data and initializes the library
- `loadColoringPages()`: Fetches all coloring pages from database
- `selectCategory(String category)`: Filters pages by category
- `search(String query)`: Filters pages by search query
- `getInProgressPages()`: Returns pages with partial progress
- `getCompletedPages()`: Returns fully completed pages
- `toggleFavorite(String pageId)`: Adds/removes page from favorites

### ColoringProvider
**Purpose**: Manages the active coloring session

**Key Responsibilities**:
- Loading and managing the current coloring page
- Handling color selection and region coloring
- Managing canvas zoom and pan state
- Implementing hint system and completion detection
- Auto-saving progress and creating completed artworks

**Key Methods**:
- `loadColoringPage(String pageId)`: Loads a coloring page for editing
- `selectColor(int colorNumber)`: Selects a color and highlights regions
- `colorRegion(int regionNumber)`: Colors a specific region
- `showHint()`: Highlights an uncolored region for the selected color
- `updateZoom(double newZoom)`: Updates canvas zoom level
- `autoSave()`: Saves current progress to database

## Data Models

### ColoringPage
Represents a coloring page with all its metadata and structure.

```dart
class ColoringPage {
  final String id;              // Unique identifier
  final String title;           // Display name
  final String category;        // Category (Animals, Mandalas, etc.)
  final String imagePath;       // Path to full image
  final String thumbnailPath;   // Path to thumbnail
  final List<ColorRegion> regions;  // Colorable regions
  final List<ColorPalette> palette; // Available colors
  final int difficulty;         // 1-4 difficulty rating
  final bool isPremium;         // Premium content flag
  final DateTime createdAt;     // Creation timestamp
}
```

### ColorRegion
Defines a colorable area within a coloring page.

```dart
class ColorRegion {
  final int number;                    // Region number (matches palette)
  final List<List<int>> coordinates;   // Polygon coordinates
  final String colorCode;              // Hex color code
}
```

### UserProgress
Tracks user's progress on a specific coloring page.

```dart
class UserProgress {
  final String pageId;                 // Reference to coloring page
  final Map<int, bool> coloredRegions; // Region completion status
  final double progressPercentage;     // 0-100 completion percentage
  final DateTime lastModified;        // Last update timestamp
  final bool isCompleted;             // Full completion flag
}
```

## Database Schema

### Tables

#### coloring_pages
Stores all available coloring pages.
```sql
CREATE TABLE coloring_pages (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  image_path TEXT NOT NULL,
  thumbnail_path TEXT NOT NULL,
  regions TEXT NOT NULL,        -- JSON array of ColorRegion objects
  palette TEXT NOT NULL,        -- JSON array of ColorPalette objects
  difficulty INTEGER NOT NULL,
  is_premium INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);
```

#### user_progress
Tracks user progress on each coloring page.
```sql
CREATE TABLE user_progress (
  page_id TEXT PRIMARY KEY,
  colored_regions TEXT NOT NULL,    -- JSON map of region completion
  progress_percentage REAL NOT NULL,
  last_modified TEXT NOT NULL,
  is_completed INTEGER NOT NULL DEFAULT 0
);
```

#### user_artworks
Stores completed artwork metadata.
```sql
CREATE TABLE user_artworks (
  id TEXT PRIMARY KEY,
  page_id TEXT NOT NULL,
  title TEXT NOT NULL,
  thumbnail_path TEXT NOT NULL,
  completed_image_path TEXT NOT NULL,
  completed_at TEXT NOT NULL,
  time_spent_minutes INTEGER NOT NULL
);
```

## Key Components

### ColoringCanvas
The interactive canvas where users color the image.

**Features**:
- Custom painting with region detection
- Zoom and pan gestures using InteractiveViewer
- Region highlighting for selected colors
- Touch/tap handling for coloring regions

**Implementation Notes**:
- Uses CustomPainter for efficient rendering
- Simplified region detection for demo (grid-based)
- In production, would use SVG path parsing for accurate hit testing

### ColorPaletteWidget
Displays available colors and completion status.

**Features**:
- Horizontal scrollable list of color swatches
- Visual indicators for completed colors
- Color selection with highlighting
- Disabled state for unavailable colors

### ColoringPageCard
Thumbnail card displaying coloring page information.

**Features**:
- Thumbnail image with category icon fallback
- Progress indicator overlay
- Favorite toggle button
- Premium badge for paid content
- Completion status indicator

## Development Workflow

### Adding New Features

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-feature-name
   ```

2. **Update Models** (if needed)
   - Add new fields to existing models
   - Create new models in `lib/models/`
   - Run code generation: `flutter packages pub run build_runner build`

3. **Update Database Schema** (if needed)
   - Modify `DatabaseService._onCreate()` for new installations
   - Add migration logic in `DatabaseService._onUpgrade()` for existing users

4. **Implement Business Logic**
   - Add methods to appropriate providers
   - Update services if database/storage changes are needed

5. **Create/Update UI Components**
   - Create new widgets in `lib/widgets/`
   - Update existing screens in `lib/screens/`

6. **Test Changes**
   ```bash
   flutter test
   flutter run -d chrome  # For web testing
   ```

### Adding New Coloring Pages

1. **Prepare Assets**
   - Create SVG or high-resolution image
   - Generate thumbnail (recommended: 300x300px)
   - Define color regions and palette

2. **Create ColoringPage Object**
   ```dart
   final newPage = ColoringPage(
     id: 'unique_id',
     title: 'Page Title',
     category: 'Animals',  // Use existing category
     imagePath: 'assets/coloring_pages/image.svg',
     thumbnailPath: 'assets/coloring_pages/thumbs/thumb.png',
     regions: regions,     // List of ColorRegion objects
     palette: palette,     // List of ColorPalette objects
     difficulty: 2,        // 1-4 scale
     createdAt: DateTime.now(),
   );
   ```

3. **Add to Database**
   ```dart
   await DatabaseService().insertColoringPage(newPage);
   ```

### Adding New Categories

1. **Update Constants**
   ```dart
   // In lib/constants/app_constants.dart
   static const List<String> categories = [
     'Featured',
     'Animals',
     'Mandalas',
     // ... existing categories
     'New Category',  // Add here
   ];
   ```

2. **Update Category Icons**
   ```dart
   // In lib/widgets/coloring_page_card.dart
   IconData _getCategoryIcon() {
     switch (page.category.toLowerCase()) {
       // ... existing cases
       case 'new category':
         return Icons.new_icon;
       default:
         return Icons.palette;
     }
   }
   ```

## Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Test Structure
- Unit tests for models and services
- Widget tests for UI components
- Integration tests for complete user flows

## Performance Optimization

### Image Loading
- Use appropriate image formats (SVG for scalable graphics)
- Implement lazy loading for large image libraries
- Cache thumbnails for smooth scrolling

### Database Queries
- Use indexed columns for frequent queries
- Implement pagination for large datasets
- Optimize JSON serialization/deserialization

### Memory Management
- Dispose controllers and listeners properly
- Use const constructors where possible
- Implement efficient list rendering with ListView.builder

## Debugging

### Common Issues

1. **Database Errors**
   - Check SQL syntax in DatabaseService
   - Verify JSON serialization/deserialization
   - Ensure proper data types in database operations

2. **State Management Issues**
   - Verify Provider context usage
   - Check notifyListeners() calls
   - Ensure proper provider disposal

3. **UI Rendering Problems**
   - Check widget tree structure
   - Verify constraint handling
   - Test on different screen sizes

### Debug Tools
```bash
# Flutter Inspector
flutter run --debug

# Performance profiling
flutter run --profile

# Analyze code
flutter analyze
```

## Deployment

### Build Commands
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

### Release Checklist
- [ ] Update version in pubspec.yaml
- [ ] Test on multiple devices/platforms
- [ ] Verify all assets are included
- [ ] Check app permissions
- [ ] Update app store metadata
- [ ] Generate release notes

## Contributing Guidelines

1. Follow Flutter/Dart style guidelines
2. Write meaningful commit messages
3. Add tests for new features
4. Update documentation for API changes
5. Ensure code passes `flutter analyze`
6. Test on multiple platforms before submitting PR

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [Material Design Guidelines](https://material.io/design)

## Support

For development questions or issues:
1. Check existing GitHub issues
2. Review this development guide
3. Consult Flutter documentation
4. Create new issue with detailed description and reproduction steps