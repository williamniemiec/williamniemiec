import 'dart:async';

import 'package:apex_altimeter/data/database_helper.dart';
import 'package:apex_altimeter/models/session.dart';
import 'package:flutter/foundation.dart';

class SessionService extends ChangeNotifier {
  final dbHelper = DatabaseHelper.instance;
  Session? _currentSession;
  bool _isRecording = false;
  final List<Map<String, dynamic>> _sessionData = [];

  Session? get currentSession => _currentSession;
  bool get isRecording => _isRecording;
  List<Map<String, dynamic>> get sessionData => _sessionData;

  void startRecording() {
    _isRecording = true;
    _currentSession = Session(
      name: 'New Session',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      totalDistance: 0,
      totalAscent: 0,
      totalDescent: 0,
      maxAltitude: 0,
    );
    _sessionData.clear();
    notifyListeners();
  }

  void stopRecording() {
    _isRecording = false;
    if (_currentSession != null) {
      _currentSession!.endTime = DateTime.now();
      dbHelper.create(_currentSession!);
    }
    notifyListeners();
  }

  void addDataPoint(Map<String, dynamic> data) {
    if (_isRecording) {
      _sessionData.add(data);
    }
  }

  Future<List<Session>> getAllSessions() async {
    return await dbHelper.readAllSessions();
  }
}