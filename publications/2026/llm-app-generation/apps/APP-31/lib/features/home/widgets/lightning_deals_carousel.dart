import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/product.dart';
import '../../product/screens/product_detail_screen.dart';

class LightningDealsCarousel extends StatelessWidget {
  final List<Product> products;

  const LightningDealsCarousel({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final flashSaleProducts = products.where((p) => p.isFlashSale).toList();
    
    if (flashSaleProducts.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: flashSaleProducts.length,
        itemBuilder: (context, index) {
          final product = flashSaleProducts[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          color: Colors.grey[100],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: product.images.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        product.images.first,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: AppTheme.textHint,
                                          );
                                        },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: AppTheme.textHint,
                                    ),
                            ),
                            // Flash Sale Badge
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.flashSaleColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'FLASH',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Product Info
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                if (product.hasDiscount)
                                  Text(
                                    '\$${product.originalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppTheme.textSecondary,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                            if (product.hasDiscount)
                              Text(
                                '${product.discountPercentage.toInt()}% OFF',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.discountColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}