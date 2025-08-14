import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApi {
  final String apiKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  WeatherApi(this.apiKey);

  Future<Map<String, dynamic>> getWeatherData(double lat, double lon) async {
    final url = '$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getForecastData(double lat, double lon) async {
    final url = '$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load forecast data');
    }
  }
}