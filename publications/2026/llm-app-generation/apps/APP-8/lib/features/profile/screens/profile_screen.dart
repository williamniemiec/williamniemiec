import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.purple,
        foregroundColor: AppConstants.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 64,
              color: AppConstants.purple,
            ),
            SizedBox(height: AppConstants.spacingM),
            Text(
              'Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.black,
              ),
            ),
            SizedBox(height: AppConstants.spacingS),
            Text(
              'User profile coming soon!',
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