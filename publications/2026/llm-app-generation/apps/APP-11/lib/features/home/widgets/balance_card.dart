import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final String currency;
  final bool isVerified;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.currency,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PayPal Balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 14,
                          color: AppTheme.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              _formatCurrency(balance, currency),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.add,
                    label: 'Add Money',
                    onPressed: () {
                      // Navigate to add money screen
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: Icons.send,
                    label: 'Transfer',
                    onPressed: () {
                      // Navigate to transfer screen
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.white.withOpacity(0.2),
        foregroundColor: AppTheme.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          side: BorderSide(
            color: AppTheme.white.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double amount, String currency) {
    switch (currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      default:
        return '$currency ${amount.toStringAsFixed(2)}';
    }
  }
}