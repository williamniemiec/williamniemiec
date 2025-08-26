class Transaction {
  final String id;
  final String userId;
  final String? accountId;
  final String? creditCardId;
  final double amount;
  final String description;
  final String? category;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? recipientName;
  final String? recipientDocument;
  final String? pixKey;
  final String? authorizationCode;
  final Map<String, dynamic>? metadata;

  const Transaction({
    required this.id,
    required this.userId,
    this.accountId,
    this.creditCardId,
    required this.amount,
    required this.description,
    this.category,
    required this.type,
    required this.status,
    required this.createdAt,
    this.processedAt,
    this.recipientName,
    this.recipientDocument,
    this.pixKey,
    this.authorizationCode,
    this.metadata,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      accountId: json['accountId'] as String?,
      creditCardId: json['creditCardId'] as String?,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String?,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.other,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      processedAt: json['processedAt'] != null 
          ? DateTime.parse(json['processedAt'] as String) 
          : null,
      recipientName: json['recipientName'] as String?,
      recipientDocument: json['recipientDocument'] as String?,
      pixKey: json['pixKey'] as String?,
      authorizationCode: json['authorizationCode'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'accountId': accountId,
      'creditCardId': creditCardId,
      'amount': amount,
      'description': description,
      'category': category,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'recipientName': recipientName,
      'recipientDocument': recipientDocument,
      'pixKey': pixKey,
      'authorizationCode': authorizationCode,
      'metadata': metadata,
    };
  }

  Transaction copyWith({
    String? id,
    String? userId,
    String? accountId,
    String? creditCardId,
    double? amount,
    String? description,
    String? category,
    TransactionType? type,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? processedAt,
    String? recipientName,
    String? recipientDocument,
    String? pixKey,
    String? authorizationCode,
    Map<String, dynamic>? metadata,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      creditCardId: creditCardId ?? this.creditCardId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      recipientName: recipientName ?? this.recipientName,
      recipientDocument: recipientDocument ?? this.recipientDocument,
      pixKey: pixKey ?? this.pixKey,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedAmount {
    final prefix = isDebit ? '-' : '+';
    return '$prefix R\$ ${amount.abs().toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get absoluteFormattedAmount {
    return 'R\$ ${amount.abs().toStringAsFixed(2).replaceAll('.', ',')}';
  }

  bool get isDebit {
    return type == TransactionType.pixOut ||
           type == TransactionType.transfer ||
           type == TransactionType.billPayment ||
           type == TransactionType.purchase ||
           type == TransactionType.withdrawal;
  }

  bool get isCredit {
    return type == TransactionType.pixIn ||
           type == TransactionType.deposit ||
           type == TransactionType.refund ||
           type == TransactionType.cashback;
  }

  String get typeDisplayName {
    switch (type) {
      case TransactionType.pixIn:
        return 'Pix recebido';
      case TransactionType.pixOut:
        return 'Pix enviado';
      case TransactionType.transfer:
        return 'Transferência';
      case TransactionType.deposit:
        return 'Depósito';
      case TransactionType.withdrawal:
        return 'Saque';
      case TransactionType.billPayment:
        return 'Pagamento';
      case TransactionType.purchase:
        return 'Compra';
      case TransactionType.refund:
        return 'Estorno';
      case TransactionType.cashback:
        return 'Cashback';
      case TransactionType.other:
        return 'Outros';
    }
  }
}

enum TransactionType {
  pixIn,
  pixOut,
  transfer,
  deposit,
  withdrawal,
  billPayment,
  purchase,
  refund,
  cashback,
  other,
}

enum TransactionStatus {
  pending,
  completed,
  failed,
  cancelled,
  processing,
}