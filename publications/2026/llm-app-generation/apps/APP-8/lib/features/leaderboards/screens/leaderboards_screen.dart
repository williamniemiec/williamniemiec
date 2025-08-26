import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class LeaderboardsScreen extends StatelessWidget {
  const LeaderboardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leagues'),
        backgroundColor: AppConstants.orange,
        foregroundColor: AppConstants.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard,
              size: 64,
              color: AppConstants.orange,
            ),
            SizedBox(height: AppConstants.spacingM),
            Text(
              'Leagues',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.black,
              ),
            ),
            SizedBox(height: AppConstants.spacingS),
            Text(
              'Leaderboards coming soon!',
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