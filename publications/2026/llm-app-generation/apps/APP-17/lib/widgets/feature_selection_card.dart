import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class FeatureSelectionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final int remainingUses;
  final bool isPremium;

  const FeatureSelectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.remainingUses,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    final isLimited = !isPremium && remainingUses <= 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: isLimited ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isLimited 
                ? LinearGradient(
                    colors: [
                      AppTheme.textTertiary.withOpacity(0.1),
                      AppTheme.textTertiary.withOpacity(0.05),
                    ],
                  )
                : null,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: isLimited 
                      ? LinearGradient(
                          colors: [
                            AppTheme.textTertiary.withOpacity(0.3),
                            AppTheme.textTertiary.withOpacity(0.2),
                          ],
                        )
                      : gradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTheme.titleLarge.copyWith(
                              color: isLimited 
                                  ? AppTheme.textTertiary 
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        
                        // Usage indicator
                        if (!isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isLimited 
                                  ? AppTheme.errorColor.withOpacity(0.1)
                                  : AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isLimited ? 'Limit reached' : '$remainingUses left',
                              style: AppTheme.labelSmall.copyWith(
                                color: isLimited 
                                    ? AppTheme.errorColor 
                                    : AppTheme.successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: isLimited 
                            ? AppTheme.textTertiary 
                            : AppTheme.textSecondary,
                      ),
                    ),
                    
                    // Premium badge
                    if (isPremium)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.workspace_premium,
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Unlimited',
                              style: AppTheme.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isLimited 
                    ? AppTheme.textTertiary 
                    : AppTheme.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}