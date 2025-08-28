enum BillStatus {
  pending,
  paid,
  overdue,
  partiallyPaid,
  disputed,
}

enum PaymentMethod {
  creditCard,
  debitCard,
  bankAccount,
  paypal,
  applePay,
  googlePay,
}

class BillLineItem {
  final String id;
  final String description;
  final String serviceCode;
  final DateTime serviceDate;
  final double amount;
  final double insuranceCovered;
  final double patientResponsibility;
  final String? notes;

  BillLineItem({
    required this.id,
    required this.description,
    required this.serviceCode,
    required this.serviceDate,
    required this.amount,
    this.insuranceCovered = 0.0,
    required this.patientResponsibility,
    this.notes,
  });

  factory BillLineItem.fromJson(Map<String, dynamic> json) {
    return BillLineItem(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      serviceCode: json['serviceCode'] ?? '',
      serviceDate: DateTime.parse(json['serviceDate']),
      amount: (json['amount'] ?? 0.0).toDouble(),
      insuranceCovered: (json['insuranceCovered'] ?? 0.0).toDouble(),
      patientResponsibility: (json['patientResponsibility'] ?? 0.0).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'serviceCode': serviceCode,
      'serviceDate': serviceDate.toIso8601String(),
      'amount': amount,
      'insuranceCovered': insuranceCovered,
      'patientResponsibility': patientResponsibility,
      'notes': notes,
    };
  }
}

class PaymentPlan {
  final String id;
  final double totalAmount;
  final double monthlyPayment;
  final int numberOfPayments;
  final int remainingPayments;
  final DateTime startDate;
  final DateTime? nextPaymentDate;
  final bool isActive;

  PaymentPlan({
    required this.id,
    required this.totalAmount,
    required this.monthlyPayment,
    required this.numberOfPayments,
    required this.remainingPayments,
    required this.startDate,
    this.nextPaymentDate,
    this.isActive = true,
  });

  double get remainingBalance => monthlyPayment * remainingPayments;
  double get paidAmount => totalAmount - remainingBalance;
  double get progressPercentage => (paidAmount / totalAmount) * 100;

  factory PaymentPlan.fromJson(Map<String, dynamic> json) {
    return PaymentPlan(
      id: json['id'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      monthlyPayment: (json['monthlyPayment'] ?? 0.0).toDouble(),
      numberOfPayments: json['numberOfPayments'] ?? 0,
      remainingPayments: json['remainingPayments'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
      nextPaymentDate: json['nextPaymentDate'] != null
          ? DateTime.parse(json['nextPaymentDate'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalAmount': totalAmount,
      'monthlyPayment': monthlyPayment,
      'numberOfPayments': numberOfPayments,
      'remainingPayments': remainingPayments,
      'startDate': startDate.toIso8601String(),
      'nextPaymentDate': nextPaymentDate?.toIso8601String(),
      'isActive': isActive,
    };
  }
}

class Bill {
  final String id;
  final String patientId;
  final String statementNumber;
  final DateTime statementDate;
  final DateTime? dueDate;
  final double totalAmount;
  final double amountPaid;
  final double balanceDue;
  final BillStatus status;
  final List<BillLineItem> lineItems;
  final PaymentPlan? paymentPlan;
  final String? insuranceInfo;
  final String? notes;

  Bill({
    required this.id,
    required this.patientId,
    required this.statementNumber,
    required this.statementDate,
    this.dueDate,
    required this.totalAmount,
    this.amountPaid = 0.0,
    required this.balanceDue,
    this.status = BillStatus.pending,
    this.lineItems = const [],
    this.paymentPlan,
    this.insuranceInfo,
    this.notes,
  });

  bool get isOverdue {
    if (dueDate == null) return false;
    return DateTime.now().isAfter(dueDate!) && balanceDue > 0;
  }

  bool get isPaid => status == BillStatus.paid;
  bool get hasPaymentPlan => paymentPlan != null && paymentPlan!.isActive;

  String get statusDisplayName {
    switch (status) {
      case BillStatus.pending:
        return 'Pending';
      case BillStatus.paid:
        return 'Paid';
      case BillStatus.overdue:
        return 'Overdue';
      case BillStatus.partiallyPaid:
        return 'Partially Paid';
      case BillStatus.disputed:
        return 'Disputed';
    }
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      statementNumber: json['statementNumber'] ?? '',
      statementDate: DateTime.parse(json['statementDate']),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      amountPaid: (json['amountPaid'] ?? 0.0).toDouble(),
      balanceDue: (json['balanceDue'] ?? 0.0).toDouble(),
      status: BillStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BillStatus.pending,
      ),
      lineItems: (json['lineItems'] as List<dynamic>?)
          ?.map((e) => BillLineItem.fromJson(e))
          .toList() ?? [],
      paymentPlan: json['paymentPlan'] != null
          ? PaymentPlan.fromJson(json['paymentPlan'])
          : null,
      insuranceInfo: json['insuranceInfo'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'statementNumber': statementNumber,
      'statementDate': statementDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'totalAmount': totalAmount,
      'amountPaid': amountPaid,
      'balanceDue': balanceDue,
      'status': status.name,
      'lineItems': lineItems.map((e) => e.toJson()).toList(),
      'paymentPlan': paymentPlan?.toJson(),
      'insuranceInfo': insuranceInfo,
      'notes': notes,
    };
  }
}