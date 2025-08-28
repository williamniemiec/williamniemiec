import 'dart:convert';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/weather_data.dart';
import '../models/weather_location.dart';
import '../../core/constants/app_constants.dart';

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  factory WeatherService() => _instance;
  WeatherService._internal();

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: AppConstants.connectionTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  // Get current location
  Future<WeatherLocation?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return WeatherLocation(
          id: 'current_location',
          name: place.locality ?? 'Current Location',
          country: place.country ?? '',
          region: place.administrativeArea ?? '',
          latitude: position.latitude,
          longitude: position.longitude,
          isCurrentLocation: true,
          lastUpdated: DateTime.now(),
        );
      }

      return WeatherLocation(
        id: 'current_location',
        name: 'Current Location',
        country: '',
        region: '',
        latitude: position.latitude,
        longitude: position.longitude,
        isCurrentLocation: true,
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  // Search locations
  Future<List<WeatherLocation>> searchLocations(String query) async {
    try {
      final response = await _dio.get(ApiEndpoints.geocoding(query));
      
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) {
          return WeatherLocation(
            id: '${item['lat']}_${item['lon']}',
            name: item['name'] ?? '',
            country: item['country'] ?? '',
            region: item['state'] ?? '',
            latitude: (item['lat'] ?? 0.0).toDouble(),
            longitude: (item['lon'] ?? 0.0).toDouble(),
            isCurrentLocation: false,
            lastUpdated: DateTime.now(),
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to search locations: $e');
    }
  }

  // Get weather data for a location
  Future<WeatherData> getWeatherData(WeatherLocation location, {String units = 'metric'}) async {
    try {
      // Get current weather and forecast data
      final currentResponse = await _dio.get(
        ApiEndpoints.currentWeather(location.latitude, location.longitude, units),
      );
      
      final forecastResponse = await _dio.get(
        ApiEndpoints.forecast(location.latitude, location.longitude, units),
      );
      
      final airPollutionResponse = await _dio.get(
        ApiEndpoints.airPollution(location.latitude, location.longitude),
      );

      if (currentResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        return _parseWeatherData(
          currentResponse.data,
          forecastResponse.data,
          airPollutionResponse.statusCode == 200 ? airPollutionResponse.data : null,
        );
      }
      
      throw Exception('Failed to fetch weather data');
    } catch (e) {
      throw Exception('Failed to get weather data: $e');
    }
  }

  // Parse weather data from API responses
  WeatherData _parseWeatherData(
    Map<String, dynamic> currentData,
    Map<String, dynamic> forecastData,
    Map<String, dynamic>? airPollutionData,
  ) {
    // Parse current weather
    final current = CurrentWeather(
      temperature: (currentData['main']['temp'] ?? 0.0).toDouble(),
      feelsLike: (currentData['main']['feels_like'] ?? 0.0).toDouble(),
      condition: currentData['weather'][0]['main'] ?? '',
      description: currentData['weather'][0]['description'] ?? '',
      iconCode: currentData['weather'][0]['icon'] ?? '',
      humidity: (currentData['main']['humidity'] ?? 0.0).toDouble(),
      windSpeed: (currentData['wind']['speed'] ?? 0.0).toDouble(),
      windDirection: (currentData['wind']['deg'] ?? 0).toInt(),
      pressure: (currentData['main']['pressure'] ?? 0.0).toDouble(),
      visibility: (currentData['visibility'] ?? 0.0).toDouble() / 1000, // Convert to km
      uvIndex: 0, // UV index not available in current weather API
      timestamp: DateTime.now(),
    );

    // Parse hourly forecast (next 24 hours)
    List<HourlyForecast> hourlyForecast = [];
    if (forecastData['list'] != null) {
      List<dynamic> forecastList = forecastData['list'];
      for (int i = 0; i < forecastList.length && i < 24; i++) {
        var item = forecastList[i];
        hourlyForecast.add(HourlyForecast(
          time: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
          temperature: (item['main']['temp'] ?? 0.0).toDouble(),
          condition: item['weather'][0]['main'] ?? '',
          iconCode: item['weather'][0]['icon'] ?? '',
          precipitationProbability: (item['pop'] ?? 0.0).toDouble() * 100,
          windSpeed: (item['wind']['speed'] ?? 0.0).toDouble(),
          windDirection: (item['wind']['deg'] ?? 0).toInt(),
        ));
      }
    }

    // Parse daily forecast (next 5 days from 5-day forecast)
    List<DailyForecast> dailyForecast = [];
    if (forecastData['list'] != null) {
      List<dynamic> forecastList = forecastData['list'];
      Map<String, List<dynamic>> dailyData = {};
      
      // Group forecast data by day
      for (var item in forecastList) {
        DateTime date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        String dateKey = '${date.year}-${date.month}-${date.day}';
        
        if (!dailyData.containsKey(dateKey)) {
          dailyData[dateKey] = [];
        }
        dailyData[dateKey]!.add(item);
      }

      // Create daily forecasts
      dailyData.forEach((dateKey, dayData) {
        if (dayData.isNotEmpty) {
          // Find min and max temperatures for the day
          double minTemp = dayData.map((item) => (item['main']['temp_min'] ?? 0.0).toDouble()).reduce((a, b) => a < b ? a : b);
          double maxTemp = dayData.map((item) => (item['main']['temp_max'] ?? 0.0).toDouble()).reduce((a, b) => a > b ? a : b);
          
          // Use midday data for other values
          var middayData = dayData[dayData.length ~/ 2];
          
          dailyForecast.add(DailyForecast(
            date: DateTime.fromMillisecondsSinceEpoch(middayData['dt'] * 1000),
            highTemperature: maxTemp,
            lowTemperature: minTemp,
            condition: middayData['weather'][0]['main'] ?? '',
            description: middayData['weather'][0]['description'] ?? '',
            iconCode: middayData['weather'][0]['icon'] ?? '',
            precipitationProbability: (middayData['pop'] ?? 0.0).toDouble() * 100,
            windSpeed: (middayData['wind']['speed'] ?? 0.0).toDouble(),
            windDirection: (middayData['wind']['deg'] ?? 0).toInt(),
            uvIndex: 0, // UV index not available in forecast API
            sunrise: DateTime.fromMillisecondsSinceEpoch((currentData['sys']['sunrise'] ?? 0) * 1000),
            sunset: DateTime.fromMillisecondsSinceEpoch((currentData['sys']['sunset'] ?? 0) * 1000),
          ));
        }
      });
    }

    // Parse weather metrics
    int aqi = 0;
    String aqiDescription = 'Unknown';
    if (airPollutionData != null && airPollutionData['list'] != null && airPollutionData['list'].isNotEmpty) {
      aqi = airPollutionData['list'][0]['main']['aqi'] ?? 0;
      aqiDescription = AppConstants.aqiDescriptions[aqi] ?? 'Unknown';
    }

    final metrics = WeatherMetrics(
      dewPoint: _calculateDewPoint(current.temperature, current.humidity),
      airQualityIndex: aqi,
      airQualityDescription: aqiDescription,
      pollenCount: 0, // Pollen data not available in free API
      pollenDescription: 'Not available',
      moonPhase: _getCurrentMoonPhase(),
      moonIllumination: _getMoonIllumination(),
    );

    return WeatherData(
      current: current,
      hourlyForecast: hourlyForecast,
      dailyForecast: dailyForecast,
      metrics: metrics,
      alerts: [], // Weather alerts would require a separate API call
      lastUpdated: DateTime.now(),
    );
  }

  // Calculate dew point
  double _calculateDewPoint(double temperature, double humidity) {
    double a = 17.27;
    double b = 237.7;
    double alpha = ((a * temperature) / (b + temperature)) + (humidity / 100).log();
    return (b * alpha) / (a - alpha);
  }

  // Get current moon phase (simplified calculation)
  String _getCurrentMoonPhase() {
    DateTime now = DateTime.now();
    int daysSinceNewMoon = now.difference(DateTime(2000, 1, 6)).inDays % 29;
    
    if (daysSinceNewMoon < 2) return 'New Moon';
    if (daysSinceNewMoon < 7) return 'Waxing Crescent';
    if (daysSinceNewMoon < 9) return 'First Quarter';
    if (daysSinceNewMoon < 14) return 'Waxing Gibbous';
    if (daysSinceNewMoon < 16) return 'Full Moon';
    if (daysSinceNewMoon < 21) return 'Waning Gibbous';
    if (daysSinceNewMoon < 23) return 'Last Quarter';
    return 'Waning Crescent';
  }

  // Get moon illumination percentage (simplified calculation)
  double _getMoonIllumination() {
    DateTime now = DateTime.now();
    int daysSinceNewMoon = now.difference(DateTime(2000, 1, 6)).inDays % 29;
    
    if (daysSinceNewMoon <= 14) {
      return daysSinceNewMoon / 14.0;
    } else {
      return (29 - daysSinceNewMoon) / 14.0;
    }
  }

  // Get weather alerts (placeholder - would require additional API)
  Future<List<WeatherAlert>> getWeatherAlerts(WeatherLocation location) async {
    // This would typically call a weather alerts API
    // For now, return empty list
    return [];
  }

  // Convert temperature units
  double convertTemperature(double temperature, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return temperature;
    
    // Convert to Celsius first
    double celsius = temperature;
    if (fromUnit == AppConstants.fahrenheit) {
      celsius = (temperature - 32) * 5 / 9;
    } else if (fromUnit == AppConstants.kelvin) {
      celsius = temperature - 273.15;
    }
    
    // Convert from Celsius to target unit
    switch (toUnit) {
      case AppConstants.fahrenheit:
        return celsius * 9 / 5 + 32;
      case AppConstants.kelvin:
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  // Convert wind speed units
  double convertWindSpeed(double windSpeed, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return windSpeed;
    
    // Convert to m/s first
    double mps = windSpeed;
    switch (fromUnit) {
      case AppConstants.kilometersPerHour:
        mps = windSpeed / 3.6;
        break;
      case AppConstants.milesPerHour:
        mps = windSpeed * 0.44704;
        break;
      case AppConstants.knots:
        mps = windSpeed * 0.514444;
        break;
    }
    
    // Convert from m/s to target unit
    switch (toUnit) {
      case AppConstants.kilometersPerHour:
        return mps * 3.6;
      case AppConstants.milesPerHour:
        return mps / 0.44704;
      case AppConstants.knots:
        return mps / 0.514444;
      default:
        return mps;
    }
  }

  // Convert pressure units
  double convertPressure(double pressure, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return pressure;
    
    // Convert to hPa first
    double hpa = pressure;
    switch (fromUnit) {
      case AppConstants.millibar:
        hpa = pressure; // mbar = hPa
        break;
      case AppConstants.inchesOfMercury:
        hpa = pressure * 33.8639;
        break;
      case AppConstants.millimetersOfMercury:
        hpa = pressure * 1.33322;
        break;
    }
    
    // Convert from hPa to target unit
    switch (toUnit) {
      case AppConstants.millibar:
        return hpa;
      case AppConstants.inchesOfMercury:
        return hpa / 33.8639;
      case AppConstants.millimetersOfMercury:
        return hpa / 1.33322;
      default:
        return hpa;
    }
  }
}

// Extension for mathematical operations
extension MathExtension on double {
  double log() => math.log(this);
}