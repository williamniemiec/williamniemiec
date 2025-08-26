import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/order.dart';
import '../../auth/providers/auth_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Order> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    // Simulate loading orders
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _orders = _getMockOrders();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Pedidos'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryRed,
          unselectedLabelColor: AppTheme.textGrey,
          indicatorColor: AppTheme.primaryRed,
          tabs: const [
            Tab(text: 'Em andamento'),
            Tab(text: 'Histórico'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveOrders(),
          _buildOrderHistory(),
        ],
      ),
    );
  }

  Widget _buildActiveOrders() {
    final activeOrders = _orders.where((order) => order.isActive).toList();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (activeOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Nenhum pedido em andamento',
        subtitle: 'Quando você fizer um pedido,\nele aparecerá aqui',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeOrders.length,
      itemBuilder: (context, index) {
        final order = activeOrders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildOrderCard(order, isActive: true),
        );
      },
    );
  }

  Widget _buildOrderHistory() {
    final completedOrders = _orders.where((order) => !order.isActive).toList();

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (completedOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'Nenhum pedido no histórico',
        subtitle: 'Seus pedidos anteriores\naparecerão aqui',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedOrders.length,
      itemBuilder: (context, index) {
        final order = completedOrders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildOrderCard(order, isActive: false),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Fazer pedido'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, {required bool isActive}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Restaurant Logo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(order.restaurantLogoUrl),
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
                
                // Order Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.restaurantName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pedido #${order.id.substring(0, 8)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Order Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Items
                ...order.items.take(2).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '${item.quantity}x',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textGrey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )),
                
                if (order.items.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '+ ${order.items.length - 2} itens',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ),
                
                const SizedBox(height: 12),
                
                // Total and Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: R\$ ${order.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textDark,
                      ),
                    ),
                    Text(
                      _formatDate(order.createdAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
                
                if (isActive) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/tracking/${order.id}'),
                      child: const Text('Acompanhar pedido'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
        return Colors.orange;
      case OrderStatus.preparing:
      case OrderStatus.ready:
        return Colors.blue;
      case OrderStatus.outForDelivery:
        return AppTheme.primaryRed;
      case OrderStatus.delivered:
        return AppTheme.successGreen;
      case OrderStatus.cancelled:
        return AppTheme.errorRed;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<Order> _getMockOrders() {
    // Mock orders data
    return [
      // Add mock orders here
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}