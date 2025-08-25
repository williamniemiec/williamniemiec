import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/api_service.dart';
import 'core/services/storage_service.dart';
import 'features/home/screens/home_screen.dart';
import 'features/editor/screens/editor_screen.dart';
import 'features/templates/screens/template_browser_screen.dart';
import 'features/assets/screens/asset_browser_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await _initializeServices();
  
  runApp(
    const ProviderScope(
      child: CanvaApp(),
    ),
  );
}

Future<void> _initializeServices() async {
  try {
    // Initialize storage service
    await StorageService().initialize();
    
    // Initialize API service
    ApiService().initialize();
    
    debugPrint('Services initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize services: $e');
  }
}

class CanvaApp extends StatelessWidget {
  const CanvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Canva Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}

// Router configuration
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/templates',
      name: 'templates',
      builder: (context, state) => const TemplateBrowserScreen(),
    ),
    GoRoute(
      path: '/assets',
      name: 'assets',
      builder: (context, state) => const AssetBrowserScreen(),
    ),
    GoRoute(
      path: '/editor/:designId',
      name: 'editor',
      builder: (context, state) {
        final designId = state.pathParameters['designId']!;
        return EditorScreen(designId: designId);
      },
    ),
    GoRoute(
      path: '/editor/new/:format',
      name: 'new_design',
      builder: (context, state) {
        final format = state.pathParameters['format']!;
        return EditorScreen.newDesign(format: format);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
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
