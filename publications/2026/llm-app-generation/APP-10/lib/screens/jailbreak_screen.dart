import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JailbreakScreen extends StatelessWidget {
  const JailbreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Compromised Device Detected',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'For your security, Aegis Vault cannot run on a jailbroken or rooted device.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}