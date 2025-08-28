import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/weather_data.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class HourlyForecastCarousel extends StatelessWidget {
  final List<HourlyForecast> hourlyForecast;

  const HourlyForecastCarousel({
    super.key,
    required this.hourlyForecast,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyForecast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Card(
          elevation: AppConstants.cardElevation,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hourly Forecast',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.defaultPadding),
                
                // Horizontal scrollable forecast
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: hourlyForecast.length,
                    itemBuilder: (context, index) {
                      final forecast = hourlyForecast[index];
                      final temperature = appProvider.convertTemperature(forecast.temperature);
                      final isNow = index == 0;
                      
                      return Container(
                        width: 80,
                        margin: EdgeInsets.only(
                          right: index < hourlyForecast.length - 1 ? 12 : 0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Time
                            Text(
                              isNow ? 'Now' : DateFormat('HH:mm').format(forecast.time),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: isNow ? FontWeight.bold : FontWeight.normal,
                                color: isNow 
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).textTheme.bodySmall?.color,
                              ),
                            ),
                            
                            // Weather icon
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.getWeatherConditionColor(forecast.condition)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                _getWeatherIcon(forecast.iconCode),
                                size: 24,
                                color: AppTheme.getWeatherConditionColor(forecast.condition),
                              ),
                            ),
                            
                            // Precipitation probability
                            if (forecast.precipitationProbability > 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.water_drop,
                                    size: 12,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${forecast.precipitationProbability.round()}%',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              )
                            else
                              const SizedBox(height: 16),
                            
                            // Temperature
                            Text(
                              '${temperature.round()}°',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
      case '01n':
        return Icons.wb_sunny;
      case '02d':
      case '02n':
        return Icons.wb_cloudy;
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return Icons.cloud;
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return Icons.grain;
      case '11d':
      case '11n':
        return Icons.thunderstorm;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }
}