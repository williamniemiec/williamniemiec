import 'package:atmos_weather/api/weather_api.dart';
import 'package:atmos_weather/models/current_weather.dart';
import 'package:atmos_weather/models/daily_forecast.dart';
import 'package:atmos_weather/models/hourly_forecast.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  final WeatherApi weatherApi;

  WeatherService(this.weatherApi);

  Future<Map<String, dynamic>> getWeatherData() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final weatherData =
          await weatherApi.getWeatherData(position.latitude, position.longitude);
      final forecastData = await weatherApi.getForecastData(
          position.latitude, position.longitude);

      final currentWeather = CurrentWeather.fromJson(weatherData);
      final hourlyForecast = (forecastData['list'] as List)
          .map((item) => HourlyForecast.fromJson(item))
          .toList();
      // The free OpenWeatherMap API for 5 day / 3 hour forecast doesn't directly provide a simple daily forecast.
      // We can process the hourly data to create a daily summary.
      final dailyForecast = _processHourlyDataForDailyForecast(hourlyForecast);

      return {
        'currentWeather': currentWeather,
        'hourlyForecast': hourlyForecast,
        'dailyForecast': dailyForecast,
      };
    } catch (e) {
      // In a real app, you'd want to handle this error more gracefully.
      // For example, by showing a message to the user.
      rethrow;
    }
  }

  List<DailyForecast> _processHourlyDataForDailyForecast(
      List<HourlyForecast> hourly) {
    final Map<int, List<HourlyForecast>> groupedByDay = {};
    for (var forecast in hourly) {
      final day = forecast.time.day;
      if (groupedByDay[day] == null) {
        groupedByDay[day] = [];
      }
      groupedByDay[day]!.add(forecast);
    }

    final List<DailyForecast> daily = [];
    groupedByDay.forEach((day, forecasts) {
      if (forecasts.isNotEmpty) {
        double maxTemp = forecasts
            .map((f) => f.temp)
            .reduce((a, b) => a > b ? a : b);
        double minTemp = forecasts
            .map((f) => f.temp)
            .reduce((a, b) => a < b ? a : b);
        // Use the icon from the forecast around noon for a representative icon
        String icon = forecasts
            .firstWhere((f) => f.time.hour >= 12, orElse: () => forecasts.first)
            .icon;

        daily.add(DailyForecast(
          date: forecasts.first.time,
          tempMax: maxTemp,
          tempMin: minTemp,
          icon: icon,
        ));
      }
    });
    return daily;
  }
}