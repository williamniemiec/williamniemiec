import 'package:apex_altimeter/screens/home_screen.dart';
import 'package:apex_altimeter/services/service_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ServiceProvider(child: ApexAltimeter()));
}

class ApexAltimeter extends StatelessWidget {
  const ApexAltimeter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apex Altimeter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
