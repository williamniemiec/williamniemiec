import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'shared/services/cart_service.dart';
import 'shared/services/user_service.dart';
import 'shared/services/loyalty_service.dart';
import 'features/home/providers/cookie_provider.dart';
import 'features/order/providers/order_provider.dart';
import 'features/locations/providers/location_provider.dart';
import 'shared/widgets/main_navigation.dart';

void main() {
  runApp(const CrumblApp());
}

class CrumblApp extends StatelessWidget {
  const CrumblApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Services
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => LoyaltyService()),
        
        // Feature Providers
        ChangeNotifierProvider(create: (_) => CookieProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigation(),
        routes: {
          AppConstants.homeRoute: (context) => const MainNavigation(),
          AppConstants.orderRoute: (context) => const MainNavigation(initialIndex: 1),
          AppConstants.locationsRoute: (context) => const MainNavigation(initialIndex: 2),
          AppConstants.moreRoute: (context) => const MainNavigation(initialIndex: 3),
        },
      ),
    );
  }
}
