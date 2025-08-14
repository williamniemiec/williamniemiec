import 'package:apex_altimeter/models/session.dart';
import 'package:apex_altimeter/services/export_service.dart';
import 'package:apex_altimeter/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionDetailsScreen extends StatelessWidget {
  final Session session;

  const SessionDetailsScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(session.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start Time: ${session.startTime.toLocal()}'),
            Text('End Time: ${session.endTime.toLocal()}'),
            Text('Total Distance: ${session.totalDistance.toStringAsFixed(2)} km'),
            Text('Total Ascent: ${session.totalAscent.toStringAsFixed(2)} m'),
            Text('Total Descent: ${session.totalDescent.toStringAsFixed(2)} m'),
            Text('Max Altitude: ${session.maxAltitude.toStringAsFixed(2)} m'),
            const SizedBox(height: 24),
            Consumer<ExportService>(
              builder: (context, exportService, child) {
                return ElevatedButton(
                  onPressed: () async {
                    final sessionService =
                        Provider.of<SessionService>(context, listen: false);
                    final gpxPath = await exportService.exportToGpx(
                        session, sessionService.sessionData);
                    final csvPath = await exportService.exportToCsv(
                        session, sessionService.sessionData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Exported to $gpxPath and $csvPath'),
                      ),
                    );
                  },
                  child: const Text('Export'),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}