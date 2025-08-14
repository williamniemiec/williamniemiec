import 'package:flutter/material.dart';
import 'screens/recipe_discovery_screen.dart';

void main() {
  runApp(const SimmerApp());
}

class SimmerApp extends StatelessWidget {
  const SimmerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simmer',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RecipeDiscoveryScreen(),
    );
  }
}
