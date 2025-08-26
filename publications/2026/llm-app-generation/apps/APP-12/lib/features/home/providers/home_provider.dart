import 'package:flutter/material.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/account.dart';
import '../../../shared/models/credit_card.dart';
import '../../../shared/models/transaction.dart';

class HomeProvider extends ChangeNotifier {
  User? _user;
  Account? _account;
  CreditCard? _creditCard;
  List<Transaction> _recentTransactions = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  Account? get account => _account;
  CreditCard? get creditCard => _creditCard;
  List<Transaction> get recentTransactions => _recentTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Mock data initialization
  void initializeMockData() {
    _isLoading = true;
    notifyListeners();

    // Simulate API delay
    Future.delayed(const Duration(seconds: 1), () {
      _user = User(
        id: '1',
        name: 'João Silva',
        email: 'joao.silva@email.com',
        cpf: '123.456.789-00',
        phone: '(11) 99999-9999',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        isVerified: true,
      );

      _account = Account(
        id: '1',
        userId: '1',
        balance: 2547.83,
        accountNumber: '12345-6',
        agency: '0001',
        type: AccountType.checking,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        savingsBalance: 1250.00,
      );

      _creditCard = CreditCard(
        id: '1',
        userId: '1',
        cardNumber: '5555444433332222',
        cardHolderName: 'JOAO SILVA',
        expiryDate: '12/28',
        cvv: '123',
        creditLimit: 5000.00,
        availableLimit: 3247.50,
        currentBill: 847.32,
        closedBill: 1205.18,
        billDueDate: DateTime.now().add(const Duration(days: 15)),
        billClosingDate: DateTime.now().add(const Duration(days: 30)),
        brand: CardBrand.mastercard,
        status: CardStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
      );

      _recentTransactions = [
        Transaction(
          id: '1',
          userId: '1',
          accountId: '1',
          amount: -45.90,
          description: 'Supermercado Extra',
          category: 'Alimentação',
          type: TransactionType.purchase,
          status: TransactionStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          processedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Transaction(
          id: '2',
          userId: '1',
          accountId: '1',
          amount: 1200.00,
          description: 'Salário',
          category: 'Renda',
          type: TransactionType.deposit,
          status: TransactionStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          processedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transaction(
          id: '3',
          userId: '1',
          accountId: '1',
          amount: -150.00,
          description: 'Pix para Maria',
          category: 'Transferência',
          type: TransactionType.pixOut,
          status: TransactionStatus.completed,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          processedAt: DateTime.now().subtract(const Duration(days: 2)),
          recipientName: 'Maria Santos',
        ),
      ];

      _isLoading = false;
      _error = null;
      notifyListeners();
    });
  }

  void refreshData() {
    initializeMockData();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}