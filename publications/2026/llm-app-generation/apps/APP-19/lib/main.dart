import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/appointments/providers/appointment_provider.dart';
import 'features/messages/providers/message_provider.dart';
import 'features/billing/providers/billing_provider.dart';
import 'main_navigation.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  runApp(const MyChartApp());
}

class MyChartApp extends StatelessWidget {
  const MyChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => BillingProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (authProvider.isAuthenticated) {
              return const MainNavigation();
            }
            
            return const LoginScreen();
          },
        ),
        routes: {
          AppConstants.homeRoute: (context) => const MainNavigation(),
          AppConstants.loginRoute: (context) => const LoginScreen(),
        },
      ),
    );
  }
}
