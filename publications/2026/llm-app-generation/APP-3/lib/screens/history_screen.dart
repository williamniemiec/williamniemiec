import 'package:apex_altimeter/models/session.dart';
import 'package:apex_altimeter/screens/session_details_screen.dart';
import 'package:apex_altimeter/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<SessionService>(
        builder: (context, sessionService, child) {
          return FutureBuilder<List<Session>>(
            future: sessionService.getAllSessions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No sessions found.'));
              } else {
                final sessions = snapshot.data!;
                return ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      title: Text(session.name),
                      subtitle: Text(
                          '${session.startTime.toLocal()} - ${session.totalDistance.toStringAsFixed(2)} km'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SessionDetailsScreen(session: session),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}