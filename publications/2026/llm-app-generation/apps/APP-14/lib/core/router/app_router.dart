import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/main/screens/main_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/orders/screens/orders_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/restaurant/screens/restaurant_screen.dart';
import '../../features/product/screens/product_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/tracking/screens/tracking_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SearchScreen(),
            ),
          ),
          GoRoute(
            path: '/orders',
            name: 'orders',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: OrdersScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/restaurant/:id',
        name: 'restaurant',
        builder: (context, state) {
          final restaurantId = state.pathParameters['id']!;
          return RestaurantScreen(restaurantId: restaurantId);
        },
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          final restaurantId = state.uri.queryParameters['restaurantId']!;
          return ProductScreen(
            productId: productId,
            restaurantId: restaurantId,
          );
        },
      ),
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/tracking/:orderId',
        name: 'tracking',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return TrackingScreen(orderId: orderId);
        },
      ),
    ],
  );
}