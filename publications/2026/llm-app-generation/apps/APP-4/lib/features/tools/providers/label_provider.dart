import 'package:flutter/foundation.dart';
import '../../../shared/models/label.dart';

class LabelProvider extends ChangeNotifier {
  List<ChatLabel> _labels = [];
  bool _isLoading = false;
  String? _error;

  List<ChatLabel> get labels => _labels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLabels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Load default labels
      _labels = ChatLabel.getDefaultLabels();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLabel(ChatLabel label) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      _labels.add(label);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLabel(ChatLabel label) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      final index = _labels.indexWhere((l) => l.id == label.id);
      if (index != -1) {
        _labels[index] = label;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteLabel(String labelId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      _labels.removeWhere((label) => label.id == labelId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  ChatLabel? getLabelById(String labelId) {
    try {
      return _labels.firstWhere((label) => label.id == labelId);
    } catch (e) {
      return null;
    }
  }

  bool canDeleteLabel(String labelId) {
    // Default labels cannot be deleted
    final defaultLabelIds = ChatLabel.getDefaultLabels().map((l) => l.id).toList();
    return !defaultLabelIds.contains(labelId);
  }
}