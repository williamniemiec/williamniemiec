import 'package:flutter/material.dart';
import 'package:nfc_tag_commander/models/history_entry.dart';
import 'package:nfc_manager/nfc_manager.dart';

class HistoryService extends ChangeNotifier {
  final List<HistoryEntry> _history = [];

  List<HistoryEntry> get history => _history;

  void addEntry(NdefMessage message) {
    _history.insert(0, HistoryEntry(message: message, date: DateTime.now()));
    notifyListeners();
  }

  void toggleFavorite(HistoryEntry entry) {
    entry.isFavorite = !entry.isFavorite;
    notifyListeners();
  }
}