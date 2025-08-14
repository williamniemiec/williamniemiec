import 'package:atmos_weather/screens/main_weather_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AtmosWeatherApp());
}

class AtmosWeatherApp extends StatelessWidget {
  const AtmosWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atmos Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainWeatherScreen(),
    );
  }
}
