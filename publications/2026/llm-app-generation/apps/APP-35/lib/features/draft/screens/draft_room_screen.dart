import 'package:flutter/material.dart';

class DraftRoomScreen extends StatelessWidget {
  final String leagueId;

  const DraftRoomScreen({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draft Room')),
      body: Center(child: Text('Draft Room Screen - League ID: $leagueId')),
    );
  }
}