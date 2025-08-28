class AppConstants {
  // App Information
  static const String appName = 'NOAA Weather Radar Live';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String weatherApiBaseUrl = 'https://api.weather.gov';
  static const String noaaRadarBaseUrl = 'https://radar.weather.gov';
  static const String openWeatherMapApiKey = 'your_openweathermap_api_key_here';
  static const String openWeatherMapBaseUrl = 'https://api.openweathermap.org/data/2.5';
  
  // Map Configuration
  static const double defaultLatitude = 39.8283;
  static const double defaultLongitude = -98.5795; // Center of USA
  static const double defaultZoom = 4.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 2.0;
  
  // Radar Configuration
  static const int radarAnimationFrames = 10;
  static const int radarAnimationDuration = 500; // milliseconds
  static const int radarUpdateInterval = 300000; // 5 minutes in milliseconds
  
  // Weather Alert Types
  static const List<String> severeWeatherAlerts = [
    'Tornado Warning',
    'Tornado Watch',
    'Severe Thunderstorm Warning',
    'Severe Thunderstorm Watch',
    'Hurricane Warning',
    'Hurricane Watch',
    'Flash Flood Warning',
    'Flood Warning',
    'Winter Storm Warning',
    'Blizzard Warning',
    'Ice Storm Warning',
    'High Wind Warning',
    'Extreme Cold Warning',
    'Excessive Heat Warning',
  ];
  
  // Storage Keys
  static const String savedLocationsKey = 'saved_locations';
  static const String currentLocationKey = 'current_location';
  static const String notificationSettingsKey = 'notification_settings';
  static const String themeSettingsKey = 'theme_settings';
  static const String unitsSettingsKey = 'units_settings';
  
  // Units
  static const String temperatureUnitFahrenheit = 'F';
  static const String temperatureUnitCelsius = 'C';
  static const String windSpeedUnitMph = 'mph';
  static const String windSpeedUnitKmh = 'km/h';
  static const String pressureUnitInHg = 'inHg';
  static const String pressureUnitMb = 'mb';
  
  // Default Settings
  static const String defaultTemperatureUnit = temperatureUnitFahrenheit;
  static const String defaultWindSpeedUnit = windSpeedUnitMph;
  static const String defaultPressureUnit = pressureUnitInHg;
  
  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String locationErrorMessage = 'Unable to get your location. Please enable location services.';
  static const String weatherDataErrorMessage = 'Unable to fetch weather data. Please try again later.';
  static const String radarDataErrorMessage = 'Unable to load radar data. Please try again later.';
}