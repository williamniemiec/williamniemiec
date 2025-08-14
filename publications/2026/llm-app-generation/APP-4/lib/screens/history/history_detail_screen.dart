import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_tag_commander/models/history_entry.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryEntry entry;

  const HistoryDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tag Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(entry.message.records
                .map((e) => String.fromCharCodes(e.payload))
                .join('\n')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _writeTag(context),
              child: const Text('Write this data to a new tag'),
            ),
          ],
        ),
      ),
    );
  }

  void _writeTag(BuildContext context) {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var ndef = Ndef.from(tag);
        if (ndef == null) {
          _showSnackBar(context, 'Tag is not ndef compatible');
          return;
        }

        try {
          await ndef.write(entry.message);
          _showSnackBar(context, 'Tag written successfully');
        } catch (e) {
          _showSnackBar(context, 'Error writing to tag: $e');
        } finally {
          NfcManager.instance.stopSession();
        }
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}