import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/weather_data.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherData weatherData;

  const CurrentWeatherCard({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final current = weatherData.current;
        final temperature = appProvider.convertTemperature(current.temperature);
        final feelsLike = appProvider.convertTemperature(current.feelsLike);
        
        return Card(
          elevation: AppConstants.cardElevation,
          child: Container(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.getWeatherConditionColor(current.condition).withOpacity(0.1),
                  AppTheme.getWeatherConditionColor(current.condition).withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main temperature and condition
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Temperature
                          Text(
                            '${temperature.round()}${appProvider.getTemperatureUnitSymbol()}',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.w300,
                              height: 1.0,
                            ),
                          ),
                          
                          // Feels like
                          Text(
                            'Feels like ${feelsLike.round()}${appProvider.getTemperatureUnitSymbol()}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Condition
                          Text(
                            _capitalizeWords(current.description),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Weather icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.getWeatherConditionColor(current.condition).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        _getWeatherIcon(current.iconCode),
                        size: 48,
                        color: AppTheme.getWeatherConditionColor(current.condition),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.defaultPadding),
                
                // Weather details grid
                Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: Column(
                    children: [
                      // First row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              context,
                              Icons.water_drop,
                              'Humidity',
                              '${current.humidity.round()}%',
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              context,
                              Icons.air,
                              'Wind',
                              '${appProvider.convertWindSpeed(current.windSpeed).round()} ${appProvider.getWindSpeedUnitSymbol()}',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: AppConstants.defaultPadding),
                      
                      // Second row
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              context,
                              Icons.compress,
                              'Pressure',
                              '${appProvider.convertPressure(current.pressure).round()} ${appProvider.getPressureUnitSymbol()}',
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              context,
                              Icons.visibility,
                              'Visibility',
                              '${current.visibility.toStringAsFixed(1)} km',
                            ),
                          ),
                        ],
                      ),
                      
                      if (current.uvIndex > 0) ...[
                        const SizedBox(height: AppConstants.defaultPadding),
                        
                        // Third row
                        Row(
                          children: [
                            Expanded(
                              child: _buildDetailItem(
                                context,
                                Icons.wb_sunny,
                                'UV Index',
                                '${current.uvIndex} (${AppConstants.uvIndexDescriptions[current.uvIndex] ?? 'Unknown'})',
                                valueColor: AppTheme.getUVIndexColor(current.uvIndex),
                              ),
                            ),
                            Expanded(
                              child: _buildDetailItem(
                                context,
                                Icons.navigation,
                                'Wind Dir',
                                '${current.windDirection}° ${_getWindDirection(current.windDirection)}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: AppConstants.smallPadding),
                
                // Last updated
                Text(
                  'Updated ${DateFormat('HH:mm').format(current.timestamp)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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

  String _getWindDirection(int degrees) {
    const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((degrees + 22.5) / 45).floor() % 8;
    return directions[index];
  }

  String _capitalizeWords(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}