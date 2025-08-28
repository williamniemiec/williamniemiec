# NOAA Weather Radar Live

A comprehensive weather tracking and forecasting mobile application built with Flutter, providing real-time, high-definition weather data directly from official sources like the National Oceanic and Atmospheric Administration (NOAA).

## Features

### 🌦️ Live Weather Radar
- High-resolution, interactive weather radar map showing real-time precipitation
- Visualizes rain, snow, and mixed precipitation with vivid, high-resolution color overlays
- Animated radar loop showing precipitation movement over the last 40 minutes up to the current time

### 🗺️ Advanced Map Layers & Overlays
- **Precipitation Forecast Map**: Visual forecast of precipitation for the next 24 hours
- **Satellite Map**: Cloud cover as seen from space
- **Specialized Trackers**: Dedicated trackers for hurricanes, wildfires, and lightning strikes
- **Customizable Background Maps**: Choose between standard, hybrid, and satellite map views

### ⚠️ Severe Weather Alerts & Notifications
- **Push Notifications**: Timely push notifications for official NWS watches, warnings, and alerts
- **Alert Types**: Covers tornadoes, hurricanes, freeze warnings, storm alerts, and more
- **Interactive Polygons**: Active alerts displayed as interactive, color-coded polygons on the map

### 📊 Detailed Weather Forecasts & Conditions
- **24-Hour and 7-Day Forecasts**: Detailed forecasts for the upcoming day and week
- **Current Conditions**: Current temperature, "Feels Like" temperature, and daily min/max temperatures
- **Comprehensive Metrics**: Pressure, humidity, wind speed and direction, visibility, and dew point
- **Additional Information**: Precipitation percentage and daily sunrise/sunset times

### 📍 Location Management
- **GPS Integration**: Automatically detects and shows weather for your current location
- **Bookmark Locations**: Search for and save multiple locations for easy access

## Screenshots

### Main Dashboard
The clean, vertically scrollable dashboard presents the most critical weather information at a glance:
- Current weather summary with large temperature display
- Horizontally scrollable hourly forecast carousel
- 7-day forecast list with high/low temperatures
- Detailed metrics grid showing humidity, wind, visibility, and pressure

### Interactive Radar Map
Full-screen, interactive map serving as the app's central feature:
- Geographic area with animated weather radar data overlay
- Layer selector to switch between different map overlays
- Animation controls with timeline scrubber and play/pause functionality
- Location search and GPS re-centering tools

### Weather Alerts
List-based view aggregating all active weather alerts:
- Active alerts for saved locations with severity indicators
- Detailed alert information including NWS text and expiration times
- Color-coded alert types for quick identification

## Technical Architecture

### Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/             # App theme and styling
│   ├── providers/         # State management providers
│   └── utils/             # Utility functions
├── features/
│   ├── dashboard/         # Main weather dashboard
│   ├── radar/            # Interactive radar map
│   ├── alerts/           # Weather alerts management
│   └── location/         # Location search and management
└── shared/
    ├── models/           # Data models
    ├── services/         # API services
    └── widgets/          # Reusable UI components
```

### Key Technologies
- **Flutter**: Cross-platform mobile development framework
- **Provider**: State management solution
- **Google Maps**: Interactive map functionality
- **HTTP**: API communication
- **Geolocator**: Location services
- **Shared Preferences**: Local data storage

### APIs and Data Sources
- **OpenWeatherMap API**: Current weather and forecast data
- **NOAA Weather API**: Official weather alerts and radar data
- **Geocoding Services**: Location search and reverse geocoding

## Setup and Installation

### Prerequisites
- Flutter SDK (>=3.1.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Chrome (for web development)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd noaa_weather_radar_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code (for JSON serialization)**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure API Keys**
   
   Update the API key in `lib/core/constants/app_constants.dart`:
   ```dart
   static const String openWeatherMapApiKey = 'your_api_key_here';
   ```
   
   Get your free API key from [OpenWeatherMap](https://openweathermap.org/api).

5. **Run the application**
   
   For web:
   ```bash
   flutter run -d chrome
   ```
   
   For mobile:
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
- Minimum SDK version: 21
- Add location permissions in `android/app/src/main/AndroidManifest.xml`
- Configure Google Maps API key in `android/app/src/main/AndroidManifest.xml`

#### iOS
- Minimum iOS version: 11.0
- Add location usage descriptions in `ios/Runner/Info.plist`
- Configure Google Maps API key in `ios/Runner/AppDelegate.swift`

#### Web
- Enable location services in browser
- HTTPS required for location services in production

## Configuration

### Environment Variables
Create a `.env` file in the root directory:
```
OPENWEATHERMAP_API_KEY=your_api_key_here
GOOGLE_MAPS_API_KEY=your_google_maps_key_here
```

### App Constants
Modify `lib/core/constants/app_constants.dart` to customize:
- API endpoints
- Default location coordinates
- Radar animation settings
- Alert types and severities

## User Interaction Flows

### Checking Daily Forecast
1. Open app → loads Main Dashboard for current location
2. View current temperature and conditions at top
3. Scroll down to see hourly and daily forecasts

### Tracking Approaching Weather
1. Tap "Map" or "Radar" in bottom navigation
2. View full-screen animated precipitation radar
3. Pinch-to-zoom for neighborhood-level detail
4. Observe animated loop to estimate storm arrival

### Responding to Weather Alerts
1. Receive push notification for weather warning
2. Tap notification → opens full NWS warning text
3. Navigate to Radar Map to see highlighted warning area
4. View affected regions as colored polygons

### Managing Locations
1. Navigate to location management screen
2. Search for new city using search bar
3. Select city from results and bookmark
4. Switch between saved locations with single tap

## Development

### Code Generation
The app uses code generation for JSON serialization. After modifying model classes, run:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Testing
Run unit tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

### Building for Production

#### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- **NOAA**: National Oceanic and Atmospheric Administration for weather data
- **OpenWeatherMap**: Weather API services
- **Flutter Team**: Amazing cross-platform framework
- **Google Maps**: Interactive mapping functionality

## Support

For support, email support@noaaweatherradar.com or create an issue in the GitHub repository.

## Roadmap

### Upcoming Features
- [ ] Weather widgets for home screen
- [ ] Offline mode with cached data
- [ ] Weather photography sharing
- [ ] Advanced storm tracking
- [ ] Weather history and trends
- [ ] Premium subscription features
- [ ] Apple Watch / Wear OS support
- [ ] Weather-based notifications and recommendations

---

**NOAA Weather Radar Live** - Stay ahead of the weather with real-time radar and comprehensive forecasting.
