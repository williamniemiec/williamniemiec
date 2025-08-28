import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> hourlyForecast;

  const HourlyForecastList({
    super.key,
    required this.hourlyForecast,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyForecast.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyForecast.length,
        itemBuilder: (context, index) {
          final forecast = hourlyForecast[index];
          final isNow = index == 0;
          
          return Container(
            width: 80,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isNow ? AppTheme.primaryBlue : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Time
                  Text(
                    isNow ? 'Now' : DateFormat('h a').format(forecast.time),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isNow ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  // Weather icon
                  Icon(
                    _getWeatherIcon(forecast.condition),
                    size: 24,
                    color: isNow ? Colors.white : AppTheme.primaryBlue,
                  ),
                  
                  // Temperature
                  Text(
                    '${forecast.temperature.round()}°',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isNow ? Colors.white : Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  
                  // Precipitation probability
                  if (forecast.precipitationProbability > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 10,
                          color: isNow ? Colors.white.withOpacity(0.8) : AppTheme.lightBlue,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${(forecast.precipitationProbability * 100).round()}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isNow ? Colors.white.withOpacity(0.8) : AppTheme.lightBlue,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.cloud;
      default:
        return Icons.wb_sunny;
    }
  }
}