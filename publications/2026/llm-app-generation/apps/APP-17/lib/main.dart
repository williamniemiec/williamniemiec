import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_theme.dart';
import 'providers/tea_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();
  
  // Check if user has completed onboarding
  final hasCompletedOnboarding = storageService.getSetting<bool>(
    'has_completed_onboarding',
    defaultValue: false,
  ) ?? false;
  
  runApp(TeaApp(hasCompletedOnboarding: hasCompletedOnboarding));
}

class TeaApp extends StatelessWidget {
  final bool hasCompletedOnboarding;
  
  const TeaApp({
    super.key,
    required this.hasCompletedOnboarding,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TeaProvider(),
      child: MaterialApp(
        title: 'Tea - Your AI Dating Wingman',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: hasCompletedOnboarding ? const AppInitializer() : const OnboardingScreen(),
        routes: {
          '/home': (context) => const AppInitializer(),
          '/onboarding': (context) => const OnboardingScreen(),
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<TeaProvider>(context, listen: false);
      await provider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeaProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const LoadingScreen();
        }
        
        if (provider.error != null) {
          return ErrorScreen(
            error: provider.error!,
            onRetry: () => _initializeApp(),
          );
        }
        
        return const HomeScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tea logo/icon would go here
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.local_cafe,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Tea',
              style: AppTheme.displayLarge.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your AI Dating Wingman',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Getting ready...',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const ErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Center(
        child: Padding(
          padding: AppTheme.defaultPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: AppTheme.errorColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: AppTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                error,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
