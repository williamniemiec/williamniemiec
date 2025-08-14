import 'package:flutter/material.dart';
import 'package:nfc_tag_commander/models/record_type.dart';
import 'package:nfc_tag_commander/screens/write/write_form_screen.dart';

class WriteTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: RecordType.values.map((recordType) {
        return ListTile(
          leading: Icon(_getIconForRecordType(recordType)),
          title: Text(_getTitleForRecordType(recordType)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WriteFormScreen(recordType: recordType),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  IconData _getIconForRecordType(RecordType recordType) {
    switch (recordType) {
      case RecordType.url:
        return Icons.link;
      case RecordType.text:
        return Icons.text_fields;
      case RecordType.wifi:
        return Icons.wifi;
      case RecordType.contact:
        return Icons.person;
    }
  }

  String _getTitleForRecordType(RecordType recordType) {
    switch (recordType) {
      case RecordType.url:
        return 'URL';
      case RecordType.text:
        return 'Text';
      case RecordType.wifi:
        return 'Wi-Fi Network';
      case RecordType.contact:
        return 'Contact';
    }
  }
}