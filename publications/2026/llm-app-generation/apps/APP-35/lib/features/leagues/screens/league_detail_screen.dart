import 'package:flutter/material.dart';

class LeagueDetailScreen extends StatelessWidget {
  final String leagueId;

  const LeagueDetailScreen({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('League Detail')),
      body: Center(
        child: Text('League Detail Screen - League ID: $leagueId'),
      ),
    );
  }
}