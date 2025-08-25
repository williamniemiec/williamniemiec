import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/chats/providers/chat_provider.dart';
import 'features/tools/providers/business_profile_provider.dart';
import 'features/tools/providers/catalog_provider.dart';
import 'features/tools/providers/label_provider.dart';
import 'features/tools/providers/automated_message_provider.dart';
import 'shared/widgets/main_navigation.dart';

void main() {
  runApp(const WhatsAppBusinessApp());
}

class WhatsAppBusinessApp extends StatelessWidget {
  const WhatsAppBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProfileProvider()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()),
        ChangeNotifierProvider(create: (_) => LabelProvider()),
        ChangeNotifierProvider(create: (_) => AutomatedMessageProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
