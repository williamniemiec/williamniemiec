import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/theme/app_theme.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      subscriptionProvider.isPlusSubscriber
                          ? Icons.workspace_premium
                          : Icons.account_circle_outlined,
                      color: subscriptionProvider.isPlusSubscriber
                          ? AppTheme.primaryColor
                          : AppTheme.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscriptionProvider.subscriptionStatusText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: subscriptionProvider.isPlusSubscriber
                                  ? AppTheme.primaryColor
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          if (subscriptionProvider.subscriptionExpiryDate != null)
                            Text(
                              'Expires ${_formatDate(subscriptionProvider.subscriptionExpiryDate!)}',
                              style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (subscriptionProvider.isPlusSubscriber)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'PLUS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                if (!subscriptionProvider.isPlusSubscriber) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildUsageInfo(subscriptionProvider),
                ],
                if (subscriptionProvider.isPlusSubscriber) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildPlusFeatures(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsageInfo(SubscriptionProvider subscriptionProvider) {
    return Column(
      children: [
        _buildUsageRow(
          'Messages',
          subscriptionProvider.remainingMessages,
          50,
          Icons.chat_bubble_outline,
        ),
        const SizedBox(height: 8),
        _buildUsageRow(
          'Image Generations',
          subscriptionProvider.remainingImageGenerations,
          3,
          Icons.image,
        ),
      ],
    );
  }

  Widget _buildUsageRow(String label, int remaining, int total, IconData icon) {
    final used = total - remaining;
    final progress = used / total;
    
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$remaining left',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: AppTheme.textTertiary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  remaining > 0 ? AppTheme.primaryColor : AppTheme.errorColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlusFeatures() {
    final features = [
      'Unlimited messages',
      'Advanced AI models',
      'Faster responses',
      'Priority access',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plus Benefits',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: 16,
                color: AppTheme.successColor,
              ),
              const SizedBox(width: 8),
              Text(
                feature,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}