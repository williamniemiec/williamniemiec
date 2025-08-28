import 'package:flutter/foundation.dart';
import '../../../shared/models/bill.dart';

class BillingProvider extends ChangeNotifier {
  List<Bill> _bills = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Bill> get bills => _bills;
  List<Bill> get pendingBills => 
      _bills.where((bill) => bill.status == BillStatus.pending).toList();
  List<Bill> get overdueBills => 
      _bills.where((bill) => bill.isOverdue).toList();
  double get totalBalance => 
      _bills.fold(0.0, (sum, bill) => sum + bill.balanceDue);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBills() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
      
      _bills = [
        Bill(
          id: '1',
          patientId: '1',
          statementNumber: 'ST-2024-001',
          statementDate: DateTime.now().subtract(const Duration(days: 5)),
          dueDate: DateTime.now().add(const Duration(days: 25)),
          totalAmount: 250.00,
          balanceDue: 250.00,
          status: BillStatus.pending,
          lineItems: [
            BillLineItem(
              id: '1',
              description: 'Office Visit - Cardiology',
              serviceCode: '99213',
              serviceDate: DateTime.now().subtract(const Duration(days: 10)),
              amount: 300.00,
              insuranceCovered: 50.00,
              patientResponsibility: 250.00,
            ),
          ],
        ),
        Bill(
          id: '2',
          patientId: '1',
          statementNumber: 'ST-2024-002',
          statementDate: DateTime.now().subtract(const Duration(days: 15)),
          dueDate: DateTime.now().add(const Duration(days: 15)),
          totalAmount: 150.00,
          balanceDue: 150.00,
          status: BillStatus.pending,
          lineItems: [
            BillLineItem(
              id: '2',
              description: 'Laboratory - Blood Work',
              serviceCode: '80053',
              serviceDate: DateTime.now().subtract(const Duration(days: 20)),
              amount: 200.00,
              insuranceCovered: 50.00,
              patientResponsibility: 150.00,
            ),
          ],
        ),
      ];
      
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load bills';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> payBill(String billId, double amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final index = _bills.indexWhere((bill) => bill.id == billId);
      if (index != -1) {
        final bill = _bills[index];
        final newAmountPaid = bill.amountPaid + amount;
        final newBalanceDue = bill.totalAmount - newAmountPaid;
        
        // Create updated bill (in a real app, this would come from the server)
        final updatedBill = Bill(
          id: bill.id,
          patientId: bill.patientId,
          statementNumber: bill.statementNumber,
          statementDate: bill.statementDate,
          dueDate: bill.dueDate,
          totalAmount: bill.totalAmount,
          amountPaid: newAmountPaid,
          balanceDue: newBalanceDue,
          status: newBalanceDue <= 0 ? BillStatus.paid : BillStatus.partiallyPaid,
          lineItems: bill.lineItems,
          paymentPlan: bill.paymentPlan,
          insuranceInfo: bill.insuranceInfo,
          notes: bill.notes,
        );
        
        _bills[index] = updatedBill;
      }
      
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Payment failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setupPaymentPlan(String billId, double monthlyPayment, int numberOfPayments) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      final index = _bills.indexWhere((bill) => bill.id == billId);
      if (index != -1) {
        final bill = _bills[index];
        final paymentPlan = PaymentPlan(
          id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
          totalAmount: bill.balanceDue,
          monthlyPayment: monthlyPayment,
          numberOfPayments: numberOfPayments,
          remainingPayments: numberOfPayments,
          startDate: DateTime.now(),
          nextPaymentDate: DateTime.now().add(const Duration(days: 30)),
        );
        
        // Update bill with payment plan
        final updatedBill = Bill(
          id: bill.id,
          patientId: bill.patientId,
          statementNumber: bill.statementNumber,
          statementDate: bill.statementDate,
          dueDate: bill.dueDate,
          totalAmount: bill.totalAmount,
          amountPaid: bill.amountPaid,
          balanceDue: bill.balanceDue,
          status: bill.status,
          lineItems: bill.lineItems,
          paymentPlan: paymentPlan,
          insuranceInfo: bill.insuranceInfo,
          notes: bill.notes,
        );
        
        _bills[index] = updatedBill;
      }
      
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to setup payment plan';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}