import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';
import '../../alerts/screens/alerts_screen.dart';

class WeatherAlertsBanner extends StatelessWidget {
  final List<WeatherAlert> alerts;

  const WeatherAlertsBanner({
    super.key,
    required this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const SizedBox.shrink();
    }

    final severeAlerts = alerts.where((alert) => alert.isSevere).toList();
    final mostUrgentAlert = severeAlerts.isNotEmpty ? severeAlerts.first : alerts.first;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getAlertColor(mostUrgentAlert.severity),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: _getAlertColor(mostUrgentAlert.severity).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AlertsScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getAlertIcon(mostUrgentAlert.event),
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mostUrgentAlert.event.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Expires ${DateFormat('MMM d, h:mm a').format(mostUrgentAlert.expires)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (alerts.length > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${alerts.length - 1}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white.withOpacity(0.8),
                      size: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  mostUrgentAlert.headline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (mostUrgentAlert.areas.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Areas: ${mostUrgentAlert.areas.take(3).join(', ')}${mostUrgentAlert.areas.length > 3 ? '...' : ''}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAlertColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'extreme':
        return AppTheme.stormPurple;
      case 'severe':
        return AppTheme.warningRed;
      case 'moderate':
        return AppTheme.accentOrange;
      case 'minor':
        return AppTheme.sunnyYellow;
      default:
        return AppTheme.primaryBlue;
    }
  }

  IconData _getAlertIcon(String event) {
    final eventLower = event.toLowerCase();
    
    if (eventLower.contains('tornado')) {
      return Icons.cyclone;
    } else if (eventLower.contains('hurricane')) {
      return Icons.cyclone;
    } else if (eventLower.contains('thunderstorm') || eventLower.contains('storm')) {
      return Icons.flash_on;
    } else if (eventLower.contains('flood')) {
      return Icons.waves;
    } else if (eventLower.contains('fire')) {
      return Icons.local_fire_department;
    } else if (eventLower.contains('winter') || eventLower.contains('snow') || eventLower.contains('ice')) {
      return Icons.ac_unit;
    } else if (eventLower.contains('wind')) {
      return Icons.air;
    } else if (eventLower.contains('heat')) {
      return Icons.wb_sunny;
    } else if (eventLower.contains('freeze') || eventLower.contains('cold')) {
      return Icons.ac_unit;
    } else {
      return Icons.warning;
    }
  }
}