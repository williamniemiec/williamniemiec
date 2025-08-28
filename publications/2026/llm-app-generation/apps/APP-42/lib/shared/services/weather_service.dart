import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_data.dart';
import '../../core/constants/app_constants.dart';

class WeatherService {
  static const String _openWeatherMapApiKey = AppConstants.openWeatherMapApiKey;
  static const String _openWeatherMapBaseUrl = AppConstants.openWeatherMapBaseUrl;
  static const String _noaaBaseUrl = AppConstants.weatherApiBaseUrl;

  // Get current weather data for a location
  Future<WeatherData> getCurrentWeather(double latitude, double longitude) async {
    try {
      // Get current weather from OpenWeatherMap
      final currentWeatherUrl = '$_openWeatherMapBaseUrl/weather'
          '?lat=$latitude&lon=$longitude&appid=$_openWeatherMapApiKey&units=imperial';
      
      final currentResponse = await http.get(Uri.parse(currentWeatherUrl));
      
      if (currentResponse.statusCode != 200) {
        throw Exception('Failed to fetch current weather data');
      }

      final currentData = json.decode(currentResponse.body);

      // Get forecast data
      final forecastUrl = '$_openWeatherMapBaseUrl/forecast'
          '?lat=$latitude&lon=$longitude&appid=$_openWeatherMapApiKey&units=imperial';
      
      final forecastResponse = await http.get(Uri.parse(forecastUrl));
      
      if (forecastResponse.statusCode != 200) {
        throw Exception('Failed to fetch forecast data');
      }

      final forecastData = json.decode(forecastResponse.body);

      // Get weather alerts from NOAA (if in US)
      List<WeatherAlert> alerts = [];
      try {
        alerts = await _getWeatherAlerts(latitude, longitude);
      } catch (e) {
        // Alerts might not be available for all locations
        print('Weather alerts not available: $e');
      }

      return _parseWeatherData(currentData, forecastData, alerts, latitude, longitude);
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  // Get weather data for current location
  Future<WeatherData> getCurrentLocationWeather() async {
    try {
      final position = await _getCurrentPosition();
      return await getCurrentWeather(position.latitude, position.longitude);
    } catch (e) {
      throw Exception('Error getting current location weather: $e');
    }
  }

  // Get weather alerts from NOAA
  Future<List<WeatherAlert>> _getWeatherAlerts(double latitude, double longitude) async {
    try {
      final alertsUrl = '$_noaaBaseUrl/alerts/active'
          '?point=$latitude,$longitude';
      
      final response = await http.get(Uri.parse(alertsUrl));
      
      if (response.statusCode != 200) {
        return [];
      }

      final data = json.decode(response.body);
      final features = data['features'] as List<dynamic>? ?? [];
      
      return features.map((feature) {
        final properties = feature['properties'];
        return WeatherAlert(
          id: properties['id'] ?? '',
          title: properties['headline'] ?? '',
          description: properties['description'] ?? '',
          severity: properties['severity'] ?? 'Unknown',
          urgency: properties['urgency'] ?? 'Unknown',
          certainty: properties['certainty'] ?? 'Unknown',
          effective: DateTime.parse(properties['effective'] ?? DateTime.now().toIso8601String()),
          expires: DateTime.parse(properties['expires'] ?? DateTime.now().add(const Duration(hours: 24)).toIso8601String()),
          senderName: properties['senderName'] ?? 'National Weather Service',
          areas: List<String>.from(properties['areaDesc']?.split(';') ?? []),
          event: properties['event'] ?? '',
          headline: properties['headline'] ?? '',
          instruction: properties['instruction'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error fetching weather alerts: $e');
      return [];
    }
  }

  // Get radar data
  Future<List<RadarFrame>> getRadarData(double latitude, double longitude, {int frames = 10}) async {
    try {
      // This is a simplified implementation
      // In a real app, you would integrate with NOAA's radar API or a third-party service
      List<RadarFrame> radarFrames = [];
      
      for (int i = 0; i < frames; i++) {
        final timestamp = DateTime.now().subtract(Duration(minutes: i * 5));
        radarFrames.add(RadarFrame(
          imageUrl: 'https://radar.weather.gov/ridge/standard/CONUS_loop.gif',
          timestamp: timestamp,
          intensity: 0.5 + (i * 0.1), // Mock intensity data
        ));
      }
      
      return radarFrames.reversed.toList();
    } catch (e) {
      throw Exception('Error fetching radar data: $e');
    }
  }

  // Search for locations
  Future<List<Location>> searchLocations(String query) async {
    try {
      final geocodingUrl = 'http://api.openweathermap.org/geo/1.0/direct'
          '?q=$query&limit=5&appid=$_openWeatherMapApiKey';
      
      final response = await http.get(Uri.parse(geocodingUrl));
      
      if (response.statusCode != 200) {
        throw Exception('Failed to search locations');
      }

      final data = json.decode(response.body) as List<dynamic>;
      
      return data.map((item) => Location(
        name: item['name'] ?? '',
        state: item['state'] ?? '',
        country: item['country'] ?? '',
        latitude: (item['lat'] as num).toDouble(),
        longitude: (item['lon'] as num).toDouble(),
        timezone: 'UTC', // Would need additional API call for timezone
        timezoneOffset: 0,
      )).toList();
    } catch (e) {
      throw Exception('Error searching locations: $e');
    }
  }

  // Get current position
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Parse weather data from API responses
  WeatherData _parseWeatherData(
    Map<String, dynamic> currentData,
    Map<String, dynamic> forecastData,
    List<WeatherAlert> alerts,
    double latitude,
    double longitude,
  ) {
    // Parse current weather
    final current = CurrentWeather(
      temperature: (currentData['main']['temp'] as num).toDouble(),
      feelsLike: (currentData['main']['feels_like'] as num).toDouble(),
      humidity: currentData['main']['humidity'],
      pressure: (currentData['main']['pressure'] as num).toDouble(),
      windSpeed: (currentData['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      windDirection: currentData['wind']['deg'] ?? 0,
      visibility: (currentData['visibility'] as num?)?.toDouble() ?? 10000.0,
      dewPoint: _calculateDewPoint(
        (currentData['main']['temp'] as num).toDouble(),
        currentData['main']['humidity'],
      ),
      uvIndex: 0, // Would need additional API call
      condition: currentData['weather'][0]['main'],
      description: currentData['weather'][0]['description'],
      icon: currentData['weather'][0]['icon'],
      timestamp: DateTime.now(),
      precipitationProbability: 0.0, // Not available in current weather
      precipitationAmount: 0.0,
    );

    // Parse hourly forecast
    final hourlyList = forecastData['list'] as List<dynamic>;
    final hourly = hourlyList.take(24).map((item) => HourlyForecast(
      time: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
      temperature: (item['main']['temp'] as num).toDouble(),
      feelsLike: (item['main']['feels_like'] as num).toDouble(),
      humidity: item['main']['humidity'],
      windSpeed: (item['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      windDirection: item['wind']['deg'] ?? 0,
      condition: item['weather'][0]['main'],
      icon: item['weather'][0]['icon'],
      precipitationProbability: (item['pop'] as num?)?.toDouble() ?? 0.0,
      precipitationAmount: (item['rain']?['3h'] as num?)?.toDouble() ?? 0.0,
    )).toList();

    // Parse daily forecast (group by day)
    final daily = _groupHourlyToDaily(hourlyList);

    // Create location
    final location = Location(
      name: currentData['name'],
      state: '',
      country: currentData['sys']['country'],
      latitude: latitude,
      longitude: longitude,
      timezone: 'UTC',
      timezoneOffset: currentData['timezone'],
    );

    return WeatherData(
      current: current,
      hourly: hourly,
      daily: daily,
      alerts: alerts,
      location: location,
    );
  }

  // Group hourly forecast into daily forecast
  List<DailyForecast> _groupHourlyToDaily(List<dynamic> hourlyList) {
    final Map<String, List<dynamic>> dailyGroups = {};
    
    for (final item in hourlyList) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dateKey = '${date.year}-${date.month}-${date.day}';
      
      if (!dailyGroups.containsKey(dateKey)) {
        dailyGroups[dateKey] = [];
      }
      dailyGroups[dateKey]!.add(item);
    }

    return dailyGroups.entries.take(7).map((entry) {
      final dayData = entry.value;
      final date = DateTime.fromMillisecondsSinceEpoch(dayData.first['dt'] * 1000);
      
      final temperatures = dayData.map((item) => (item['main']['temp'] as num).toDouble()).toList();
      final highTemp = temperatures.reduce((a, b) => a > b ? a : b);
      final lowTemp = temperatures.reduce((a, b) => a < b ? a : b);
      
      final midDayItem = dayData[dayData.length ~/ 2];
      
      return DailyForecast(
        date: date,
        highTemperature: highTemp,
        lowTemperature: lowTemp,
        humidity: midDayItem['main']['humidity'],
        windSpeed: (midDayItem['wind']['speed'] as num?)?.toDouble() ?? 0.0,
        windDirection: midDayItem['wind']['deg'] ?? 0,
        condition: midDayItem['weather'][0]['main'],
        description: midDayItem['weather'][0]['description'],
        icon: midDayItem['weather'][0]['icon'],
        precipitationProbability: (midDayItem['pop'] as num?)?.toDouble() ?? 0.0,
        precipitationAmount: (midDayItem['rain']?['3h'] as num?)?.toDouble() ?? 0.0,
        sunrise: DateTime.fromMillisecondsSinceEpoch(dayData.first['sys']?['sunrise'] * 1000 ?? date.millisecondsSinceEpoch),
        sunset: DateTime.fromMillisecondsSinceEpoch(dayData.first['sys']?['sunset'] * 1000 ?? date.add(const Duration(hours: 12)).millisecondsSinceEpoch),
        uvIndex: 0, // Would need additional API call
      );
    }).toList();
  }

  // Calculate dew point
  double _calculateDewPoint(double temperature, int humidity) {
    final a = 17.27;
    final b = 237.7;
    final alpha = ((a * temperature) / (b + temperature)) + (humidity / 100.0).log();
    return (b * alpha) / (a - alpha);
  }
}

extension on double {
  double log() => math.log(this);
}