import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/editor/screens/editor_screen.dart';
import '../../features/results/screens/results_screen.dart';
import '../../features/gallery/screens/gallery_screen.dart';
import '../../features/subscription/screens/subscription_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String editor = '/editor';
  static const String results = '/results';
  static const String gallery = '/gallery';
  static const String subscription = '/subscription';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      // Home Screen
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Editor Screen
      GoRoute(
        path: editor,
        name: 'editor',
        builder: (context, state) {
          final imagePath = state.uri.queryParameters['imagePath'];
          return EditorScreen(imagePath: imagePath);
        },
      ),

      // Results Screen
      GoRoute(
        path: results,
        name: 'results',
        builder: (context, state) {
          final projectId = state.uri.queryParameters['projectId'];
          if (projectId == null) {
            return const HomeScreen(); // Fallback
          }
          return ResultsScreen(projectId: projectId);
        },
      ),

      // Gallery Screen
      GoRoute(
        path: gallery,
        name: 'gallery',
        builder: (context, state) => const GalleryScreen(),
      ),

      // Subscription Screen
      GoRoute(
        path: subscription,
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}

// Navigation helper methods
class AppNavigation {
  static void goToHome(BuildContext context) {
    context.go(AppRouter.home);
  }

  static void goToEditor(BuildContext context, {String? imagePath}) {
    final uri = Uri(
      path: AppRouter.editor,
      queryParameters: imagePath != null ? {'imagePath': imagePath} : null,
    );
    context.go(uri.toString());
  }

  static void goToResults(BuildContext context, String projectId) {
    final uri = Uri(
      path: AppRouter.results,
      queryParameters: {'projectId': projectId},
    );
    context.go(uri.toString());
  }

  static void goToGallery(BuildContext context) {
    context.go(AppRouter.gallery);
  }

  static void goToSubscription(BuildContext context) {
    context.go(AppRouter.subscription);
  }

  // Push methods (for modal navigation)
  static void pushEditor(BuildContext context, {String? imagePath}) {
    final uri = Uri(
      path: AppRouter.editor,
      queryParameters: imagePath != null ? {'imagePath': imagePath} : null,
    );
    context.push(uri.toString());
  }

  static void pushResults(BuildContext context, String projectId) {
    final uri = Uri(
      path: AppRouter.results,
      queryParameters: {'projectId': projectId},
    );
    context.push(uri.toString());
  }

  static void pushSubscription(BuildContext context) {
    context.push(AppRouter.subscription);
  }
}

// Error screen for navigation errors
class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Page not found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}