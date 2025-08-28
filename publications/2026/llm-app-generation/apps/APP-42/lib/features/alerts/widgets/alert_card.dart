import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';

class AlertCard extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback? onTap;

  const AlertCard({
    super.key,
    required this.alert,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _getAlertColor(alert.severity).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getAlertColor(alert.severity).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getAlertColor(alert.severity),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getAlertIcon(alert.event),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.event.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getAlertColor(alert.severity),
                            ),
                          ),
                          Text(
                            alert.severity.toUpperCase(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getAlertColor(alert.severity).withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Expires',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          DateFormat('MMM d, h:mm a').format(alert.expires),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Headline
                Text(
                  alert.headline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (alert.areas.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          alert.areas.take(2).join(', ') + 
                              (alert.areas.length > 2 ? ' and ${alert.areas.length - 2} more' : ''),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 12),
                
                // Footer with time info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Issued ${_getTimeAgo(alert.effective)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    if (onTap != null)
                      Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4),
                      ),
                  ],
                ),
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}