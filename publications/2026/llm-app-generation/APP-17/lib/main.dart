import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentinel_browser/models/browser_model.dart';
import 'package:sentinel_browser/models/settings_model.dart';
import 'package:sentinel_browser/screens/browser_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BrowserModel()),
        ChangeNotifierProvider(create: (context) => SettingsModel()),
      ],
      child: MaterialApp(
        title: 'Sentinel Browser',
        theme: ThemeData.dark().copyWith(
          primaryColor: Colors.grey[900],
          scaffoldBackgroundColor: Colors.grey[850],
          appBarTheme: AppBarTheme(
            color: Colors.grey[900],
            elevation: 0,
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey[900],
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.black26,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: const BrowserScreen(),
      ),
    );
  }
}
