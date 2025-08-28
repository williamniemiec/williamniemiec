import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ServicesPanel extends StatelessWidget {
  const ServicesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingM),
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: _ServiceButton(
                  icon: Icons.directions_car,
                  title: 'Ride',
                  subtitle: 'Go anywhere',
                  onTap: () {
                    // Already on ride screen
                  },
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _ServiceButton(
                  icon: Icons.restaurant,
                  title: 'Food',
                  subtitle: 'Order delivery',
                  onTap: () {
                    _showComingSoon(context, 'Uber Eats');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: [
              Expanded(
                child: _ServiceButton(
                  icon: Icons.local_shipping,
                  title: 'Package',
                  subtitle: 'Send items',
                  onTap: () {
                    _showComingSoon(context, 'Uber Connect');
                  },
                ),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: _ServiceButton(
                  icon: Icons.schedule,
                  title: 'Reserve',
                  subtitle: 'Schedule a ride',
                  onTap: () {
                    _showComingSoon(context, 'Reserve a Ride');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$service Coming Soon'),
        content: Text('$service will be available in a future update.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _ServiceButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingS),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(AppConstants.radiusS),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: AppConstants.iconM,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}