import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isProtected = true;

  void _toggleProtection(bool value) {
    setState(() {
      _isProtected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield,
              size: 150,
              color: _isProtected ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _isProtected ? 'Protected' : 'Unprotected',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Switch(
              value: _isProtected,
              onChanged: _toggleProtection,
            ),
            const SizedBox(height: 40),
            const Text(
              'Trackers blocked today: 1,234',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Threats neutralized: 56',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}