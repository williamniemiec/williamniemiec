import 'package:flutter/foundation.dart';
import '../models/blood_pressure_reading.dart';
import '../services/database_service.dart';

class BloodPressureProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<BloodPressureReading> _readings = [];
  BloodPressureReading? _latestReading;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<BloodPressureReading> get readings => _readings;
  BloodPressureReading? get latestReading => _latestReading;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all readings
  Future<void> loadReadings() async {
    _setLoading(true);
    _clearError();
    
    try {
      _readings = await _databaseService.getAllBloodPressureReadings();
      _latestReading = _readings.isNotEmpty ? _readings.first : null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load readings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load readings by date range
  Future<void> loadReadingsByDateRange(DateTime startDate, DateTime endDate) async {
    _setLoading(true);
    _clearError();
    
    try {
      _readings = await _databaseService.getBloodPressureReadingsByDateRange(startDate, endDate);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load readings: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Add new reading
  Future<bool> addReading(BloodPressureReading reading) async {
    _setLoading(true);
    _clearError();
    
    try {
      final id = await _databaseService.insertBloodPressureReading(reading);
      final newReading = reading.copyWith(id: id);
      
      // Add to the beginning of the list (most recent first)
      _readings.insert(0, newReading);
      _latestReading = newReading;
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add reading: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update reading
  Future<bool> updateReading(BloodPressureReading reading) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _databaseService.updateBloodPressureReading(reading);
      
      // Update in the list
      final index = _readings.indexWhere((r) => r.id == reading.id);
      if (index != -1) {
        _readings[index] = reading;
        
        // Update latest reading if this is the most recent
        if (_latestReading?.id == reading.id) {
          _latestReading = reading;
        }
        
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update reading: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete reading
  Future<bool> deleteReading(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _databaseService.deleteBloodPressureReading(id);
      
      // Remove from the list
      _readings.removeWhere((r) => r.id == id);
      
      // Update latest reading if needed
      if (_latestReading?.id == id) {
        _latestReading = _readings.isNotEmpty ? _readings.first : null;
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete reading: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get readings by category
  List<BloodPressureReading> getReadingsByCategory(BloodPressureCategory category) {
    return _readings.where((reading) => reading.category == category).toList();
  }

  // Get readings by date range (from loaded readings)
  List<BloodPressureReading> getReadingsInRange(DateTime startDate, DateTime endDate) {
    return _readings.where((reading) {
      return reading.dateTime.isAfter(startDate.subtract(const Duration(days: 1))) &&
             reading.dateTime.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Get average values for a time period
  Map<String, double> getAverages({DateTime? startDate, DateTime? endDate}) {
    List<BloodPressureReading> filteredReadings = _readings;
    
    if (startDate != null && endDate != null) {
      filteredReadings = getReadingsInRange(startDate, endDate);
    }
    
    if (filteredReadings.isEmpty) {
      return {'systolic': 0.0, 'diastolic': 0.0, 'pulse': 0.0};
    }
    
    final totalSystolic = filteredReadings.fold<int>(0, (sum, reading) => sum + reading.systolic);
    final totalDiastolic = filteredReadings.fold<int>(0, (sum, reading) => sum + reading.diastolic);
    final totalPulse = filteredReadings.fold<int>(0, (sum, reading) => sum + reading.pulse);
    
    return {
      'systolic': totalSystolic / filteredReadings.length,
      'diastolic': totalDiastolic / filteredReadings.length,
      'pulse': totalPulse / filteredReadings.length,
    };
  }

  // Get category distribution
  Map<BloodPressureCategory, int> getCategoryDistribution() {
    final distribution = <BloodPressureCategory, int>{};
    
    for (final category in BloodPressureCategory.values) {
      distribution[category] = 0;
    }
    
    for (final reading in _readings) {
      distribution[reading.category] = (distribution[reading.category] ?? 0) + 1;
    }
    
    return distribution;
  }

  // Get readings for the last N days
  List<BloodPressureReading> getRecentReadings(int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return _readings.where((reading) => reading.dateTime.isAfter(cutoffDate)).toList();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Clear all data (useful for testing or reset)
  void clearData() {
    _readings.clear();
    _latestReading = null;
    _clearError();
    notifyListeners();
  }
}