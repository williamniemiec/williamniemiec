import 'package:flutter/foundation.dart';
import '../../../shared/models/appointment.dart';
import '../../../shared/models/message.dart';
import '../../../shared/models/test_result.dart';
import '../../../shared/models/bill.dart';

class HomeProvider extends ChangeNotifier {
  List<Appointment> _upcomingAppointments = [];
  List<Message> _recentMessages = [];
  List<TestResult> _newTestResults = [];
  List<Bill> _pendingBills = [];
  bool _isLoading = false;

  List<Appointment> get upcomingAppointments => _upcomingAppointments;
  List<Message> get recentMessages => _recentMessages;
  List<TestResult> get newTestResults => _newTestResults;
  List<Bill> get pendingBills => _pendingBills;
  bool get isLoading => _isLoading;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API calls
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data for demo
    _upcomingAppointments = [
      Appointment(
        id: '1',
        patientId: '1',
        providerId: 'dr1',
        providerName: 'Dr. Sarah Johnson',
        department: 'Cardiology',
        reason: 'Annual Checkup',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        status: AppointmentStatus.scheduled,
        type: AppointmentType.inPerson,
        location: 'Main Hospital - Room 205',
      ),
    ];

    _recentMessages = [
      Message(
        id: '1',
        threadId: 'thread1',
        senderId: 'dr1',
        senderName: 'Dr. Sarah Johnson',
        senderRole: 'doctor',
        recipientId: '1',
        subject: 'Test Results Available',
        content: 'Your recent blood work results are now available.',
        sentAt: DateTime.now().subtract(const Duration(hours: 2)),
        isFromProvider: true,
        priority: MessagePriority.normal,
      ),
    ];

    _newTestResults = [
      TestResult(
        id: '1',
        patientId: '1',
        testName: 'Complete Blood Count',
        category: 'Laboratory',
        orderedDate: DateTime.now().subtract(const Duration(days: 2)),
        resultDate: DateTime.now().subtract(const Duration(hours: 1)),
        orderingProvider: 'Dr. Sarah Johnson',
        overallStatus: TestResultStatus.normal,
        isNew: true,
      ),
    ];

    _pendingBills = [
      Bill(
        id: '1',
        patientId: '1',
        statementNumber: 'ST-2024-001',
        statementDate: DateTime.now().subtract(const Duration(days: 5)),
        dueDate: DateTime.now().add(const Duration(days: 25)),
        totalAmount: 250.00,
        balanceDue: 250.00,
        status: BillStatus.pending,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void markTestResultAsRead(String testResultId) {
    final index = _newTestResults.indexWhere((result) => result.id == testResultId);
    if (index != -1) {
      // In a real app, you'd update this on the server
      _newTestResults.removeAt(index);
      notifyListeners();
    }
  }
}