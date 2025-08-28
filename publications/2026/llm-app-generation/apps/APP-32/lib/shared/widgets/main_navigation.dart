import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/providers/cart_provider.dart';
import '../../core/theme/app_theme.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavigationBar(),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _getCurrentIndex(currentLocation),
          onTap: (index) => _onItemTapped(context, index),
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.textSecondary,
          backgroundColor: AppTheme.surfaceColor,
          elevation: 8,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Shop',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_outlined),
              activeIcon: Icon(Icons.flash_on),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: cartProvider.itemCount > 0
                  ? badges.Badge(
                      badgeContent: Text(
                        cartProvider.itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: AppTheme.secondaryColor,
                        padding: EdgeInsets.all(4),
                      ),
                      child: const Icon(Icons.shopping_bag_outlined),
                    )
                  : const Icon(Icons.shopping_bag_outlined),
              activeIcon: cartProvider.itemCount > 0
                  ? badges.Badge(
                      badgeContent: Text(
                        cartProvider.itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: AppTheme.secondaryColor,
                        padding: EdgeInsets.all(4),
                      ),
                      child: const Icon(Icons.shopping_bag),
                    )
                  : const Icon(Icons.shopping_bag),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Me',
            ),
          ],
        );
      },
    );
  }

  int _getCurrentIndex(String location) {
    if (location.startsWith('/shop')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/cart')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0; // Home
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/shop');
        break;
      case 2:
        // Navigate to new arrivals or flash sales
        context.go('/shop?filter=new');
        break;
      case 3:
        context.go('/cart');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}