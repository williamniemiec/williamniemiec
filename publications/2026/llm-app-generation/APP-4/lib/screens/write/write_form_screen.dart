import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_tag_commander/models/record_type.dart';
import 'package:nfc_tag_commander/services/history_service.dart';
import 'package:provider/provider.dart';

class WriteFormScreen extends StatefulWidget {
  final RecordType recordType;

  const WriteFormScreen({super.key, required this.recordType});

  @override
  _WriteFormScreenState createState() => _WriteFormScreenState();
}

class _WriteFormScreenState extends State<WriteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _getFormFields(widget.recordType).forEach((field) {
      _controllers[field] = TextEditingController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write ${widget.recordType.toString().split('.').last}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ..._buildFormFields(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _writeTag,
                child: const Text('Write Tag'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormFields() {
    return _getFormFields(widget.recordType).map((field) {
      return TextFormField(
        controller: _controllers[field],
        decoration: InputDecoration(labelText: field),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      );
    }).toList();
  }

  void _writeTag() {
    if (_formKey.currentState!.validate()) {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);
          if (ndef == null) {
            _showSnackBar('Tag is not ndef compatible');
            return;
          }

          try {
            final message = _createNdefMessage();
            await ndef.write(message);
            Provider.of<HistoryService>(context, listen: false)
                .addEntry(message);
            _showSnackBar('Tag written successfully');
            Navigator.of(context).pop();
          } catch (e) {
            _showSnackBar('Error writing to tag: $e');
          } finally {
            NfcManager.instance.stopSession();
          }
        },
      );
    }
  }

  NdefMessage _createNdefMessage() {
    switch (widget.recordType) {
      case RecordType.url:
        return NdefMessage([
          NdefRecord.createUri(Uri.parse(_controllers['URL']!.text)),
        ]);
      case RecordType.text:
        return NdefMessage([
          NdefRecord.createText(_controllers['Text']!.text),
        ]);
      case RecordType.wifi:
        return NdefMessage([
          NdefRecord.createExternal(
            'android.com',
            'pkg',
            _getWifiPayload(),
          ),
        ]);
      case RecordType.contact:
        return NdefMessage([
          NdefRecord.createMime(
            'text/vcard',
            _getVcardPayload(),
          ),
        ]);
    }
  }

  List<String> _getFormFields(RecordType recordType) {
    switch (recordType) {
      case RecordType.url:
        return ['URL'];
      case RecordType.text:
        return ['Text'];
      case RecordType.wifi:
        return ['SSID', 'Password'];
      case RecordType.contact:
        return ['Name', 'Phone', 'Email'];
    }
  }
  
  Uint8List _getWifiPayload() {
    final ssid = _controllers['SSID']!.text;
    final password = _controllers['Password']!.text;
    return Uint8List.fromList(
        'WIFI:S:$ssid;T:WPA;P:$password;;'.codeUnits);
  }

  Uint8List _getVcardPayload() {
    final name = _controllers['Name']!.text;
    final phone = _controllers['Phone']!.text;
    final email = _controllers['Email']!.text;

    return Uint8List.fromList(
      'BEGIN:VCARD\nVERSION:3.0\nFN:$name\nTEL:$phone\nEMAIL:$email\nEND:VCARD'
          .codeUnits,
    );
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}