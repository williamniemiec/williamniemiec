import 'package:flutter/material.dart';
import '../../../shared/models/credit_card.dart';
import '../../../shared/models/transaction.dart';

class CreditCardProvider extends ChangeNotifier {
  CreditCard? _creditCard;
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;

  CreditCard? get creditCard => _creditCard;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setCreditCard(CreditCard creditCard) {
    _creditCard = creditCard;
    notifyListeners();
  }

  void setTransactions(List<Transaction> transactions) {
    _transactions = transactions;
    notifyListeners();
  }
}