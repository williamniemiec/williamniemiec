import 'package:flutter/foundation.dart';
import '../../shared/models/weather_data.dart';
import '../../shared/services/weather_service.dart';
import '../../shared/services/location_service.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  WeatherData? _weatherData;
  WeatherStatus _status = WeatherStatus.initial;
  String? _errorMessage;
  Location? _currentLocation;
  List<SavedLocation> _savedLocations = [];
  List<RadarFrame> _radarFrames = [];
  bool _isRadarLoading = false;

  // Getters
  WeatherData? get weatherData => _weatherData;
  WeatherStatus get status => _status;
  String? get errorMessage => _errorMessage;
  Location? get currentLocation => _currentLocation;
  List<SavedLocation> get savedLocations => _savedLocations;
  List<RadarFrame> get radarFrames => _radarFrames;
  bool get isRadarLoading => _isRadarLoading;
  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasError => _status == WeatherStatus.error;
  bool get hasData => _weatherData != null;

  // Current weather getters
  CurrentWeather? get currentWeather => _weatherData?.current;
  List<HourlyForecast> get hourlyForecast => _weatherData?.hourly ?? [];
  List<DailyForecast> get dailyForecast => _weatherData?.daily ?? [];
  List<WeatherAlert> get activeAlerts => _weatherData?.alerts.where((alert) => alert.isActive).toList() ?? [];
  List<WeatherAlert> get severeAlerts => activeAlerts.where((alert) => alert.isSevere).toList();

  // Initialize the provider
  Future<void> initialize() async {
    await loadSavedLocations();
    await loadWeatherForCurrentLocation();
  }

  // Load weather data for current location
  Future<void> loadWeatherForCurrentLocation() async {
    try {
      _setStatus(WeatherStatus.loading);
      
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;
      
      final weatherData = await _weatherService.getCurrentWeather(
        location.latitude,
        location.longitude,
      );
      
      _weatherData = weatherData;
      _setStatus(WeatherStatus.loaded);
    } catch (e) {
      _setError('Failed to load weather data: ${e.toString()}');
    }
  }

  // Load weather data for specific location
  Future<void> loadWeatherForLocation(Location location) async {
    try {
      _setStatus(WeatherStatus.loading);
      
      _currentLocation = location;
      
      final weatherData = await _weatherService.getCurrentWeather(
        location.latitude,
        location.longitude,
      );
      
      _weatherData = weatherData;
      _setStatus(WeatherStatus.loaded);
    } catch (e) {
      _setError('Failed to load weather data: ${e.toString()}');
    }
  }

  // Refresh current weather data
  Future<void> refreshWeather() async {
    if (_currentLocation != null) {
      await loadWeatherForLocation(_currentLocation!);
    } else {
      await loadWeatherForCurrentLocation();
    }
  }

  // Load radar data
  Future<void> loadRadarData() async {
    if (_currentLocation == null) return;
    
    try {
      _isRadarLoading = true;
      notifyListeners();
      
      final frames = await _weatherService.getRadarData(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
      
      _radarFrames = frames;
      _isRadarLoading = false;
      notifyListeners();
    } catch (e) {
      _isRadarLoading = false;
      print('Error loading radar data: $e');
      notifyListeners();
    }
  }

  // Search for locations
  Future<List<Location>> searchLocations(String query) async {
    try {
      return await _weatherService.searchLocations(query);
    } catch (e) {
      throw Exception('Failed to search locations: ${e.toString()}');
    }
  }

  // Save a location
  Future<void> saveLocation(Location location) async {
    try {
      await _locationService.saveLocation(location);
      await loadSavedLocations();
    } catch (e) {
      throw Exception('Failed to save location: ${e.toString()}');
    }
  }

  // Remove a saved location
  Future<void> removeSavedLocation(String locationId) async {
    try {
      await _locationService.removeSavedLocation(locationId);
      await loadSavedLocations();
    } catch (e) {
      throw Exception('Failed to remove location: ${e.toString()}');
    }
  }

  // Set default location
  Future<void> setDefaultLocation(String locationId) async {
    try {
      await _locationService.setDefaultLocation(locationId);
      await loadSavedLocations();
    } catch (e) {
      throw Exception('Failed to set default location: ${e.toString()}');
    }
  }

  // Load saved locations
  Future<void> loadSavedLocations() async {
    try {
      _savedLocations = await _locationService.getSavedLocations();
      notifyListeners();
    } catch (e) {
      print('Error loading saved locations: $e');
    }
  }

  // Get weather for saved location
  Future<WeatherData?> getWeatherForSavedLocation(SavedLocation savedLocation) async {
    try {
      return await _weatherService.getCurrentWeather(
        savedLocation.location.latitude,
        savedLocation.location.longitude,
      );
    } catch (e) {
      print('Error getting weather for saved location: $e');
      return null;
    }
  }

  // Check if location is saved
  bool isLocationSaved(Location location) {
    return _savedLocations.any(
      (saved) => saved.location.latitude == location.latitude && 
                saved.location.longitude == location.longitude,
    );
  }

  // Get temperature in preferred unit
  String getTemperatureString(double temperature, {bool showUnit = true}) {
    // For now, always return Fahrenheit
    // In a real app, this would check user preferences
    final temp = temperature.round();
    return showUnit ? '${temp}°F' : temp.toString();
  }

  // Get wind speed in preferred unit
  String getWindSpeedString(double windSpeed, {bool showUnit = true}) {
    // For now, always return mph
    // In a real app, this would check user preferences
    final speed = windSpeed.round();
    return showUnit ? '${speed} mph' : speed.toString();
  }

  // Get pressure in preferred unit
  String getPressureString(double pressure, {bool showUnit = true}) {
    // Convert from hPa to inHg
    final inHg = (pressure * 0.02953).toStringAsFixed(2);
    return showUnit ? '$inHg inHg' : inHg;
  }

  // Get visibility in preferred unit
  String getVisibilityString(double visibility, {bool showUnit = true}) {
    // Convert from meters to miles
    final miles = (visibility * 0.000621371).toStringAsFixed(1);
    return showUnit ? '$miles mi' : miles;
  }

  // Get wind direction string
  String getWindDirectionString(int degrees) {
    const directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];
    final index = ((degrees + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  // Get precipitation probability string
  String getPrecipitationProbabilityString(double probability) {
    return '${(probability * 100).round()}%';
  }

  // Get UV index description
  String getUVIndexDescription(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  // Private helper methods
  void _setStatus(WeatherStatus status) {
    _status = status;
    if (status != WeatherStatus.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _status = WeatherStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    if (_status == WeatherStatus.error) {
      _status = WeatherStatus.initial;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Dispose
  @override
  void dispose() {
    super.dispose();
  }
}