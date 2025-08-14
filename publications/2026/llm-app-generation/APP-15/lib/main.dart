import 'package:flutter/material.dart';
import 'package:rhythm_pad/screens/performance_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhythm Pad',
      theme: ThemeData.dark(),
      home: PerformanceScreen(),
    );
  }
}
