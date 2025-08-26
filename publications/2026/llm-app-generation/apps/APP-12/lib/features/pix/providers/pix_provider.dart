import 'package:flutter/material.dart';
import '../../../shared/models/transaction.dart';

class PixProvider extends ChangeNotifier {
  List<Transaction> _pixTransactions = [];
  bool _isLoading = false;
  String? _error;

  List<Transaction> get pixTransactions => _pixTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setPixTransactions(List<Transaction> transactions) {
    _pixTransactions = transactions;
    notifyListeners();
  }
}