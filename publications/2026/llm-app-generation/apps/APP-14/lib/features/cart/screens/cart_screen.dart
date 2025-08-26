import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Sacola'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              // Restaurant Info
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(cartProvider.restaurantLogoUrl ?? ''),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {},
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartProvider.restaurantName ?? 'Restaurante',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${cartProvider.itemCount} ${cartProvider.itemCount == 1 ? 'item' : 'itens'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Cart Items
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartProvider.items.length,
                    separatorBuilder: (context, index) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final item = cartProvider.items[index];
                      return _buildCartItem(context, cartProvider, item);
                    },
                  ),
                ),
              ),

              // Order Summary
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    
                    // Subtotal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          'R\$ ${cartProvider.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Delivery Fee
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Taxa de entrega',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          cartProvider.deliveryFee == 0 
                              ? 'Grátis' 
                              : 'R\$ ${cartProvider.deliveryFee.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: cartProvider.deliveryFee == 0 
                                ? AppTheme.successGreen 
                                : AppTheme.textDark,
                            fontWeight: cartProvider.deliveryFee == 0 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    
                    // Discount
                    if (cartProvider.discount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Desconto${cartProvider.appliedCouponCode != null ? ' (${cartProvider.appliedCouponCode})' : ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.textDark,
                            ),
                          ),
                          Text(
                            '- R\$ ${cartProvider.discount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.successGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    
                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                        Text(
                          'R\$ ${cartProvider.total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Checkout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/checkout'),
                        child: const Text('Finalizar pedido'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppTheme.textLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sua sacola está vazia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textGrey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione itens de um restaurante\npara começar seu pedido',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Explorar restaurantes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartProvider cartProvider, item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item Image
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) {},
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: const Icon(
              Icons.fastfood,
              size: 24,
              color: Colors.grey,
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Item Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Selected Options
              if (item.selectedOptions.isNotEmpty) ...[
                const SizedBox(height: 4),
                ...item.selectedOptions.map((option) => Text(
                  '+ ${option.itemName}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                )),
              ],
              
              // Special Instructions
              if (item.specialInstructions?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(
                  'Obs: ${item.specialInstructions}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              
              const SizedBox(height: 8),
              
              // Price and Quantity Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.totalPriceText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryRed,
                    ),
                  ),
                  
                  // Quantity Controls
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (item.quantity > 1) {
                            cartProvider.updateItemQuantity(item.id, item.quantity - 1);
                          } else {
                            cartProvider.removeItem(item.id);
                          }
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            item.quantity > 1 ? Icons.remove : Icons.delete,
                            size: 16,
                            color: AppTheme.primaryRed,
                          ),
                        ),
                      ),
                      
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
                      
                      GestureDetector(
                        onTap: () {
                          cartProvider.updateItemQuantity(item.id, item.quantity + 1);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 16,
                            color: AppTheme.primaryRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}