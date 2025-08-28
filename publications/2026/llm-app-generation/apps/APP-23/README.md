# Google Maps Flutter App

A comprehensive Google Maps-like mobile application built with Flutter, featuring real-time navigation, place search, saved locations, and more.

## Features

### 🗺️ **Navigation & Transit**
- **Turn-by-Turn Navigation:** Real-time, voice-guided GPS navigation for driving, walking, cycling, and public transit
- **Real-Time Traffic:** Live traffic conditions, ETAs, and automatic re-routing
- **Multi-Modal Directions:** Route options across different modes of transport
- **Public Transit Information:** Detailed schedules and live transit times
- **Offline Maps:** Download maps for navigation without internet connection
- **Lane Guidance:** Shows which lane to be in for upcoming turns

### 🔍 **Search & Discovery**
- **Local Search:** Powerful search engine to find millions of businesses and places
- **Place Information:** Detailed information cards with reviews, hours, and contact info
- **User Reviews & Ratings:** Community-driven review system
- **Explore Nearby:** Discover popular and recommended places nearby
- **Category Search:** Quick search by categories (restaurants, gas stations, etc.)

### 💾 **Personalization & Saved Places**
- **Saved Places:** Save locations to custom lists
- **Labeled Places:** Label significant addresses like "Home" and "Work"
- **Location History:** Private map of places you've been
- **Location Sharing:** Share real-time location and ETA with others

### 🎨 **User Interface**
- **Interactive Map:** Full-screen, interactive map with multiple view types
- **Search Bar:** Persistent search with autocomplete suggestions
- **Category Pills:** Quick-access category buttons
- **Bottom Navigation:** Easy access to all main features
- **Place Info Sheets:** Detailed place information with actions

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theme and styling
│   └── utils/             # Utility functions
├── features/
│   ├── explore/           # Main map and search functionality
│   │   ├── providers/     # State management
│   │   ├── screens/       # UI screens
│   │   └── widgets/       # Reusable widgets
│   ├── navigation/        # Turn-by-turn navigation
│   ├── saved/            # Saved places and lists
│   ├── contribute/       # User contributions
│   └── updates/          # Notifications and updates
└── shared/
    ├── models/           # Data models
    ├── services/         # API and business logic
    └── widgets/          # Shared UI components
```

## Setup Instructions

### Prerequisites

- Flutter SDK (3.1.0 or higher)
- Dart SDK (3.1.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Google Maps API Key
- Google Places API Key

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd google_maps_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API Keys:**
   
   **Important:** You need to obtain API keys from Google Cloud Console:
   
   - Go to [Google Cloud Console](https://console.cloud.google.com/)
   - Create a new project or select an existing one
   - Enable the following APIs:
     - Maps SDK for Android
     - Maps SDK for iOS
     - Places API
     - Directions API
     - Geocoding API
   - Create credentials (API Keys) for each platform
   
   **Update the API keys in:**
   ```dart
   // lib/core/constants/app_constants.dart
   static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
   static const String placesApiKey = 'YOUR_PLACES_API_KEY';
   ```

4. **Configure Android:**
   
   Add your API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <application>
       <meta-data android:name="com.google.android.geo.API_KEY"
                  android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
   </application>
   ```

5. **Configure iOS:**
   
   Add your API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   import GoogleMaps
   
   @UIApplicationMain
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
       GeneratedPluginRegistrant.register(with: self)
       return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
   }
   ```

6. **Configure Permissions:**
   
   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.INTERNET" />
   ```
   
   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>This app needs location access to show your position on the map and provide navigation.</string>
   <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
   <string>This app needs location access to show your position on the map and provide navigation.</string>
   ```

### Running the App

1. **Start an emulator or connect a physical device**

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **For release build:**
   ```bash
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   ```

## Usage Guide

### Basic Navigation

1. **Explore Tab:** Main map interface with search and discovery
2. **Go Tab:** Navigation and route planning
3. **Saved Tab:** Manage your saved places and lists
4. **Contribute Tab:** Add reviews and photos
5. **Updates Tab:** Notifications and recommendations

### Searching for Places

1. Tap the search bar at the top
2. Type your query or select from suggestions
3. Tap on a result to see details
4. Use category pills for quick searches

### Getting Directions

1. Search for a destination or tap on the map
2. Tap "Directions" on the place info sheet
3. Select your travel mode (driving, walking, etc.)
4. Tap "Start" to begin navigation

### Saving Places

1. Search for or select a place
2. Tap the bookmark icon
3. Choose an existing list or create a new one
4. Access saved places in the "Saved" tab

## Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `google_maps_flutter`: Google Maps integration
- `provider`: State management
- `location`: Location services
- `geolocator`: GPS and location utilities

### API & Network
- `http`: HTTP client
- `dio`: Advanced HTTP client
- `geocoding`: Address geocoding

### Storage & Persistence
- `shared_preferences`: Local key-value storage
- `sqflite`: SQLite database

### UI & Utilities
- `cached_network_image`: Image caching
- `shimmer`: Loading animations
- `flutter_svg`: SVG support
- `url_launcher`: External URL handling
- `permission_handler`: Runtime permissions

## Architecture

The app follows a clean architecture pattern with:

- **Presentation Layer:** Screens and widgets
- **Business Logic Layer:** Providers and state management
- **Data Layer:** Services and models
- **Core Layer:** Constants, themes, and utilities

### State Management

Uses the Provider pattern for state management:
- `ExploreProvider`: Map and search functionality
- `NavigationProvider`: Turn-by-turn navigation
- `SavedProvider`: Saved places management

### Services

- `LocationService`: GPS and location handling
- `PlacesService`: Google Places API integration

## Customization

### Themes
Modify `lib/core/theme/app_theme.dart` to customize colors and styling.

### Constants
Update `lib/core/constants/app_constants.dart` for app configuration.

### Categories
Add or modify search categories in the constants file.

## Troubleshooting

### Common Issues

1. **API Key Issues:**
   - Ensure API keys are correctly configured
   - Check that required APIs are enabled in Google Cloud Console
   - Verify billing is enabled for your Google Cloud project

2. **Location Permission:**
   - Make sure location permissions are properly configured
   - Test on a physical device for accurate location services

3. **Build Issues:**
   - Run `flutter clean` and `flutter pub get`
   - Check that all dependencies are compatible

### Performance Tips

- Use release builds for testing performance
- Enable map lite mode for better performance on older devices
- Implement proper image caching for place photos

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Check the troubleshooting section
- Review Flutter and Google Maps documentation
- Open an issue in the repository

---

**Note:** This is a demonstration app. For production use, ensure proper error handling, security measures, and compliance with Google's API usage policies.
