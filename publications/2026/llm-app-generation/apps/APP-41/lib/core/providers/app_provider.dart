import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/weather_data.dart';
import '../../shared/models/weather_location.dart';
import '../../shared/services/weather_service.dart';
import '../constants/app_constants.dart';

class AppProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  
  // Theme
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // Weather Data
  WeatherData? _currentWeatherData;
  WeatherData? get currentWeatherData => _currentWeatherData;

  // Locations
  List<WeatherLocation> _savedLocations = [];
  List<WeatherLocation> get savedLocations => _savedLocations;
  
  WeatherLocation? _currentLocation;
  WeatherLocation? get currentLocation => _currentLocation;
  
  WeatherLocation? _selectedLocation;
  WeatherLocation? get selectedLocation => _selectedLocation;

  // Settings
  String _temperatureUnit = AppConstants.celsius;
  String get temperatureUnit => _temperatureUnit;
  
  String _windSpeedUnit = AppConstants.metersPerSecond;
  String get windSpeedUnit => _windSpeedUnit;
  
  String _pressureUnit = AppConstants.hectopascal;
  String get pressureUnit => _pressureUnit;

  // Loading states
  bool _isLoadingWeather = false;
  bool get isLoadingWeather => _isLoadingWeather;
  
  bool _isLoadingLocation = false;
  bool get isLoadingLocation => _isLoadingLocation;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AppProvider() {
    _loadSettings();
    _loadSavedLocations();
    _initializeCurrentLocation();
  }

  // Initialize app with current location
  Future<void> _initializeCurrentLocation() async {
    try {
      _isLoadingLocation = true;
      notifyListeners();

      final location = await _weatherService.getCurrentLocation();
      if (location != null) {
        _currentLocation = location;
        _selectedLocation = location;
        await _loadWeatherData();
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  // Load weather data for selected location
  Future<void> _loadWeatherData() async {
    if (_selectedLocation == null) return;

    try {
      _isLoadingWeather = true;
      _errorMessage = null;
      notifyListeners();

      final weatherData = await _weatherService.getWeatherData(
        _selectedLocation!,
        units: _getApiUnits(),
      );
      
      _currentWeatherData = weatherData;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  // Get API units based on temperature setting
  String _getApiUnits() {
    switch (_temperatureUnit) {
      case AppConstants.fahrenheit:
        return 'imperial';
      case AppConstants.kelvin:
        return 'standard';
      default:
        return 'metric';
    }
  }

  // Theme management
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeKey, mode.toString());
  }

  // Location management
  Future<void> selectLocation(WeatherLocation location) async {
    _selectedLocation = location;
    await _loadWeatherData();
  }

  Future<void> addLocation(WeatherLocation location) async {
    if (_savedLocations.length >= AppConstants.maxSavedLocations) {
      _errorMessage = 'Maximum number of locations reached';
      notifyListeners();
      return;
    }

    if (!_savedLocations.any((loc) => loc.id == location.id)) {
      _savedLocations.add(location);
      await _saveSavedLocations();
      notifyListeners();
    }
  }

  Future<void> removeLocation(WeatherLocation location) async {
    _savedLocations.removeWhere((loc) => loc.id == location.id);
    await _saveSavedLocations();
    
    // If removed location was selected, switch to current location
    if (_selectedLocation?.id == location.id) {
      _selectedLocation = _currentLocation;
      await _loadWeatherData();
    }
    
    notifyListeners();
  }

  Future<List<WeatherLocation>> searchLocations(String query) async {
    try {
      return await _weatherService.searchLocations(query);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  // Settings management
  Future<void> setTemperatureUnit(String unit) async {
    _temperatureUnit = unit;
    await _loadWeatherData(); // Reload with new units
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.temperatureUnitKey, unit);
  }

  Future<void> setWindSpeedUnit(String unit) async {
    _windSpeedUnit = unit;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.windSpeedUnitKey, unit);
  }

  Future<void> setPressureUnit(String unit) async {
    _pressureUnit = unit;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.pressureUnitKey, unit);
  }

  // Refresh weather data
  Future<void> refreshWeatherData() async {
    await _loadWeatherData();
  }

  // Update current location
  Future<void> updateCurrentLocation() async {
    try {
      _isLoadingLocation = true;
      notifyListeners();

      final location = await _weatherService.getCurrentLocation();
      if (location != null) {
        _currentLocation = location;
        
        // If current location is selected, update weather data
        if (_selectedLocation?.isCurrentLocation == true) {
          _selectedLocation = location;
          await _loadWeatherData();
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Convert temperature based on current unit setting
  double convertTemperature(double temperature) {
    return _weatherService.convertTemperature(
      temperature,
      _getApiUnits() == 'metric' ? AppConstants.celsius :
      _getApiUnits() == 'imperial' ? AppConstants.fahrenheit : AppConstants.kelvin,
      _temperatureUnit,
    );
  }

  // Convert wind speed based on current unit setting
  double convertWindSpeed(double windSpeed) {
    return _weatherService.convertWindSpeed(
      windSpeed,
      AppConstants.metersPerSecond,
      _windSpeedUnit,
    );
  }

  // Convert pressure based on current unit setting
  double convertPressure(double pressure) {
    return _weatherService.convertPressure(
      pressure,
      AppConstants.hectopascal,
      _pressureUnit,
    );
  }

  // Get unit symbols
  String getTemperatureUnitSymbol() {
    switch (_temperatureUnit) {
      case AppConstants.fahrenheit:
        return '°F';
      case AppConstants.kelvin:
        return 'K';
      default:
        return '°C';
    }
  }

  String getWindSpeedUnitSymbol() {
    switch (_windSpeedUnit) {
      case AppConstants.kilometersPerHour:
        return 'km/h';
      case AppConstants.milesPerHour:
        return 'mph';
      case AppConstants.knots:
        return 'kts';
      default:
        return 'm/s';
    }
  }

  String getPressureUnitSymbol() {
    switch (_pressureUnit) {
      case AppConstants.millibar:
        return 'mbar';
      case AppConstants.inchesOfMercury:
        return 'inHg';
      case AppConstants.millimetersOfMercury:
        return 'mmHg';
      default:
        return 'hPa';
    }
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final themeString = prefs.getString(AppConstants.themeKey);
      if (themeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeString,
          orElse: () => ThemeMode.system,
        );
      }
      
      _temperatureUnit = prefs.getString(AppConstants.temperatureUnitKey) ?? AppConstants.celsius;
      _windSpeedUnit = prefs.getString(AppConstants.windSpeedUnitKey) ?? AppConstants.metersPerSecond;
      _pressureUnit = prefs.getString(AppConstants.pressureUnitKey) ?? AppConstants.hectopascal;
      
      notifyListeners();
    } catch (e) {
      // Handle error silently, use defaults
    }
  }

  // Load saved locations from SharedPreferences
  Future<void> _loadSavedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = prefs.getStringList(AppConstants.savedLocationsKey);
      
      if (locationsJson != null) {
        _savedLocations = locationsJson
            .map((json) => WeatherLocation.fromJson(Map<String, dynamic>.from(
                Uri.splitQueryString(json))))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle error silently, use empty list
    }
  }

  // Save locations to SharedPreferences
  Future<void> _saveSavedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = _savedLocations
          .map((location) => Uri(queryParameters: location.toJson()).query)
          .toList();
      
      await prefs.setStringList(AppConstants.savedLocationsKey, locationsJson);
    } catch (e) {
      // Handle error silently
    }
  }
}