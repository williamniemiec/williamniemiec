import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/weather_data.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherMetricsGrid({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        final current = weatherData.current;
        final metrics = weatherData.metrics;
        final dailyForecast = weatherData.dailyForecast.isNotEmpty 
            ? weatherData.dailyForecast.first 
            : null;

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
                      Icons.analytics,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Weather Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.defaultPadding),
                
                // Metrics grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: AppConstants.defaultPadding,
                  mainAxisSpacing: AppConstants.defaultPadding,
                  children: [
                    // Air Quality
                    _buildMetricCard(
                      context,
                      Icons.air,
                      'Air Quality',
                      metrics.airQualityDescription.isNotEmpty 
                          ? metrics.airQualityDescription
                          : 'AQI ${metrics.airQualityIndex}',
                      _getAQISubtitle(metrics.airQualityIndex),
                      AppTheme.getAQIColor(metrics.airQualityIndex),
                    ),
                    
                    // UV Index
                    _buildMetricCard(
                      context,
                      Icons.wb_sunny,
                      'UV Index',
                      '${current.uvIndex}',
                      AppConstants.uvIndexDescriptions[current.uvIndex] ?? 'Unknown',
                      AppTheme.getUVIndexColor(current.uvIndex),
                    ),
                    
                    // Sunrise/Sunset
                    if (dailyForecast != null)
                      _buildMetricCard(
                        context,
                        Icons.wb_twilight,
                        'Sun Times',
                        DateFormat('HH:mm').format(dailyForecast.sunrise),
                        '↓ ${DateFormat('HH:mm').format(dailyForecast.sunset)}',
                        AppTheme.sunnyColor,
                      ),
                    
                    // Dew Point
                    _buildMetricCard(
                      context,
                      Icons.water_drop,
                      'Dew Point',
                      '${appProvider.convertTemperature(metrics.dewPoint).round()}${appProvider.getTemperatureUnitSymbol()}',
                      _getDewPointDescription(metrics.dewPoint),
                      Colors.blue,
                    ),
                    
                    // Moon Phase
                    if (metrics.moonPhase.isNotEmpty)
                      _buildMetricCard(
                        context,
                        Icons.nightlight_round,
                        'Moon Phase',
                        metrics.moonPhase,
                        '${(metrics.moonIllumination * 100).round()}% illuminated',
                        Colors.grey,
                      ),
                    
                    // Pollen (if available)
                    if (metrics.pollenCount > 0)
                      _buildMetricCard(
                        context,
                        Icons.local_florist,
                        'Pollen',
                        '${metrics.pollenCount}',
                        metrics.pollenDescription.isNotEmpty 
                            ? metrics.pollenDescription 
                            : 'Count',
                        _getPollenColor(metrics.pollenCount),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    String subtitle,
    Color accentColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and title
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: accentColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          // Value
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          
          // Subtitle
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getAQISubtitle(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  String _getDewPointDescription(double dewPoint) {
    if (dewPoint < 10) return 'Very dry';
    if (dewPoint < 13) return 'Dry';
    if (dewPoint < 16) return 'Comfortable';
    if (dewPoint < 18) return 'Slightly humid';
    if (dewPoint < 21) return 'Humid';
    if (dewPoint < 24) return 'Very humid';
    return 'Oppressive';
  }

  Color _getPollenColor(int pollenCount) {
    if (pollenCount < 3) return Colors.green;
    if (pollenCount < 6) return Colors.yellow;
    if (pollenCount < 9) return Colors.orange;
    return Colors.red;
  }
}