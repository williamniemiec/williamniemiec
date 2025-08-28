import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'shared/services/trip_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  TripService().initialize();
  
  runApp(
    const ProviderScope(
      child: UberApp(),
    ),
  );
}

class UberApp extends StatelessWidget {
  const UberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
