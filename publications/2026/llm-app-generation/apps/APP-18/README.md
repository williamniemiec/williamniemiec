# Pinterest Clone - Flutter Mobile App

A fully functional Pinterest-like mobile application built with Flutter, featuring visual discovery, pin creation, board management, and social interactions.

## 🎯 Features

### Core Discovery & Organization
- **Personalized Home Feed**: Infinite scroll masonry grid layout with algorithmically-curated pins
- **Powerful Search**: Robust search with trending topics, categories, and search history
- **Visual Search (Lens)**: AI-powered visual search using device camera
- **Pins**: Visual bookmarks with images, videos, and shoppable products
- **Boards**: Personal collections to organize pins by theme or project
- **Saving/Pinning**: Save pins to personal boards with one-tap functionality

### Creation & Social Features
- **Pin Creation**: Upload photos/videos with text overlays and destination links
- **User Profiles**: Personal spaces showcasing created pins and saved boards
- **Following System**: Follow users and boards for personalized content
- **Messaging**: Direct messaging to share pins and communicate
- **Comments**: Engage with pins through comments and replies

### Commerce & AI
- **Shopping Integration**: Product pins with real-time pricing and purchase links
- **Shop the Look**: AI-powered identification of multiple shoppable items
- **Visual Recognition**: ML Kit integration for object detection and text extraction

## 🏗️ Architecture

### Project Structure
```
lib/
├── constants/          # App constants and theme configuration
│   ├── app_constants.dart
│   └── app_theme.dart
├── models/            # Data models
│   ├── user.dart
│   ├── pin.dart
│   ├── board.dart
│   ├── comment.dart
│   ├── message.dart
│   ├── search.dart
│   └── category.dart
├── services/          # Core services
│   ├── api_service.dart
│   ├── database_service.dart
│   ├── storage_service.dart
│   └── image_service.dart
├── screens/           # UI screens
│   ├── splash_screen.dart
│   ├── main_screen.dart
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── create_screen.dart
│   ├── messages_screen.dart
│   └── profile_screen.dart
├── widgets/           # Reusable UI components
│   ├── pin_card.dart
│   └── custom_app_bar.dart
└── main.dart          # App entry point
```

### Key Technologies
- **Flutter**: Cross-platform mobile development framework
- **Riverpod**: State management solution
- **SQLite**: Local database for offline functionality
- **Dio**: HTTP client for API communication
- **ML Kit**: Machine learning capabilities for visual search
- **Cached Network Image**: Efficient image loading and caching

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- iOS development setup (for iOS deployment)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pinterest_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform Setup

#### Android
- Minimum SDK: 21
- Target SDK: 34
- Permissions required:
  - Camera access
  - Photo library access
  - Internet access
  - Storage access

#### iOS
- Minimum iOS version: 12.0
- Required permissions in Info.plist:
  - NSCameraUsageDescription
  - NSPhotoLibraryUsageDescription

## 📱 User Interface

### Design System
- **Colors**: Pinterest red (#E60023) as primary color
- **Typography**: Custom Pinterest font family with fallback to Roboto
- **Layout**: Masonry grid for optimal visual content display
- **Navigation**: Bottom tab navigation with 5 main sections

### Screen Flow
1. **Splash Screen**: App loading with animated logo
2. **Home Screen**: Masonry grid of personalized pins
3. **Search Screen**: Search functionality with trending topics
4. **Create Screen**: Options to create pins and boards
5. **Messages Screen**: Direct messaging interface
6. **Profile Screen**: User profile with created and saved content

## 🔧 Configuration

### API Configuration
Update the base API URL in `lib/constants/app_constants.dart`:
```dart
static const String baseApiUrl = 'https://your-api-endpoint.com/v1';
```

### Database Configuration
The app uses SQLite for local storage. Database initialization happens automatically on first launch.

### Image Caching
Images are cached locally for offline viewing. Cache size and expiration can be configured in `app_constants.dart`.

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Build for Production

#### Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

## 📦 Dependencies

### Core Dependencies
- `flutter_riverpod`: State management
- `dio`: HTTP client
- `sqflite`: SQLite database
- `shared_preferences`: Local storage
- `cached_network_image`: Image caching
- `flutter_staggered_grid_view`: Masonry layout

### UI Dependencies
- `photo_view`: Image viewer
- `shimmer`: Loading animations
- `lottie`: Vector animations

### Camera & ML
- `camera`: Camera functionality
- `image_picker`: Image selection
- `image_cropper`: Image editing
- `google_ml_kit`: Machine learning features
- `permission_handler`: Runtime permissions

### Social Features
- `url_launcher`: External link handling
- `share_plus`: Content sharing

## 🎨 Customization

### Theme Customization
Modify colors, fonts, and spacing in `lib/constants/app_theme.dart`:
```dart
static const Color primaryColor = Color(0xFFE60023); // Pinterest red
static const String fontFamily = 'Pinterest';
```

### Grid Layout
Adjust the masonry grid configuration in `app_constants.dart`:
```dart
static const int gridColumns = 2;
static const double gridSpacing = 8.0;
```

## 🔒 Privacy & Security

### Data Protection
- User data is encrypted in local storage
- API communications use HTTPS
- Image uploads are validated for content appropriateness
- User permissions are requested at runtime

### Content Moderation
- Inappropriate content detection
- Spam prevention mechanisms
- Community guidelines enforcement

## 🚀 Performance Optimization

### Image Optimization
- Automatic image compression
- Progressive loading
- Efficient caching strategy
- Thumbnail generation

### Memory Management
- Lazy loading of content
- Automatic cache cleanup
- Optimized database queries
- Background processing for heavy operations

## 🐛 Troubleshooting

### Common Issues

1. **Build Errors**
   - Run `flutter clean && flutter pub get`
   - Check Flutter and Dart SDK versions

2. **Permission Issues**
   - Ensure all required permissions are declared
   - Test on physical devices for camera/gallery access

3. **Network Issues**
   - Verify API endpoint configuration
   - Check internet connectivity
   - Review network security policies

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation wiki

## 🔄 Version History

### v1.0.0 (Current)
- Initial release
- Core Pinterest functionality
- Masonry grid layout
- Search and discovery features
- User profiles and social features
- Basic messaging system

---

**Built with ❤️ using Flutter**
