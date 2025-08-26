class CreditCard {
  final String id;
  final String userId;
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;
  final String cvv;
  final double creditLimit;
  final double availableLimit;
  final double currentBill;
  final double closedBill;
  final DateTime? billDueDate;
  final DateTime? billClosingDate;
  final CardBrand brand;
  final CardStatus status;
  final bool isVirtual;
  final String? nickname;
  final DateTime createdAt;

  const CreditCard({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
    required this.cvv,
    required this.creditLimit,
    required this.availableLimit,
    required this.currentBill,
    required this.closedBill,
    this.billDueDate,
    this.billClosingDate,
    required this.brand,
    required this.status,
    this.isVirtual = false,
    this.nickname,
    required this.createdAt,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cardNumber: json['cardNumber'] as String,
      cardHolderName: json['cardHolderName'] as String,
      expiryDate: json['expiryDate'] as String,
      cvv: json['cvv'] as String,
      creditLimit: (json['creditLimit'] as num).toDouble(),
      availableLimit: (json['availableLimit'] as num).toDouble(),
      currentBill: (json['currentBill'] as num).toDouble(),
      closedBill: (json['closedBill'] as num).toDouble(),
      billDueDate: json['billDueDate'] != null 
          ? DateTime.parse(json['billDueDate'] as String) 
          : null,
      billClosingDate: json['billClosingDate'] != null 
          ? DateTime.parse(json['billClosingDate'] as String) 
          : null,
      brand: CardBrand.values.firstWhere(
        (e) => e.toString().split('.').last == json['brand'],
        orElse: () => CardBrand.mastercard,
      ),
      status: CardStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => CardStatus.active,
      ),
      isVirtual: json['isVirtual'] as bool? ?? false,
      nickname: json['nickname'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'creditLimit': creditLimit,
      'availableLimit': availableLimit,
      'currentBill': currentBill,
      'closedBill': closedBill,
      'billDueDate': billDueDate?.toIso8601String(),
      'billClosingDate': billClosingDate?.toIso8601String(),
      'brand': brand.toString().split('.').last,
      'status': status.toString().split('.').last,
      'isVirtual': isVirtual,
      'nickname': nickname,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CreditCard copyWith({
    String? id,
    String? userId,
    String? cardNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cvv,
    double? creditLimit,
    double? availableLimit,
    double? currentBill,
    double? closedBill,
    DateTime? billDueDate,
    DateTime? billClosingDate,
    CardBrand? brand,
    CardStatus? status,
    bool? isVirtual,
    String? nickname,
    DateTime? createdAt,
  }) {
    return CreditCard(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
      creditLimit: creditLimit ?? this.creditLimit,
      availableLimit: availableLimit ?? this.availableLimit,
      currentBill: currentBill ?? this.currentBill,
      closedBill: closedBill ?? this.closedBill,
      billDueDate: billDueDate ?? this.billDueDate,
      billClosingDate: billClosingDate ?? this.billClosingDate,
      brand: brand ?? this.brand,
      status: status ?? this.status,
      isVirtual: isVirtual ?? this.isVirtual,
      nickname: nickname ?? this.nickname,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get maskedCardNumber {
    if (cardNumber.length < 4) return cardNumber;
    return '**** **** **** ${cardNumber.substring(cardNumber.length - 4)}';
  }

  String get formattedCreditLimit {
    return 'R\$ ${creditLimit.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get formattedAvailableLimit {
    return 'R\$ ${availableLimit.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get formattedCurrentBill {
    return 'R\$ ${currentBill.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get formattedClosedBill {
    return 'R\$ ${closedBill.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  double get usedLimit => creditLimit - availableLimit;

  double get usagePercentage => (usedLimit / creditLimit) * 100;
}

enum CardBrand {
  mastercard,
  visa,
  elo,
  americanExpress,
}

enum CardStatus {
  active,
  blocked,
  cancelled,
  expired,
}