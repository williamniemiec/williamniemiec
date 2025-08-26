enum TransactionType {
  send,
  receive,
  purchase,
  refund,
  withdrawal,
  deposit,
  billPayment,
  cashBack,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
  refunded,
}

class Transaction {
  final String id;
  final String userId;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String currency;
  final String? recipientId;
  final String? recipientName;
  final String? recipientEmail;
  final String? merchantName;
  final String? merchantId;
  final String? description;
  final String? note;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? paymentMethodId;
  final String? invoiceId;
  final double? feeAmount;
  final String? referenceNumber;
  final Map<String, dynamic>? metadata;

  Transaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    this.recipientId,
    this.recipientName,
    this.recipientEmail,
    this.merchantName,
    this.merchantId,
    this.description,
    this.note,
    required this.createdAt,
    this.completedAt,
    this.paymentMethodId,
    this.invoiceId,
    this.feeAmount,
    this.referenceNumber,
    this.metadata,
  });

  bool get isIncoming => type == TransactionType.receive || type == TransactionType.refund || type == TransactionType.deposit || type == TransactionType.cashBack;
  bool get isOutgoing => !isIncoming;
  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isFailed => status == TransactionStatus.failed;

  String get displayAmount {
    final sign = isIncoming ? '+' : '-';
    return '$sign\$${amount.toStringAsFixed(2)}';
  }

  String get typeDisplayName {
    switch (type) {
      case TransactionType.send:
        return 'Sent';
      case TransactionType.receive:
        return 'Received';
      case TransactionType.purchase:
        return 'Purchase';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.withdrawal:
        return 'Withdrawal';
      case TransactionType.deposit:
        return 'Deposit';
      case TransactionType.billPayment:
        return 'Bill Payment';
      case TransactionType.cashBack:
        return 'Cash Back';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.refunded:
        return 'Refunded';
    }
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['userId'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      recipientId: json['recipientId'],
      recipientName: json['recipientName'],
      recipientEmail: json['recipientEmail'],
      merchantName: json['merchantName'],
      merchantId: json['merchantId'],
      description: json['description'],
      note: json['note'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      paymentMethodId: json['paymentMethodId'],
      invoiceId: json['invoiceId'],
      feeAmount: json['feeAmount'] != null ? (json['feeAmount'] as num).toDouble() : null,
      referenceNumber: json['referenceNumber'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'amount': amount,
      'currency': currency,
      'recipientId': recipientId,
      'recipientName': recipientName,
      'recipientEmail': recipientEmail,
      'merchantName': merchantName,
      'merchantId': merchantId,
      'description': description,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'paymentMethodId': paymentMethodId,
      'invoiceId': invoiceId,
      'feeAmount': feeAmount,
      'referenceNumber': referenceNumber,
      'metadata': metadata,
    };
  }

  Transaction copyWith({
    String? id,
    String? userId,
    TransactionType? type,
    TransactionStatus? status,
    double? amount,
    String? currency,
    String? recipientId,
    String? recipientName,
    String? recipientEmail,
    String? merchantName,
    String? merchantId,
    String? description,
    String? note,
    DateTime? createdAt,
    DateTime? completedAt,
    String? paymentMethodId,
    String? invoiceId,
    double? feeAmount,
    String? referenceNumber,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      merchantName: merchantName ?? this.merchantName,
      merchantId: merchantId ?? this.merchantId,
      description: description ?? this.description,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      invoiceId: invoiceId ?? this.invoiceId,
      feeAmount: feeAmount ?? this.feeAmount,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      metadata: metadata ?? this.metadata,
    );
  }
}