import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ActionShortcuts extends StatelessWidget {
  const ActionShortcuts({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ações rápidas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.pix,
                  label: 'Área Pix',
                  onTap: () {
                    // Navigate to Pix
                  },
                ),
                _ActionButton(
                  icon: Icons.payment,
                  label: 'Pagar',
                  onTap: () {
                    // Navigate to Pay
                  },
                ),
                _ActionButton(
                  icon: Icons.send,
                  label: 'Transferir',
                  onTap: () {
                    // Navigate to Transfer
                  },
                ),
                _ActionButton(
                  icon: Icons.add_circle_outline,
                  label: 'Depositar',
                  onTap: () {
                    // Navigate to Deposit
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryPurple,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}