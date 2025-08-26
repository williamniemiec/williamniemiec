import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/transaction.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactions({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Transações recentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigate to all transactions
                  },
                  child: const Text(
                    'Ver todas',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...transactions.take(3).map((transaction) => _TransactionTile(
              transaction: transaction,
            )),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const _TransactionTile({
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getTransactionColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _getTransactionIcon(),
              color: _getTransactionColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(transaction.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGray,
                  ),
                ),
              ],
            ),
          ),
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: transaction.isDebit ? AppTheme.errorRed : AppTheme.successGreen,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case TransactionType.pixIn:
      case TransactionType.pixOut:
        return Icons.pix;
      case TransactionType.transfer:
        return Icons.send;
      case TransactionType.deposit:
        return Icons.add_circle;
      case TransactionType.withdrawal:
        return Icons.remove_circle;
      case TransactionType.billPayment:
        return Icons.receipt;
      case TransactionType.purchase:
        return Icons.shopping_cart;
      case TransactionType.refund:
        return Icons.undo;
      case TransactionType.cashback:
        return Icons.card_giftcard;
      default:
        return Icons.swap_horiz;
    }
  }

  Color _getTransactionColor() {
    switch (transaction.type) {
      case TransactionType.pixIn:
      case TransactionType.pixOut:
        return AppTheme.primaryPurple;
      case TransactionType.deposit:
      case TransactionType.cashback:
      case TransactionType.refund:
        return AppTheme.successGreen;
      case TransactionType.withdrawal:
      case TransactionType.purchase:
        return AppTheme.errorRed;
      case TransactionType.transfer:
      case TransactionType.billPayment:
        return AppTheme.warningOrange;
      default:
        return AppTheme.textGray;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes}min atrás';
      }
      return '${difference.inHours}h atrás';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}