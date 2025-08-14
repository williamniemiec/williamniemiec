import 'package:flutter/material.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data for network connections
    final connections = [
      {'appName': 'Social App', 'domain': 'analytics.google.com', 'status': 'Blocked'},
      {'appName': 'Social App', 'domain': 'graph.facebook.com', 'status': 'Blocked'},
      {'appName': 'News App', 'domain': 'news-api.com', 'status': 'Allowed'},
      {'appName': 'Game App', 'domain': 'unityads.com', 'status': 'Blocked'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: connections.length,
        itemBuilder: (context, index) {
          final connection = connections[index];
          final isBlocked = connection['status'] == 'Blocked';

          return ListTile(
            leading: const Icon(Icons.apps), // Placeholder for app icon
            title: Text(connection['domain']!),
            subtitle: Text(connection['appName']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: isBlocked ? Colors.red : Colors.green,
                ),
                const SizedBox(width: 5),
                Text(connection['status']!),
              ],
            ),
          );
        },
      ),
    );
  }
}