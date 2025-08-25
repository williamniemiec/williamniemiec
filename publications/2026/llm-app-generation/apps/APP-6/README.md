# Canva Mobile App

A comprehensive Flutter mobile application that replicates Canva's functionality, featuring template-driven workflows, drag-and-drop editing, AI-powered tools, and collaborative design capabilities.

## Features

### Core Design & Editing Suite
- **Template-Driven Workflow**: Access to hundreds of thousands of professionally designed, fully customizable templates
- **Drag-and-Drop Editor**: Intuitive interface for adding, removing, and rearranging design elements
- **Photo Editor**: Comprehensive image enhancement tools including cropping, filters, and effects
- **Video Editor**: User-friendly video creation with templates, stock footage, and animations
- **Text & Typography**: Library of 500+ fonts with advanced text styling options

### AI-Powered Features (Magic Studio)
- **Magic Design**: AI-generated template designs from uploaded images
- **Magic Edit**: Add, replace, or modify elements using text prompts
- **Magic Eraser**: Seamlessly remove unwanted objects from photos
- **Text to Image**: AI art generator from text descriptions
- **Background Remover**: One-click background removal
- **Magic Translate**: Automatic text translation in 100+ languages

### Content & Asset Library
- **Extensive Stock Library**: Millions of royalty-free photos, illustrations, graphics, and icons
- **Audio Library**: Thousands of pre-licensed music tracks and sound effects
- **User Uploads**: Support for personal photos, videos, and audio files

### Productivity & Collaboration
- **Social Media Scheduler**: Plan and schedule posts to Instagram and Facebook
- **Brand Hub**: Centralized brand asset management
- **Real-Time Collaboration**: Team editing with comments and feedback
- **Cloud Storage**: Automatic cloud synchronization across devices

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # App-wide constants
│   ├── theme/
│   │   └── app_theme.dart              # Theme configuration
│   ├── utils/
│   │   └── app_utils.dart              # Utility functions
│   └── services/
│       ├── api_service.dart            # API communication
│       └── storage_service.dart        # Local storage management
├── features/
│   ├── home/
│   │   ├── screens/
│   │   │   └── home_screen.dart        # Main dashboard
│   │   └── widgets/
│   │       ├── design_format_card.dart
│   │       ├── template_card.dart
│   │       ├── recent_design_card.dart
│   │       └── search_bar_widget.dart
│   ├── editor/
│   │   └── screens/
│   │       └── editor_screen.dart      # Design editor
│   ├── templates/
│   │   └── screens/
│   │       └── template_browser_screen.dart
│   └── assets/
│       ├── screens/
│       │   └── asset_browser_screen.dart
│       └── widgets/
│           └── asset_card.dart
└── shared/
    ├── models/
    │   ├── user.dart                   # User data model
    │   ├── design.dart                 # Design data model
    │   ├── template.dart               # Template data model
    │   ├── asset.dart                  # Asset data model
    │   └── json_converters.dart        # JSON serialization helpers
    ├── widgets/                        # Reusable UI components
    └── services/                       # Shared business logic
```

## Getting Started

### Prerequisites

- Flutter SDK (3.8.0 or higher)
- Dart SDK (3.8.0 or higher)
- Android Studio / VS Code with Flutter extensions
- iOS development setup (for iOS builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd canva_mobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code files**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Code Generation**
   For JSON serialization and other generated code:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Watch for changes** (during development):
   ```bash
   flutter packages pub run build_runner watch
   ```

## Architecture

### Design Patterns
- **MVVM (Model-View-ViewModel)**: Clean separation of concerns
- **Repository Pattern**: Data access abstraction
- **Provider/Riverpod**: State management
- **Dependency Injection**: Service locator pattern

### Key Components

#### Data Models
- **User**: User profile, subscription, preferences, and usage data
- **Design**: Complete design with elements, settings, and metadata
- **Template**: Pre-designed templates with categories and ratings
- **Asset**: Media assets (photos, graphics, icons) with metadata

#### Services
- **ApiService**: HTTP client for backend communication
- **StorageService**: Local storage using SharedPreferences and Hive
- **Design Engine**: Canvas rendering and element manipulation

#### UI Components
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Custom Widgets**: Reusable components following design system
- **Animations**: Smooth transitions and micro-interactions

## Key Features Implementation

### Home Screen
- Dynamic dashboard with personalized content
- Quick access to design formats
- Recent designs carousel
- Featured templates grid
- Search functionality

### Editor Screen
- Canvas-based design editor
- Drag-and-drop element manipulation
- Contextual toolbars
- Undo/redo functionality
- Real-time preview

### Template Browser
- Categorized template library
- Search and filter capabilities
- Premium content indicators
- Template preview and usage

### Asset Library
- Multi-type asset browser (photos, graphics, icons)
- Search and categorization
- Premium asset management
- Favorites and collections

## API Integration

### Endpoints
```dart
// Templates
GET /templates
GET /templates/categories
GET /templates/{id}

// Assets
GET /assets/photos
GET /assets/graphics
GET /assets/icons

// Designs
POST /designs
GET /designs/{id}
PUT /designs/{id}
DELETE /designs/{id}

// AI Features
POST /ai/magic-design
POST /ai/magic-edit
POST /ai/background-remover
```

### Authentication
- JWT token-based authentication
- Automatic token refresh
- Secure storage of credentials

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Build & Deployment

### Android
```bash
flutter build apk --release
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

## Performance Optimization

### Image Optimization
- Cached network images
- Lazy loading for large lists
- Image compression and resizing

### Memory Management
- Proper disposal of controllers and streams
- Efficient list rendering with builders
- Asset caching strategies

### Network Optimization
- Request debouncing
- Offline capability
- Progressive loading

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent formatting

### Commit Messages
- Use conventional commit format
- Include scope when applicable
- Keep messages concise but descriptive

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Canva for design inspiration
- Open source community for packages and tools

## Support

For support and questions:
- Create an issue in the repository
- Check the documentation
- Review existing issues and discussions

---

**Note**: This is a demonstration project inspired by Canva's functionality. It is not affiliated with or endorsed by Canva Inc.
