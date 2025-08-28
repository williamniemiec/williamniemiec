import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/shop/screens/shop_screen.dart';
import '../../features/product_detail/screens/product_detail_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../shared/widgets/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Shell route for main navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          // Home
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Shop/Categories
          GoRoute(
            path: '/shop',
            name: 'shop',
            builder: (context, state) => const ShopScreen(),
            routes: [
              GoRoute(
                path: '/category/:categoryId',
                name: 'category',
                builder: (context, state) {
                  final categoryId = state.pathParameters['categoryId']!;
                  return ShopScreen(selectedCategory: categoryId);
                },
              ),
            ],
          ),
          
          // Search
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) {
              final query = state.uri.queryParameters['q'] ?? '';
              return SearchScreen(initialQuery: query);
            },
          ),
          
          // Cart
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          
          // Profile
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Product Detail (outside shell to allow full screen)
      GoRoute(
        path: '/product/:productId',
        name: 'product_detail',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      
      // Authentication routes (outside shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri}" could not be found.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Route names for easy navigation
class Routes {
  static const String home = '/';
  static const String shop = '/shop';
  static const String search = '/search';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String productDetail = '/product';
  static const String login = '/login';
  static const String register = '/register';
  
  // Helper methods for navigation with parameters
  static String productDetailPath(String productId) => '/product/$productId';
  static String categoryPath(String categoryId) => '/shop/category/$categoryId';
  static String searchPath(String query) => '/search?q=$query';
}