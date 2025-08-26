import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/account.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({
    super.key,
    required this.account,
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
                const Icon(
                  Icons.account_balance_wallet,
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Conta',
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
            Text(
              'Saldo disponível',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textGray,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              account.formattedBalance,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            if (account.savingsBalance > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.savings,
                      size: 16,
                      color: AppTheme.primaryPurple,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Rendimento: ${account.formattedSavingsBalance}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}