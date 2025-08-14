import 'package:nfc_manager/nfc_manager.dart';

class HistoryEntry {
  final NdefMessage message;
  final DateTime date;
  bool isFavorite;

  HistoryEntry({
    required this.message,
    required this.date,
    this.isFavorite = false,
  });
}