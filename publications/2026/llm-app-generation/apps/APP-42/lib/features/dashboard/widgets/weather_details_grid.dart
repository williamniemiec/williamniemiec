import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final CurrentWeather currentWeather;

  const WeatherDetailsGrid({
    super.key,
    required this.currentWeather,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _buildDetailCard(
            context,
            'Feels Like',
            '${currentWeather.feelsLike.round()}°F',
            Icons.thermostat,
            AppTheme.sunnyYellow,
          ),
          _buildDetailCard(
            context,
            'Humidity',
            '${currentWeather.humidity}%',
            Icons.water_drop,
            AppTheme.lightBlue,
          ),
          _buildDetailCard(
            context,
            'Wind Speed',
            '${currentWeather.windSpeed.round()} mph',
            Icons.air,
            AppTheme.cloudyGray,
          ),
          _buildDetailCard(
            context,
            'Wind Direction',
            _getWindDirection(currentWeather.windDirection),
            Icons.navigation,
            AppTheme.cloudyGray,
          ),
          _buildDetailCard(
            context,
            'Pressure',
            '${(currentWeather.pressure * 0.02953).toStringAsFixed(2)} inHg',
            Icons.speed,
            AppTheme.primaryBlue,
          ),
          _buildDetailCard(
            context,
            'Visibility',
            '${(currentWeather.visibility * 0.000621371).toStringAsFixed(1)} mi',
            Icons.visibility,
            AppTheme.successGreen,
          ),
          _buildDetailCard(
            context,
            'Dew Point',
            '${currentWeather.dewPoint.round()}°F',
            Icons.water,
            AppTheme.lightBlue,
          ),
          _buildDetailCard(
            context,
            'UV Index',
            '${currentWeather.uvIndex} ${_getUVDescription(currentWeather.uvIndex)}',
            Icons.wb_sunny,
            _getUVColor(currentWeather.uvIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  String _getWindDirection(int degrees) {
    const directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];
    final index = ((degrees + 11.25) / 22.5).floor() % 16;
    return '${directions[index]} ($degrees°)';
  }

  String _getUVDescription(int uvIndex) {
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  Color _getUVColor(int uvIndex) {
    if (uvIndex <= 2) return AppTheme.successGreen;
    if (uvIndex <= 5) return AppTheme.sunnyYellow;
    if (uvIndex <= 7) return AppTheme.accentOrange;
    if (uvIndex <= 10) return AppTheme.warningRed;
    return AppTheme.stormPurple;
  }
}