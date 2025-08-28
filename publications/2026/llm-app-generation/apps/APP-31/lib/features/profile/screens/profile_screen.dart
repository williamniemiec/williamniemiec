import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/services/mock_data_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('You'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          // If user is not logged in, show mock user data
          if (!appProvider.isLoggedIn) {
            // Set mock user for demo purposes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              appProvider.setUser(MockDataService.getMockUser());
            });
          }

          final user = appProvider.currentUser;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // User Profile Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: user?.profileImage != null
                            ? NetworkImage(user!.profileImage!)
                            : null,
                        child: user?.profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 30,
                                color: AppTheme.primaryColor,
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Guest User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? 'guest@example.com',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit profile coming soon!'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Credits and Coupons Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Credits',
                          '\$${user?.credits.toStringAsFixed(2) ?? '0.00'}',
                          Icons.account_balance_wallet,
                          AppTheme.successColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Coupons',
                          '${user?.coupons.where((c) => c.isValid).length ?? 0}',
                          Icons.local_offer,
                          AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Games Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.secondaryColor.withOpacity(0.1),
                        AppTheme.primaryColor.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.games,
                            color: AppTheme.primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Daily Games & Rewards',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildGameCard('Fishland', Icons.water_drop),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildGameCard('Farmland', Icons.agriculture),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Menu Items
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        'Your Orders',
                        Icons.shopping_bag_outlined,
                        '${user?.totalOrders ?? 0} orders',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Orders screen coming soon!')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        'Returns',
                        Icons.keyboard_return,
                        'Manage returns',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Returns screen coming soon!')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        'Messages',
                        Icons.message_outlined,
                        'Customer support',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Messages screen coming soon!')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        'Addresses',
                        Icons.location_on_outlined,
                        '${user?.addresses.length ?? 0} saved addresses',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Addresses screen coming soon!')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        'Settings',
                        Icons.settings_outlined,
                        'App preferences',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Settings screen coming soon!')),
                          );
                        },
                      ),
                      _buildMenuItem(
                        'Help & Support',
                        Icons.help_outline,
                        'Get help',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Help screen coming soon!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(String name, IconData icon) {
    return GestureDetector(
      onTap: () {
        // Simulate earning rewards
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Play Now',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, String subtitle, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTheme.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }
}