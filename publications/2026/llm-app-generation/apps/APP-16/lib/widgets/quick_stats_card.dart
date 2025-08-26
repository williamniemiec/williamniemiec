import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/blood_pressure_reading.dart';

class QuickStatsCard extends StatelessWidget {
  final List<BloodPressureReading> readings;

  const QuickStatsCard({
    super.key,
    required this.readings,
  });

  @override
  Widget build(BuildContext context) {
    if (readings.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              Text(
                'No statistics available',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add some readings to see your stats',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final stats = _calculateStats();
    final recentReadings = _getRecentReadings(7); // Last 7 days
    final categoryDistribution = _getCategoryDistribution();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall averages
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Avg Systolic',
                    '${stats['avgSystolic']?.round() ?? 0}',
                    'mmHg',
                    Icons.arrow_upward,
                    Colors.red[400]!,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Avg Diastolic',
                    '${stats['avgDiastolic']?.round() ?? 0}',
                    'mmHg',
                    Icons.arrow_downward,
                    Colors.blue[400]!,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Avg Pulse',
                    '${stats['avgPulse']?.round() ?? 0}',
                    'bpm',
                    Icons.favorite,
                    Colors.pink[400]!,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.mediumSpacing),
            const Divider(),
            const SizedBox(height: AppConstants.mediumSpacing),
            
            // Recent activity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  context,
                  'Total Readings',
                  '${readings.length}',
                  Icons.list_alt,
                ),
                _buildInfoItem(
                  context,
                  'This Week',
                  '${recentReadings.length}',
                  Icons.calendar_today,
                ),
                _buildInfoItem(
                  context,
                  'Most Common',
                  _getMostCommonCategory(),
                  Icons.category,
                ),
              ],
            ),
            
            // Category distribution (if there are multiple categories)
            if (categoryDistribution.length > 1) ...[
              const SizedBox(height: AppConstants.mediumSpacing),
              const Divider(),
              const SizedBox(height: AppConstants.mediumSpacing),
              Text(
                'Category Distribution',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              ...categoryDistribution.entries.map((entry) {
                final percentage = (entry.value / readings.length * 100).round();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(entry.key),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallSpacing),
                      Expanded(
                        child: Text(
                          entry.key.displayName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: AppConstants.mediumIconSize,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: AppConstants.mediumIconSize,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Map<String, double> _calculateStats() {
    if (readings.isEmpty) {
      return {'avgSystolic': 0.0, 'avgDiastolic': 0.0, 'avgPulse': 0.0};
    }

    final totalSystolic = readings.fold<int>(0, (sum, reading) => sum + reading.systolic);
    final totalDiastolic = readings.fold<int>(0, (sum, reading) => sum + reading.diastolic);
    final totalPulse = readings.fold<int>(0, (sum, reading) => sum + reading.pulse);

    return {
      'avgSystolic': totalSystolic / readings.length,
      'avgDiastolic': totalDiastolic / readings.length,
      'avgPulse': totalPulse / readings.length,
    };
  }

  List<BloodPressureReading> _getRecentReadings(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return readings.where((reading) => reading.dateTime.isAfter(cutoffDate)).toList();
  }

  Map<BloodPressureCategory, int> _getCategoryDistribution() {
    final distribution = <BloodPressureCategory, int>{};
    
    for (final reading in readings) {
      distribution[reading.category] = (distribution[reading.category] ?? 0) + 1;
    }
    
    return distribution;
  }

  String _getMostCommonCategory() {
    final distribution = _getCategoryDistribution();
    if (distribution.isEmpty) return 'None';
    
    final mostCommon = distribution.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    
    return mostCommon.key.displayName;
  }

  Color _getCategoryColor(BloodPressureCategory category) {
    switch (category) {
      case BloodPressureCategory.normal:
        return Colors.green;
      case BloodPressureCategory.elevated:
        return Colors.orange;
      case BloodPressureCategory.hypertensionStage1:
        return Colors.deepOrange;
      case BloodPressureCategory.hypertensionStage2:
        return Colors.red;
      case BloodPressureCategory.hypertensiveCrisis:
        return Colors.purple;
    }
  }
}