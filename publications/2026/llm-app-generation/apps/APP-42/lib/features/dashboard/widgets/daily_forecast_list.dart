import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';

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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: dailyForecast.asMap().entries.map((entry) {
          final index = entry.key;
          final forecast = entry.value;
          final isToday = index == 0;
          final isLast = index == dailyForecast.length - 1;
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: isLast ? null : Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Day of week
                Expanded(
                  flex: 2,
                  child: Text(
                    isToday ? 'Today' : DateFormat('EEEE').format(forecast.date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                      color: isToday ? AppTheme.primaryBlue : null,
                    ),
                  ),
                ),
                
                // Weather icon and condition
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        _getWeatherIcon(forecast.condition),
                        size: 24,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          forecast.condition,
                          style: Theme.of(context).textTheme.bodyMedium,
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
                          size: 16,
                          color: AppTheme.lightBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(forecast.precipitationProbability * 100).round()}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightBlue,
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
                        '${forecast.lowTemperature.round()}°',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.lightBlue.withOpacity(0.3),
                              AppTheme.primaryBlue,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${forecast.highTemperature.round()}°',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
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