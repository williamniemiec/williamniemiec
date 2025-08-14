import 'package:atmos_weather/api/weather_api.dart';
import 'package:atmos_weather/constants.dart';
import 'package:atmos_weather/models/current_weather.dart';
import 'package:atmos_weather/models/daily_forecast.dart';
import 'package:atmos_weather/models/hourly_forecast.dart';
import 'package:atmos_weather/screens/location_screen.dart';
import 'package:atmos_weather/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainWeatherScreen extends StatefulWidget {
  const MainWeatherScreen({super.key});

  @override
  State<MainWeatherScreen> createState() => _MainWeatherScreenState();
}

class _MainWeatherScreenState extends State<MainWeatherScreen> {
  final WeatherService _weatherService = WeatherService(WeatherApi(openWeatherApiKey));
  CurrentWeather? _currentWeather;
  List<HourlyForecast>? _hourlyForecast;
  List<DailyForecast>? _dailyForecast;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final weatherData = await _weatherService.getWeatherData();
      setState(() {
        _currentWeather = weatherData['currentWeather'];
        _hourlyForecast = weatherData['hourlyForecast'];
        _dailyForecast = weatherData['dailyForecast'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load weather data. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atmos Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchWeatherData,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_currentWeather == null) {
      return const Center(child: Text('No weather data available.'));
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCurrentWeather(),
          const SizedBox(height: 20),
          _buildHourlyForecast(),
          const SizedBox(height: 20),
          _buildDailyForecast(),
        ],
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Porto Alegre', // Placeholder
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            '${_currentWeather!.temp.round()}°C',
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w200),
          ),
          Text(
            _currentWeather!.description.isNotEmpty
                ? '${_currentWeather!.description[0].toUpperCase()}${_currentWeather!.description.substring(1)}'
                : '',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDetailCard('Feels Like', '${_currentWeather!.feelsLike.round()}°'),
              _buildDetailCard('Wind', '${_currentWeather!.windSpeed} m/s'),
              _buildDetailCard('Humidity', '${_currentWeather!.humidity}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Hourly Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _hourlyForecast?.length ?? 0,
            itemBuilder: (context, index) {
              final forecast = _hourlyForecast![index];
              return Container(
                width: 80,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(DateFormat.j().format(forecast.time)),
                        Image.network('https://openweathermap.org/img/wn/${forecast.icon}.png', width: 40, height: 40),
                        Text('${forecast.temp.round()}°'),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Weekly Forecast', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dailyForecast?.length ?? 0,
            itemBuilder: (context, index) {
              final forecast = _dailyForecast![index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: Image.network('https://openweathermap.org/img/wn/${forecast.icon}.png'),
                  title: Text(DateFormat.EEEE().format(forecast.date)),
                  trailing: Text('${forecast.tempMax.round()}° / ${forecast.tempMin.round()}°'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}