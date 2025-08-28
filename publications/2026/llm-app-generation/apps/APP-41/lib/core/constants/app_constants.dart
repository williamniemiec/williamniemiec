class AppConstants {
  // App Information
  static const String appName = 'Weather Pro';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String openWeatherMapApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  static const String openWeatherMapBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String oneCallApiUrl = 'https://api.openweathermap.org/data/3.0/onecall';
  static const String geocodingApiUrl = 'https://api.openweathermap.org/geo/1.0';
  
  // Storage Keys
  static const String savedLocationsKey = 'saved_locations';
  static const String currentLocationKey = 'current_location';
  static const String temperatureUnitKey = 'temperature_unit';
  static const String windSpeedUnitKey = 'wind_speed_unit';
  static const String pressureUnitKey = 'pressure_unit';
  static const String themeKey = 'theme_mode';
  static const String notificationSettingsKey = 'notification_settings';
  
  // Default Values
  static const int maxSavedLocations = 10;
  static const int weatherCacheTimeMinutes = 10;
  static const int locationSearchLimit = 5;
  static const double defaultLatitude = 40.7128;
  static const double defaultLongitude = -74.0060; // New York City
  
  // Weather Icons Mapping
  static const Map<String, String> weatherIcons = {
    '01d': 'assets/icons/clear_day.svg',
    '01n': 'assets/icons/clear_night.svg',
    '02d': 'assets/icons/partly_cloudy_day.svg',
    '02n': 'assets/icons/partly_cloudy_night.svg',
    '03d': 'assets/icons/cloudy.svg',
    '03n': 'assets/icons/cloudy.svg',
    '04d': 'assets/icons/overcast.svg',
    '04n': 'assets/icons/overcast.svg',
    '09d': 'assets/icons/rain.svg',
    '09n': 'assets/icons/rain.svg',
    '10d': 'assets/icons/rain_day.svg',
    '10n': 'assets/icons/rain_night.svg',
    '11d': 'assets/icons/thunderstorm.svg',
    '11n': 'assets/icons/thunderstorm.svg',
    '13d': 'assets/icons/snow.svg',
    '13n': 'assets/icons/snow.svg',
    '50d': 'assets/icons/mist.svg',
    '50n': 'assets/icons/mist.svg',
  };
  
  // Temperature Units
  static const String celsius = 'celsius';
  static const String fahrenheit = 'fahrenheit';
  static const String kelvin = 'kelvin';
  
  // Wind Speed Units
  static const String metersPerSecond = 'mps';
  static const String kilometersPerHour = 'kmh';
  static const String milesPerHour = 'mph';
  static const String knots = 'knots';
  
  // Pressure Units
  static const String hectopascal = 'hPa';
  static const String millibar = 'mbar';
  static const String inchesOfMercury = 'inHg';
  static const String millimetersOfMercury = 'mmHg';
  
  // Alert Severity Levels
  static const String severityMinor = 'Minor';
  static const String severityModerate = 'Moderate';
  static const String severitySevere = 'Severe';
  static const String severityExtreme = 'Extreme';
  
  // Map Configuration
  static const double defaultMapZoom = 10.0;
  static const double minMapZoom = 3.0;
  static const double maxMapZoom = 18.0;
  
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
  
  // Refresh Intervals
  static const Duration weatherRefreshInterval = Duration(minutes: 15);
  static const Duration locationRefreshInterval = Duration(minutes: 5);
  static const Duration alertCheckInterval = Duration(minutes: 1);
  
  // Network Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String locationErrorMessage = 'Unable to get your location. Please enable location services.';
  static const String weatherDataErrorMessage = 'Unable to fetch weather data. Please try again later.';
  static const String permissionDeniedMessage = 'Location permission denied. Please enable location access in settings.';
  
  // Success Messages
  static const String locationAddedMessage = 'Location added successfully';
  static const String locationRemovedMessage = 'Location removed successfully';
  static const String settingsUpdatedMessage = 'Settings updated successfully';
  
  // Air Quality Index Ranges
  static const Map<int, String> aqiDescriptions = {
    1: 'Good',
    2: 'Fair',
    3: 'Moderate',
    4: 'Poor',
    5: 'Very Poor',
  };
  
  // UV Index Descriptions
  static const Map<int, String> uvIndexDescriptions = {
    0: 'Low',
    1: 'Low',
    2: 'Low',
    3: 'Moderate',
    4: 'Moderate',
    5: 'Moderate',
    6: 'High',
    7: 'High',
    8: 'Very High',
    9: 'Very High',
    10: 'Very High',
    11: 'Extreme',
  };
  
  // Notification Types
  static const String weatherAlertNotification = 'weather_alert';
  static const String precipitationNotification = 'precipitation';
  static const String lightningNotification = 'lightning';
  static const String dailyForecastNotification = 'daily_forecast';
}

class ApiEndpoints {
  static String currentWeather(double lat, double lon, String units) =>
      '${AppConstants.openWeatherMapBaseUrl}/weather?lat=$lat&lon=$lon&units=$units&appid=${AppConstants.openWeatherMapApiKey}';
  
  static String forecast(double lat, double lon, String units) =>
      '${AppConstants.openWeatherMapBaseUrl}/forecast?lat=$lat&lon=$lon&units=$units&appid=${AppConstants.openWeatherMapApiKey}';
  
  static String oneCall(double lat, double lon, String units) =>
      '${AppConstants.oneCallApiUrl}?lat=$lat&lon=$lon&units=$units&appid=${AppConstants.openWeatherMapApiKey}';
  
  static String geocoding(String query) =>
      '${AppConstants.geocodingApiUrl}/direct?q=$query&limit=${AppConstants.locationSearchLimit}&appid=${AppConstants.openWeatherMapApiKey}';
  
  static String reverseGeocoding(double lat, double lon) =>
      '${AppConstants.geocodingApiUrl}/reverse?lat=$lat&lon=$lon&limit=1&appid=${AppConstants.openWeatherMapApiKey}';
  
  static String airPollution(double lat, double lon) =>
      '${AppConstants.openWeatherMapBaseUrl}/air_pollution?lat=$lat&lon=$lon&appid=${AppConstants.openWeatherMapApiKey}';
}