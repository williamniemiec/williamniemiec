import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/weather_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';
import '../widgets/alert_card.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Alerts'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final alerts = weatherProvider.activeAlerts;
          
          if (alerts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: AppTheme.successGreen,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Active Alerts',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.successGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'There are currently no weather alerts for your area.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Sort alerts by severity and effective time
          final sortedAlerts = List<WeatherAlert>.from(alerts);
          sortedAlerts.sort((a, b) {
            // First sort by severity
            final severityOrder = {'extreme': 0, 'severe': 1, 'moderate': 2, 'minor': 3};
            final aSeverity = severityOrder[a.severity.toLowerCase()] ?? 4;
            final bSeverity = severityOrder[b.severity.toLowerCase()] ?? 4;
            
            if (aSeverity != bSeverity) {
              return aSeverity.compareTo(bSeverity);
            }
            
            // Then sort by effective time (most recent first)
            return b.effective.compareTo(a.effective);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedAlerts.length,
            itemBuilder: (context, index) {
              final alert = sortedAlerts[index];
              return AlertCard(
                alert: alert,
                onTap: () => _showAlertDetails(context, alert),
              );
            },
          );
        },
      ),
    );
  }

  void _showAlertDetails(BuildContext context, WeatherAlert alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AlertDetailsSheet(alert: alert),
    );
  }
}

class _AlertDetailsSheet extends StatelessWidget {
  final WeatherAlert alert;

  const _AlertDetailsSheet({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getAlertColor(alert.severity),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getAlertIcon(alert.event),
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        alert.event.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  alert.headline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alert info
                  _buildInfoRow(context, 'Severity', alert.severity.toUpperCase()),
                  _buildInfoRow(context, 'Urgency', alert.urgency.toUpperCase()),
                  _buildInfoRow(context, 'Certainty', alert.certainty.toUpperCase()),
                  _buildInfoRow(
                    context,
                    'Effective',
                    DateFormat('MMM d, yyyy h:mm a').format(alert.effective),
                  ),
                  _buildInfoRow(
                    context,
                    'Expires',
                    DateFormat('MMM d, yyyy h:mm a').format(alert.expires),
                  ),
                  _buildInfoRow(context, 'Issued by', alert.senderName),
                  
                  if (alert.areas.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Affected Areas',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.areas.join(', '),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  
                  if (alert.instruction.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.sunnyYellow.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.sunnyYellow.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        alert.instruction,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
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