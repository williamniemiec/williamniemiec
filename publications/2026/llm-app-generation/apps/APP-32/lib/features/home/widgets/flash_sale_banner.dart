import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/theme/app_theme.dart';

class FlashSaleBanner extends StatelessWidget {
  const FlashSaleBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        final flashSaleProducts = productProvider.flashSaleProducts;
        if (flashSaleProducts.isEmpty) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppTheme.flashSaleGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.flash_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'FLASH SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Up to 90% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCountdownTimer(),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountdownTimer() {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
      builder: (context, snapshot) {
        // Mock flash sale end time (3 hours from now)
        final endTime = DateTime.now().add(const Duration(hours: 3));
        final now = DateTime.now();
        final difference = endTime.difference(now);

        if (difference.isNegative) {
          return const Text(
            'Sale Ended',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        final seconds = difference.inSeconds % 60;

        return Row(
          children: [
            _buildTimeBox(hours.toString().padLeft(2, '0')),
            const Text(' : ', style: TextStyle(color: Colors.white)),
            _buildTimeBox(minutes.toString().padLeft(2, '0')),
            const Text(' : ', style: TextStyle(color: Colors.white)),
            _buildTimeBox(seconds.toString().padLeft(2, '0')),
          ],
        );
      },
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}