import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/weather_data.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> dailyForecast;

  const DailyForecastList({
    super.key,
    required this.dailyForecast,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyForecast.isEmpty) {
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
                      Icons.calendar_today,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${dailyForecast.length}-Day Forecast',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.defaultPadding),
                
                // Daily forecast list
                ...dailyForecast.asMap().entries.map((entry) {
                  final index = entry.key;
                  final forecast = entry.value;
                  final isToday = index == 0;
                  
                  return Column(
                    children: [
                      _buildDayForecastItem(
                        context,
                        appProvider,
                        forecast,
                        isToday,
                      ),
                      if (index < dailyForecast.length - 1)
                        Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor.withOpacity(0.3),
                        ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayForecastItem(
    BuildContext context,
    AppProvider appProvider,
    DailyForecast forecast,
    bool isToday,
  ) {
    final highTemp = appProvider.convertTemperature(forecast.highTemperature);
    final lowTemp = appProvider.convertTemperature(forecast.lowTemperature);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Day name
          Expanded(
            flex: 2,
            child: Text(
              isToday ? 'Today' : DateFormat('EEEE').format(forecast.date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isToday 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          
          // Weather icon and condition
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.getWeatherConditionColor(forecast.condition)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getWeatherIcon(forecast.iconCode),
                    size: 20,
                    color: AppTheme.getWeatherConditionColor(forecast.condition),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _capitalizeWords(forecast.condition),
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // Precipitation probability
          if (forecast.precipitationProbability > 0)
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 14,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${forecast.precipitationProbability.round()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            const Expanded(flex: 1, child: SizedBox()),
          
          // Temperature range
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${lowTemp.round()}°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.3),
                        AppTheme.getWeatherConditionColor(forecast.condition).withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${highTemp.round()}°',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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

  String _capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}