import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/home/screens/home_screen.dart';
import 'features/editor/screens/editor_screen.dart';
import 'features/templates/screens/templates_screen.dart';
import 'features/export/screens/export_screen.dart';
import 'features/settings/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  runApp(
    const ProviderScope(
      child: CapCutApp(),
    ),
  );
}

class CapCutApp extends ConsumerWidget {
  const CapCutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/editor/:projectId',
      name: 'editor',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        return EditorScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: '/templates',
      name: 'templates',
      builder: (context, state) => const TemplatesScreen(),
    ),
    GoRoute(
      path: '/export/:projectId',
      name: 'export',
      builder: (context, state) {
        final projectId = state.pathParameters['projectId']!;
        return ExportScreen(projectId: projectId);
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
