import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/content/screens/content_screen.dart';
import '../../features/account/screens/account_screen.dart';
import '../../shared/widgets/main_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.splashRoute,
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      
      // Define public routes that don't require authentication
      final publicRoutes = [
        AppConstants.loginRoute,
        AppConstants.registerRoute,
        AppConstants.splashRoute,
      ];
      
      // If user is not authenticated and trying to access a protected route
      if (!isAuthenticated && !publicRoutes.contains(state.matchedLocation)) {
        return AppConstants.loginRoute;
      }
      
      // If user is authenticated and trying to access login/register
      if (isAuthenticated && publicRoutes.contains(state.matchedLocation)) {
        return AppConstants.homeRoute;
      }
      
      return null; // No redirect needed
    },
    routes: [
      // Splash/Initial Route
      GoRoute(
        path: AppConstants.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: AppConstants.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main App Routes with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: AppConstants.homeRoute,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppConstants.contentRoute,
            builder: (context, state) => const ContentScreen(),
          ),
          GoRoute(
            path: AppConstants.accountRoute,
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),
      
      // Additional Routes (without bottom navigation)
      GoRoute(
        path: AppConstants.profileRoute,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppConstants.membershipRoute,
        builder: (context, state) => const MembershipScreen(),
      ),
      GoRoute(
        path: AppConstants.billingRoute,
        builder: (context, state) => const BillingScreen(),
      ),
      GoRoute(
        path: AppConstants.guestRoute,
        builder: (context, state) => const GuestScreen(),
      ),
      GoRoute(
        path: AppConstants.settingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '${AppConstants.contentDetailRoute}/:id',
        builder: (context, state) {
          final contentId = state.pathParameters['id']!;
          return ContentDetailScreen(contentId: contentId);
        },
      ),
      GoRoute(
        path: '${AppConstants.videoPlayerRoute}/:id',
        builder: (context, state) {
          final contentId = state.pathParameters['id']!;
          return VideoPlayerScreen(contentId: contentId);
        },
      ),
      GoRoute(
        path: AppConstants.barcodeRoute,
        builder: (context, state) => const BarcodeScreen(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}

// Placeholder screens - these will be implemented later
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Membership')),
      body: const Center(child: Text('Membership Screen')),
    );
  }
}

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: const Center(child: Text('Billing Screen')),
    );
  }
}

class GuestScreen extends StatelessWidget {
  const GuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guest Passes')),
      body: const Center(child: Text('Guest Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}

class ContentDetailScreen extends StatelessWidget {
  final String contentId;
  
  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Detail')),
      body: Center(child: Text('Content Detail Screen: $contentId')),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String contentId;
  
  const VideoPlayerScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: Center(child: Text('Video Player Screen: $contentId')),
    );
  }
}

class BarcodeScreen extends StatelessWidget {
  const BarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gym Check-in')),
      body: const Center(child: Text('Barcode Screen')),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text('Page not found'),
          ],
        ),
      ),
    );
  }
}