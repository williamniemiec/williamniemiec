import 'package:flutter/material.dart';
import 'package:momentum_reddit/screens/feed_screen.dart';

void main() {
  runApp(const MomentumApp());
}

class MomentumApp extends StatelessWidget {
  const MomentumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Momentum for Reddit',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
        ).copyWith(secondary: Colors.blueAccent),
      ),
      home: const FeedScreen(),
    );
  }
}
