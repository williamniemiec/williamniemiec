import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool isEnabled;
  final Widget? trailing;
  final Color? iconColor;

  const AccountMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.isEnabled = true,
    this.trailing,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.primaryColor).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isEnabled 
              ? (iconColor ?? AppTheme.primaryColor)
              : AppTheme.textLight,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isEnabled ? AppTheme.textPrimary : AppTheme.textLight,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isEnabled ? AppTheme.textSecondary : AppTheme.textLight,
        ),
      ),
      trailing: trailing ?? (isEnabled 
          ? const Icon(
              Icons.chevron_right,
              color: AppTheme.textLight,
            )
          : null),
      onTap: isEnabled ? onTap : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 8,
      ),
    );
  }
}