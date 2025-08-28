import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class ContributeScreen extends StatelessWidget {
  const ContributeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribute'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        child: Column(
          children: [
            _buildContributeOption(
              context,
              'Add a missing place',
              'Help others discover new places',
              Icons.add_location,
              () => _showComingSoon(context),
            ),
            _buildContributeOption(
              context,
              'Edit place info',
              'Update hours, phone numbers, and more',
              Icons.edit_location,
              () => _showComingSoon(context),
            ),
            _buildContributeOption(
              context,
              'Add photos',
              'Share photos of places you\'ve visited',
              Icons.add_a_photo,
              () => _showComingSoon(context),
            ),
            _buildContributeOption(
              context,
              'Write a review',
              'Share your experience with others',
              Icons.rate_review,
              () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContributeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryBlue,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }
}