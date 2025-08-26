import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: AppConstants.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 64,
              color: AppConstants.primaryGreen,
            ),
            SizedBox(height: AppConstants.spacingM),
            Text(
              'Stories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.black,
              ),
            ),
            SizedBox(height: AppConstants.spacingS),
            Text(
              'Interactive stories coming soon!',
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