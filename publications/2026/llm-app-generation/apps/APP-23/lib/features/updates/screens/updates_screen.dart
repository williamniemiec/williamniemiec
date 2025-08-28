import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updates'),
      ),
      body: _buildEmptyState(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: AppTheme.hintTextColor,
            ),
            const SizedBox(height: AppConstants.spacingM),
            Text(
              'No updates yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'You\'ll see messages from businesses and recommendations here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.hintTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}