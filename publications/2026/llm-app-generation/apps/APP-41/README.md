# Weather Pro - Flutter Weather Application

A comprehensive weather application built with Flutter that provides accurate, real-time weather information with advanced features including radar maps, weather alerts, and personalized forecasts.

## Features

### Core Weather Forecasts
- **Current Conditions**: Real-time temperature, "Feels Like" temperature, weather condition, wind speed/direction, and humidity
- **Hourly Forecast**: Detailed 24-hour forecast with temperature, precipitation probability, and wind data
- **Daily Forecast**: Extended 7-day forecast with high/low temperatures, precipitation chances, and weather icons
- **Hyper-Local Data**: Minute-by-minute precipitation forecasts and location-specific weather data

### Detailed Weather Metrics
- **Atmospheric Data**: Barometric pressure, visibility, dew point, and air quality index
- **Sun & Moon Information**: Sunrise/sunset times, moon phase, and illumination percentage
- **Health & Activity Indices**: UV Index with safety recommendations and air quality monitoring
- **Environmental Data**: Real-time air pollution levels and pollen count (when available)

### Advanced Features
- **Multiple Location Management**: Save and switch between up to 10 favorite locations
- **Customizable Units**: Temperature (°C/°F/K), wind speed (m/s, km/h, mph, knots), and pressure units
- **Theme Support**: Light and dark mode with system-adaptive theming
- **Weather Alerts**: Push notifications for severe weather warnings and precipitation alerts
- **Responsive Design**: Optimized for various screen sizes and orientations

## Screenshots

*Note: Add screenshots of the app in action here*

## Installation

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- OpenWeatherMap API key (free registration required)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd weather_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   - Sign up for a free API key at [OpenWeatherMap](https://openweathermap.org/api)
   - Open `lib/core/constants/app_constants.dart`
   - Replace `YOUR_OPENWEATHERMAP_API_KEY` with your actual API key:
   ```dart
   static const String openWeatherMapApiKey = 'your_actual_api_key_here';
   ```

4. **Configure Permissions**
   
   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.INTERNET" />
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
   ```

   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>This app needs location access to provide weather information for your current location.</string>
   <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
   <string>This app needs location access to provide weather alerts and updates.</string>
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## Project Structure

```
weather_app/
├── lib/
│   ├── core/
│   │   ├── constants/          # App constants and configuration
│   │   ├── providers/          # State management (Provider pattern)
│   │   └── theme/              # App theming and styling
│   ├── features/
│   │   ├── dashboard/          # Main weather dashboard
│   │   │   ├── screens/        # Dashboard screen
│   │   │   └── widgets/        # Dashboard-specific widgets
│   │   ├── map/                # Weather radar and maps
│   │   ├── locations/          # Location management
│   │   ├── alerts/             # Weather alerts system
│   │   └── settings/           # App settings and preferences
│   ├── shared/
│   │   ├── models/             # Data models
│   │   ├── services/           # API services and utilities
│   │   └── widgets/            # Reusable UI components
│   └── main.dart               # App entry point
├── assets/
│   ├── images/                 # Image assets
│   ├── icons/                  # Weather and UI icons
│   ├── animations/             # Lottie animations
│   └── fonts/                  # Custom fonts
└── test/                       # Unit and widget tests
```

## Architecture

The app follows a clean architecture pattern with clear separation of concerns:

- **Presentation Layer**: Flutter widgets and screens
- **Business Logic Layer**: Provider-based state management
- **Data Layer**: API services and local storage
- **Models**: Data transfer objects and entities

### Key Components

1. **AppProvider**: Central state management for weather data, locations, and settings
2. **WeatherService**: Handles all API communications with OpenWeatherMap
3. **Theme System**: Comprehensive theming with light/dark mode support
4. **Location Management**: GPS-based current location and saved locations
5. **Unit Conversion**: Automatic conversion between different measurement units

## API Integration

The app integrates with OpenWeatherMap APIs:

- **Current Weather API**: Real-time weather conditions
- **5-Day Forecast API**: Hourly and daily forecasts
- **Geocoding API**: Location search and coordinates
- **Air Pollution API**: Air quality data
- **One Call API**: Comprehensive weather data (requires subscription)

## Customization

### Adding New Weather Metrics
1. Update the `WeatherMetrics` model in `lib/shared/models/weather_data.dart`
2. Modify the `WeatherService` to fetch additional data
3. Add new metric cards in `WeatherMetricsGrid` widget

### Theming
- Colors and styles are defined in `lib/core/theme/app_theme.dart`
- Weather condition colors can be customized in the `getWeatherConditionColor` method
- Alert severity colors are configurable for different warning levels

### Adding New Units
1. Add unit constants in `lib/core/constants/app_constants.dart`
2. Implement conversion logic in `WeatherService`
3. Update the settings UI to include new unit options

## Testing

Run the test suite:
```bash
flutter test
```

For integration testing:
```bash
flutter drive --target=test_driver/app.dart
```

## Performance Considerations

- **Caching**: Weather data is cached for 10 minutes to reduce API calls
- **Lazy Loading**: Widgets are built on-demand to improve performance
- **Image Optimization**: Weather icons are optimized for different screen densities
- **Memory Management**: Proper disposal of controllers and listeners

## Troubleshooting

### Common Issues

1. **Location Permission Denied**
   - Ensure location permissions are granted in device settings
   - Check that location services are enabled

2. **API Key Issues**
   - Verify your OpenWeatherMap API key is valid and active
   - Check API usage limits haven't been exceeded

3. **Network Connectivity**
   - The app requires internet connection for weather data
   - Cached data will be shown when offline

4. **Build Issues**
   - Run `flutter clean` and `flutter pub get`
   - Ensure Flutter SDK is up to date

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [OpenWeatherMap](https://openweathermap.org/) for weather data API
- [Flutter](https://flutter.dev/) for the amazing framework
- Weather icons and assets from various open-source contributors

## Support

For support, email support@weatherpro.com or create an issue in the repository.

## Roadmap

### Upcoming Features
- [ ] Weather radar animations
- [ ] Severe weather push notifications
- [ ] Weather widgets for home screen
- [ ] Historical weather data
- [ ] Weather photography integration
- [ ] Social sharing features
- [ ] Offline mode improvements
- [ ] Apple Watch / Wear OS support

---

**Weather Pro** - Your comprehensive weather companion! 🌤️
