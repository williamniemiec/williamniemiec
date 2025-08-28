# Waze App - Community-Powered Navigation

A Flutter mobile application inspired by Waze, featuring community-powered traffic and navigation with real-time alerts, route optimization, and user reporting capabilities.

## Features

### Core Navigation & Routing
- **Real-Time GPS Navigation**: Voice-guided, turn-by-turn directions
- **Dynamic Rerouting**: Automatic route changes based on live traffic data
- **Accurate ETAs**: Continuously updated arrival times based on traffic conditions
- **Lane Guidance**: Correct lane indicators for turns and exits
- **Toll Cost Information**: Estimated toll prices with avoidance options

### Community-Powered Real-Time Alerts
- **Crowdsourced Hazard Reporting**: Report traffic, police, accidents, and road hazards
- **Live Alerts**: Audio and visual notifications for upcoming hazards
- **Speed Camera Alerts**: Fixed speed and red-light camera notifications
- **Speedometer**: Current speed display with speed limit alerts

### Personalization & Convenience
- **Saved Places**: Quick access to Home, Work, and favorite locations
- **Search Functionality**: Find places, addresses, and points of interest
- **Voice Navigation**: Multiple voice options and languages
- **Customizable Interface**: Car icons, moods, and themes

## Project Structure

```
waze_app/
├── lib/
│   ├── core/
│   │   ├── constants/          # App constants and configuration
│   │   ├── theme/             # App theming and colors
│   │   └── utils/             # Utility functions
│   ├── features/
│   │   ├── map/               # Main map functionality
│   │   │   ├── screens/       # Map screen
│   │   │   ├── widgets/       # Map-related widgets
│   │   │   └── providers/     # Map state management
│   │   ├── navigation/        # Turn-by-turn navigation
│   │   │   ├── screens/       # Navigation screen
│   │   │   └── providers/     # Navigation state management
│   │   ├── reports/           # Community reporting
│   │   ├── search/            # Search functionality
│   │   ├── profile/           # User profile
│   │   └── settings/          # App settings
│   └── shared/
│       ├── models/            # Data models
│       ├── services/          # Core services
│       └── widgets/           # Reusable widgets
├── assets/
│   ├── images/               # App images
│   ├── icons/                # App icons
│   └── audio/                # Audio files
└── test/                     # Unit and widget tests
```

## Getting Started

### Prerequisites

- Flutter SDK (3.1.0 or higher)
- Dart SDK (3.1.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd waze_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys**
   
   Update the following constants in `lib/core/constants/app_constants.dart`:
   ```dart
   static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
   static const String placesApiKey = 'YOUR_PLACES_API_KEY';
   ```

4. **Set up Google Maps**
   
   **For Android:**
   - Add your API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
   ```

   **For iOS:**
   - Add your API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
   ```

5. **Configure permissions**
   
   The app requires the following permissions:
   - Location (always and when in use)
   - Microphone (for voice commands)
   - Notifications
   - Phone (for emergency features)

6. **Run the app**
   ```bash
   flutter run
   ```

### API Keys Setup

#### Google Maps API Key
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Places API
   - Directions API
   - Geocoding API
4. Create credentials (API Key)
5. Restrict the API key to your app's package name

#### Additional Services (Optional)
- Firebase (for real-time features and push notifications)
- Custom backend API for community features

## Key Components

### Models
- **User**: User profile and preferences
- **Location**: GPS coordinates and location data
- **Report**: Community-submitted hazard reports
- **Route**: Navigation routes with steps and polylines
- **Place**: Points of interest and saved locations

### Services
- **LocationService**: GPS tracking and location updates
- **NavigationService**: Route calculation and guidance
- **ReportService**: Community reporting functionality
- **VoiceService**: Text-to-speech for navigation

### Screens
- **MapScreen**: Main map interface with search and reporting
- **NavigationScreen**: Turn-by-turn navigation interface
- **SearchScreen**: Place search and selection
- **ReportsScreen**: Community reporting interface

## Configuration

### App Constants
Key configuration values in `lib/core/constants/app_constants.dart`:
- Map zoom levels and update intervals
- Location accuracy settings
- Report expiration times
- UI dimensions and animations

### Theme Customization
Modify colors and styling in `lib/core/theme/app_theme.dart`:
- Waze brand colors
- Traffic condition colors
- Report type colors
- Light and dark themes

## Development

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

### Code Analysis
```bash
# Analyze code quality
flutter analyze

# Format code
flutter format .
```

### Building for Release

**Android:**
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## Features Implementation Status

- ✅ Core app structure and theming
- ✅ Data models (User, Location, Route, Report)
- ✅ Location services and GPS tracking
- ✅ Interactive map with Google Maps
- ✅ Search functionality with bottom sheet
- ✅ Community reporting system
- ✅ Speedometer with speed limit alerts
- ✅ Navigation screen with turn-by-turn directions
- ✅ Saved places (Home/Work shortcuts)
- 🚧 Real-time traffic data integration
- 🚧 Voice guidance and TTS
- 🚧 Route optimization algorithms
- 🚧 Push notifications for alerts
- 🚧 User authentication and profiles
- 🚧 Offline map support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Architecture

The app follows a clean architecture pattern with:
- **Presentation Layer**: Screens and widgets
- **Business Logic Layer**: Providers and state management (Riverpod)
- **Data Layer**: Models and services
- **External Layer**: APIs and device services

### State Management
- **Riverpod**: For reactive state management
- **StateNotifier**: For complex state logic
- **Provider**: For dependency injection

### Navigation
- **Go Router**: For declarative routing
- **Named routes**: For easy navigation management

## Performance Considerations

- Efficient map rendering with marker clustering
- Location updates optimized for battery life
- Image caching for map icons and user avatars
- Lazy loading for search results and route data

## Security

- API keys stored securely (not in version control)
- Location data handled according to privacy guidelines
- User data encrypted in local storage
- Network requests use HTTPS

## Troubleshooting

### Common Issues

1. **Map not loading**
   - Verify Google Maps API key is correct
   - Check API key restrictions
   - Ensure Maps SDK is enabled

2. **Location not working**
   - Check location permissions
   - Verify location services are enabled
   - Test on physical device (not simulator)

3. **Build errors**
   - Run `flutter clean && flutter pub get`
   - Check Flutter and Dart SDK versions
   - Verify all dependencies are compatible

### Debug Mode
Enable debug logging by setting:
```dart
const bool kDebugMode = true;
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by Waze's community-driven approach
- Google Maps Platform for mapping services
- Flutter team for the amazing framework
- Open source community for various packages used

---

**Note**: This is a demonstration app inspired by Waze. For production use, ensure compliance with all relevant laws, privacy regulations, and terms of service for mapping and location services.
