import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user.dart';

class TopBar extends StatelessWidget {
  final User user;

  const TopBar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.white,
        boxShadow: [
          BoxShadow(
            color: AppConstants.gray.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Language selector
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
            decoration: BoxDecoration(
              color: AppConstants.lightGray,
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppConstants.supportedLanguages[user.currentLanguage] ?? '🇪🇸',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: AppConstants.spacingS),
                Text(
                  user.currentLanguage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.black,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingXS),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppConstants.darkGray,
                  size: 20,
                ),
              ],
            ),
          ),
          
          // Stats row
          Row(
            children: [
              // Streak
              _StatItem(
                icon: Icons.local_fire_department,
                iconColor: AppConstants.orange,
                value: user.currentStreak.toString(),
              ),
              const SizedBox(width: AppConstants.spacingM),
              
              // Gems
              _StatItem(
                icon: Icons.diamond,
                iconColor: AppConstants.blue,
                value: user.gems.toString(),
              ),
              const SizedBox(width: AppConstants.spacingM),
              
              // Hearts
              _StatItem(
                icon: Icons.favorite,
                iconColor: AppConstants.red,
                value: user.hearts.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: AppConstants.spacingXS),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppConstants.black,
          ),
        ),
      ],
    );
  }
}