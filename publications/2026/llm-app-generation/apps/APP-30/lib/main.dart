import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/providers/document_provider.dart';

void main() {
  runApp(const GoogleDocsApp());
}

class GoogleDocsApp extends StatelessWidget {
  const GoogleDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DocumentProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Google Docs',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
