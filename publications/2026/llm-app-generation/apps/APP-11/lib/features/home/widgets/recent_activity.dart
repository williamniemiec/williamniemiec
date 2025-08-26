import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/transaction.dart';

class RecentActivity extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentActivity({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.primaryTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full activity screen
              },
              child: Text(
                'See All',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.paypalBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding),
        if (transactions.isEmpty)
          _buildEmptyState(context)
        else
          Card(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length > 5 ? 5 : transactions.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: 72,
              ),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _buildTransactionTile(context, transaction);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.extraLargePadding),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: AppTheme.mediumGray,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'No recent activity',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.primaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Your transactions will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, Transaction transaction) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      leading: _buildTransactionIcon(transaction),
      title: Text(
        _getTransactionTitle(transaction),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (transaction.description != null)
            Text(
              transaction.description!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
          const SizedBox(height: 2),
          Text(
            _formatDate(transaction.createdAt),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transaction.displayAmount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: transaction.isIncoming 
                  ? AppTheme.successColor 
                  : AppTheme.primaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getStatusColor(transaction.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              transaction.statusDisplayName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: _getStatusColor(transaction.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // Navigate to transaction details
      },
    );
  }

  Widget _buildTransactionIcon(Transaction transaction) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (transaction.type) {
      case TransactionType.send:
        iconData = Icons.arrow_upward;
        backgroundColor = AppTheme.errorColor.withOpacity(0.1);
        iconColor = AppTheme.errorColor;
        break;
      case TransactionType.receive:
        iconData = Icons.arrow_downward;
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        iconColor = AppTheme.successColor;
        break;
      case TransactionType.purchase:
        iconData = Icons.shopping_cart_outlined;
        backgroundColor = AppTheme.paypalBlue.withOpacity(0.1);
        iconColor = AppTheme.paypalBlue;
        break;
      case TransactionType.refund:
        iconData = Icons.undo;
        backgroundColor = AppTheme.infoColor.withOpacity(0.1);
        iconColor = AppTheme.infoColor;
        break;
      case TransactionType.withdrawal:
        iconData = Icons.account_balance;
        backgroundColor = AppTheme.warningColor.withOpacity(0.1);
        iconColor = AppTheme.warningColor;
        break;
      case TransactionType.deposit:
        iconData = Icons.add_circle_outline;
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        iconColor = AppTheme.successColor;
        break;
      case TransactionType.billPayment:
        iconData = Icons.receipt;
        backgroundColor = AppTheme.paypalLightBlue.withOpacity(0.1);
        iconColor = AppTheme.paypalLightBlue;
        break;
      case TransactionType.cashBack:
        iconData = Icons.monetization_on_outlined;
        backgroundColor = AppTheme.paypalYellow.withOpacity(0.1);
        iconColor = AppTheme.paypalYellow;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        iconData,
        size: 20,
        color: iconColor,
      ),
    );
  }

  String _getTransactionTitle(Transaction transaction) {
    switch (transaction.type) {
      case TransactionType.send:
        return 'Sent to ${transaction.recipientName ?? 'Unknown'}';
      case TransactionType.receive:
        return 'Received from ${transaction.recipientName ?? 'Unknown'}';
      case TransactionType.purchase:
        return 'Purchase from ${transaction.merchantName ?? 'Unknown'}';
      case TransactionType.refund:
        return 'Refund from ${transaction.merchantName ?? 'Unknown'}';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.billPayment:
        return 'Bill Payment';
      case TransactionType.cashBack:
        return 'Cash Back';
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return AppTheme.successColor;
      case TransactionStatus.pending:
        return AppTheme.warningColor;
      case TransactionStatus.failed:
      case TransactionStatus.cancelled:
        return AppTheme.errorColor;
      case TransactionStatus.refunded:
        return AppTheme.infoColor;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
}