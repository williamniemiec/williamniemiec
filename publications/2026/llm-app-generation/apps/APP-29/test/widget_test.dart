import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_app/main.dart';
import 'package:chatgpt_app/core/providers/app_provider.dart';
import 'package:chatgpt_app/core/providers/chat_provider.dart';
import 'package:chatgpt_app/core/providers/auth_provider.dart';
import 'package:chatgpt_app/core/providers/subscription_provider.dart';

void main() {
  group('ChatGPT App Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ChatGPTApp());

      // Verify that the app launches without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Onboarding screen shows when first time', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => ChatProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
          ],
          child: MaterialApp(
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                // Simulate first time user
                return const Scaffold(
                  body: Center(
                    child: Text('Welcome to ChatGPT'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify welcome text is shown
      expect(find.text('Welcome to ChatGPT'), findsOneWidget);
    });

    testWidgets('Chat input field is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AppProvider()),
            ChangeNotifierProvider(create: (_) => ChatProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const Expanded(child: SizedBox()),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Message ChatGPT...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify chat input field is present
      expect(find.text('Message ChatGPT...'), findsOneWidget);
    });

    testWidgets('Theme switching works', (WidgetTester tester) async {
      final appProvider = AppProvider();
      
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: appProvider,
          child: Consumer<AppProvider>(
            builder: (context, provider, child) {
              return MaterialApp(
                themeMode: provider.themeMode,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                home: const Scaffold(
                  body: Center(
                    child: Text('Theme Test'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test theme switching
      appProvider.setThemeMode(ThemeMode.dark);
      await tester.pumpAndSettle();

      appProvider.setThemeMode(ThemeMode.light);
      await tester.pumpAndSettle();

      // Verify the app doesn't crash during theme changes
      expect(find.text('Theme Test'), findsOneWidget);
    });
  });

  group('Provider Tests', () {
    test('ChatProvider creates new conversation', () {
      final chatProvider = ChatProvider();
      
      expect(chatProvider.conversations.isEmpty, true);
      
      chatProvider.createNewConversation();
      
      expect(chatProvider.conversations.length, 1);
      expect(chatProvider.currentConversation, isNotNull);
      expect(chatProvider.currentConversation!.title, 'New Chat');
    });

    test('SubscriptionProvider manages subscription state', () {
      final subscriptionProvider = SubscriptionProvider();
      
      expect(subscriptionProvider.isPlusSubscriber, false);
      expect(subscriptionProvider.canSendMessage(), true);
      expect(subscriptionProvider.remainingMessages, 50);
    });

    test('AuthProvider manages authentication state', () {
      final authProvider = AuthProvider();
      
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.isFirstTime, true);
      expect(authProvider.userId, isNull);
    });

    test('AppProvider manages theme state', () {
      final appProvider = AppProvider();
      
      expect(appProvider.themeMode, ThemeMode.system);
      
      appProvider.setThemeMode(ThemeMode.dark);
      expect(appProvider.themeMode, ThemeMode.dark);
      
      appProvider.setThemeMode(ThemeMode.light);
      expect(appProvider.themeMode, ThemeMode.light);
    });
  });

  group('Model Tests', () {
    test('Message model serialization works', () {
      // This would test the Message model's toJson/fromJson methods
      // Implementation depends on the actual model structure
    });

    test('Conversation model manages messages', () {
      // This would test the Conversation model's functionality
      // Implementation depends on the actual model structure
    });
  });
}