import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/vaccines/screens/vaccine_certificate_screen.dart';
import 'main_navigation.dart';

void main() {
  runApp(const ConecteSUSApp());
}

class ConecteSUSApp extends StatelessWidget {
  const ConecteSUSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AppInitializer(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const MainNavigation(),
          '/vaccine-certificate': (context) => const VaccineCertificateScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle routes that need parameters or don't exist
          switch (settings.name) {
            case '/cns-card':
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  appBar: null,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.credit_card, size: 64, color: Colors.blue),
                        SizedBox(height: 16),
                        Text('CNS Card Screen', style: TextStyle(fontSize: 18)),
                        Text('Em desenvolvimento', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            case '/exams':
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  appBar: null,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.science, size: 64, color: Colors.green),
                        SizedBox(height: 16),
                        Text('Exams Screen', style: TextStyle(fontSize: 18)),
                        Text('Em desenvolvimento', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            case '/medications':
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  appBar: null,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medication, size: 64, color: Colors.orange),
                        SizedBox(height: 16),
                        Text('Medications Screen', style: TextStyle(fontSize: 18)),
                        Text('Em desenvolvimento', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            case '/appointments':
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  appBar: null,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today, size: 64, color: Colors.purple),
                        SizedBox(height: 16),
                        Text('Appointments Screen', style: TextStyle(fontSize: 18)),
                        Text('Em desenvolvimento', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: Text('Página não encontrada'),
                  ),
                ),
              );
          }
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while initializing
        if (authProvider.state == AuthState.initial || authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Inicializando Conecte SUS...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        // Navigate based on authentication state
        if (authProvider.isAuthenticated) {
          return const MainNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
