import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_tag_commander/services/history_service.dart';
import 'package:provider/provider.dart';

class ReadTab extends StatefulWidget {
  @override
  _ReadTabState createState() => _ReadTabState();
}

class _ReadTabState extends State<ReadTab> {
  String? _tagData;

  @override
  void initState() {
    super.initState();
    _startNFCReading();
  }

  void _startNFCReading() {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        if (ndef != null) {
          final message = await ndef.read();
          Provider.of<HistoryService>(context, listen: false).addEntry(message);
          setState(() {
            _tagData = tag.data.toString();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _tagData == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/nfc_animation.svg',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Ready to scan. Hold a tag to the top of your phone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tag Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(_tagData!),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }
}