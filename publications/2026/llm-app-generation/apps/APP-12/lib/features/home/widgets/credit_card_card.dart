import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/credit_card.dart';

class CreditCardCard extends StatelessWidget {
  final CreditCard creditCard;

  const CreditCardCard({
    super.key,
    required this.creditCard,
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
                Container(
                  width: 32,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.creditCardGradientStart,
                        AppTheme.creditCardGradientEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Cartão de Crédito',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textGray,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (creditCard.closedBill > 0) ...[
              Text(
                'Fatura fechada',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textGray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                creditCard.formattedClosedBill,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.errorRed,
                ),
              ),
              if (creditCard.billDueDate != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Vence em ${_formatDueDate(creditCard.billDueDate!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGray,
                  ),
                ),
              ],
            ] else ...[
              Text(
                'Fatura atual',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textGray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                creditCard.formattedCurrentBill,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Limite disponível',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGray,
                        ),
                      ),
                      Text(
                        creditCard.formattedAvailableLimit,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.successGreen,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: creditCard.usagePercentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: creditCard.usagePercentage > 80
                            ? AppTheme.errorRed
                            : creditCard.usagePercentage > 60
                                ? AppTheme.warningOrange
                                : AppTheme.primaryPurple,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    
    if (difference == 0) {
      return 'hoje';
    } else if (difference == 1) {
      return 'amanhã';
    } else if (difference < 7) {
      return '$difference dias';
    } else {
      return '${dueDate.day}/${dueDate.month}';
    }
  }
}