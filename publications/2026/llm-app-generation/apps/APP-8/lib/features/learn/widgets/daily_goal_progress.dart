import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class DailyGoalProgress extends StatelessWidget {
  final int currentXP;
  final int goalXP;

  const DailyGoalProgress({
    super.key,
    required this.currentXP,
    required this.goalXP,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goalXP > 0 ? currentXP / goalXP : 0.0;
    final isCompleted = currentXP >= goalXP;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppConstants.gray.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isCompleted ? AppConstants.primaryGreen : AppConstants.black,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isCompleted ? AppConstants.primaryGreen : AppConstants.gray,
                    size: 20,
                  ),
                  const SizedBox(width: AppConstants.spacingXS),
                  Text(
                    '$currentXP / $goalXP XP',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isCompleted ? AppConstants.primaryGreen : AppConstants.darkGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingS),
          
          // Progress bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppConstants.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isCompleted ? AppConstants.primaryGreen : AppConstants.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          if (isCompleted) ...[
            const SizedBox(height: AppConstants.spacingS),
            Row(
              children: [
                Icon(
                  Icons.celebration,
                  color: AppConstants.primaryGreen,
                  size: 16,
                ),
                const SizedBox(width: AppConstants.spacingXS),
                Text(
                  'Goal completed! Great job!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppConstants.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}