import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_football,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Sleeper',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement login
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}