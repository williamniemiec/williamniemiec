import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Hub'),
        backgroundColor: AppConstants.blue,
        foregroundColor: AppConstants.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: AppConstants.blue,
            ),
            SizedBox(height: AppConstants.spacingM),
            Text(
              'Practice Hub',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.black,
              ),
            ),
            SizedBox(height: AppConstants.spacingS),
            Text(
              'Practice exercises coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: AppConstants.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}