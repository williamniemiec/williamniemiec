import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_theme.dart';
import '../models/blood_pressure_reading.dart';

class LatestReadingCard extends StatelessWidget {
  final BloodPressureReading? reading;

  const LatestReadingCard({
    super.key,
    this.reading,
  });

  @override
  Widget build(BuildContext context) {
    if (reading == null) {
      return _buildEmptyCard(context);
    }

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
          gradient: LinearGradient(
            colors: [
              _getCategoryColor(reading!.category).withOpacity(0.1),
              _getCategoryColor(reading!.category).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date and category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reading!.formattedDateTime,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.smallSpacing,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(reading!.category),
                    borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                  ),
                  child: Text(
                    reading!.category.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            
            // Blood pressure values
            Row(
              children: [
                Expanded(
                  child: _buildValueCard(
                    context,
                    'Systolic',
                    '${reading!.systolic}',
                    'mmHg',
                    Icons.arrow_upward,
                    Colors.red[400]!,
                  ),
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: _buildValueCard(
                    context,
                    'Diastolic',
                    '${reading!.diastolic}',
                    'mmHg',
                    Icons.arrow_downward,
                    Colors.blue[400]!,
                  ),
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: _buildValueCard(
                    context,
                    'Pulse',
                    '${reading!.pulse}',
                    'bpm',
                    Icons.favorite,
                    Colors.pink[400]!,
                  ),
                ),
              ],
            ),
            
            // Tags if available
            if (reading!.tags.isNotEmpty) ...[
              const SizedBox(height: AppConstants.mediumSpacing),
              Wrap(
                spacing: AppConstants.smallSpacing,
                runSpacing: 4,
                children: reading!.tags.map((tag) => Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.grey[100],
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ],
            
            // Notes if available
            if (reading!.notes != null && reading!.notes!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.mediumSpacing),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.smallSpacing),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reading!.notes!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.largeSpacing),
        child: Column(
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            Text(
              'No readings yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppConstants.smallSpacing),
            Text(
              'Tap the + button to add your first blood pressure reading',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(
    BuildContext context,
    String label,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: AppConstants.mediumIconSize,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(BloodPressureCategory category) {
    switch (category) {
      case BloodPressureCategory.normal:
        return AppTheme.normalColor;
      case BloodPressureCategory.elevated:
        return AppTheme.elevatedColor;
      case BloodPressureCategory.hypertensionStage1:
        return AppTheme.hypertensionStage1Color;
      case BloodPressureCategory.hypertensionStage2:
        return AppTheme.hypertensionStage2Color;
      case BloodPressureCategory.hypertensiveCrisis:
        return AppTheme.hypertensiveCrisisColor;
    }
  }
}