import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_tag_commander/models/history_entry.dart';
import 'package:nfc_tag_commander/screens/history/history_detail_screen.dart';
import 'package:nfc_tag_commander/services/history_service.dart';
import 'package:nfc_tag_commander/utils/record_parser.dart';
import 'package:provider/provider.dart';

class HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryService>(
      builder: (context, historyService, child) {
        return ListView.builder(
          itemCount: historyService.history.length,
          itemBuilder: (context, index) {
            final entry = historyService.history[index];
            final recordInfo = RecordParser.parse(entry.message.records.first);
            return ListTile(
              leading: Icon(_getIconForRecordType(recordInfo.title)),
              title: Text(recordInfo.title),
              subtitle: Text(recordInfo.subtitle ?? ''),
              trailing: IconButton(
                icon: Icon(
                  entry.isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  historyService.toggleFavorite(entry);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryDetailScreen(entry: entry),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  IconData _getIconForRecordType(String recordType) {
    switch (recordType) {
      case 'URL':
        return Icons.link;
      case 'Text':
        return Icons.text_fields;
      case 'Wi-Fi':
        return Icons.wifi;
      case 'Contact':
        return Icons.person;
      default:
        return Icons.memory;
    }
  }
}