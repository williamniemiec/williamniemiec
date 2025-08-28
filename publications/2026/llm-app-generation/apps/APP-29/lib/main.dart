import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/app_provider.dart';
import 'core/providers/chat_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/subscription_provider.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';

void main() {
  runApp(const ChatGPTApp());
}

class ChatGPTApp extends StatelessWidget {
  const ChatGPTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'ChatGPT',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (authProvider.isFirstTime) {
                  return const OnboardingScreen();
                }
                return const ChatScreen();
              },
            ),
          );
        },
      ),
    );
  }
}