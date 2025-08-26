import 'package:flutter/material.dart';
import '../../../shared/models/account.dart';
import '../../../shared/models/transaction.dart';

class AccountProvider extends ChangeNotifier {
  Account? _account;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  Account? get account => _account;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setAccount(Account account) {
    _account = account;
    notifyListeners();
  }

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }
}