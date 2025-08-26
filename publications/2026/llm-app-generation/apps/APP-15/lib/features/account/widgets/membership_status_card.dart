import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';

class MembershipStatusCard extends StatelessWidget {
  const MembershipStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final membership = authProvider.currentMembership;

        if (membership == null) {
          return _buildNoMembershipCard(context);
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Membership Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(membership.status),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        membership.statusDisplayName,
                        style: const TextStyle(
                          color: AppTheme.textOnPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildMembershipInfo(context, membership),
                if (membership.hasOutstandingBalance) ...[
                  const SizedBox(height: 16),
                  _buildOutstandingBalanceWarning(context, membership),
                ],
                const SizedBox(height: 16),
                _buildActionButtons(context, membership),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoMembershipCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          children: [
            Icon(
              Icons.card_membership,
              size: 48,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No Active Membership',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join Blink Fitness to access all features',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to membership plans
                },
                child: const Text('View Plans'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipInfo(BuildContext context, membership) {
    return Column(
      children: [
        _buildInfoRow(
          context,
          'Plan',
          membership.planDisplayName,
          Icons.card_membership,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          'Monthly Fee',
          '\$${membership.monthlyFee.toStringAsFixed(2)}',
          Icons.attach_money,
        ),
        const SizedBox(height: 12),
        _buildInfoRow(
          context,
          'Next Billing',
          _formatDate(membership.nextBillingDate),
          Icons.calendar_today,
        ),
        if (membership.guestPassesPerMonth > 0) ...[
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Guest Passes',
            '${membership.guestPassesPerMonth} per month',
            Icons.people,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildOutstandingBalanceWarning(BuildContext context, membership) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.warningColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: AppTheme.warningColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Outstanding Balance',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warningColor,
                  ),
                ),
                Text(
                  '\$${membership.outstandingBalance.toStringAsFixed(2)} due',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.warningColor,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppConstants.billingRoute),
            child: const Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, membership) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.push(AppConstants.membershipRoute),
            child: const Text('View Details'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => context.push(AppConstants.billingRoute),
            child: const Text('Manage Billing'),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'MembershipStatus.active':
        return AppTheme.successColor;
      case 'MembershipStatus.frozen':
        return AppTheme.primaryColor;
      case 'MembershipStatus.pastDue':
        return AppTheme.warningColor;
      case 'MembershipStatus.cancelled':
      case 'MembershipStatus.suspended':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}