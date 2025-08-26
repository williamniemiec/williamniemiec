import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const DuolingoCloneApp());
}

class DuolingoCloneApp extends StatelessWidget {
  const DuolingoCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duolingo Clone',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}
