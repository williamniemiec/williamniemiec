enum PaymentMethodType {
  bankAccount,
  creditCard,
  debitCard,
  paypalBalance,
  paypalCredit,
}

enum BankAccountType {
  checking,
  savings,
}

enum CardBrand {
  visa,
  mastercard,
  americanExpress,
  discover,
  unknown,
}

class PaymentMethod {
  final String id;
  final String userId;
  final PaymentMethodType type;
  final String displayName;
  final String? lastFourDigits;
  final String? bankName;
  final BankAccountType? bankAccountType;
  final CardBrand? cardBrand;
  final String? expiryMonth;
  final String? expiryYear;
  final bool isDefault;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final Map<String, dynamic>? metadata;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.displayName,
    this.lastFourDigits,
    this.bankName,
    this.bankAccountType,
    this.cardBrand,
    this.expiryMonth,
    this.expiryYear,
    required this.isDefault,
    required this.isVerified,
    required this.createdAt,
    this.lastUsedAt,
    this.metadata,
  });

  String get typeDisplayName {
    switch (type) {
      case PaymentMethodType.bankAccount:
        return 'Bank Account';
      case PaymentMethodType.creditCard:
        return 'Credit Card';
      case PaymentMethodType.debitCard:
        return 'Debit Card';
      case PaymentMethodType.paypalBalance:
        return 'PayPal Balance';
      case PaymentMethodType.paypalCredit:
        return 'PayPal Credit';
    }
  }

  String get cardBrandDisplayName {
    switch (cardBrand) {
      case CardBrand.visa:
        return 'Visa';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.americanExpress:
        return 'American Express';
      case CardBrand.discover:
        return 'Discover';
      case CardBrand.unknown:
      case null:
        return 'Unknown';
    }
  }

  String get bankAccountTypeDisplayName {
    switch (bankAccountType) {
      case BankAccountType.checking:
        return 'Checking';
      case BankAccountType.savings:
        return 'Savings';
      case null:
        return '';
    }
  }

  String get maskedNumber {
    if (lastFourDigits != null) {
      if (type == PaymentMethodType.bankAccount) {
        return '****$lastFourDigits';
      } else {
        return '**** **** **** $lastFourDigits';
      }
    }
    return '';
  }

  String get fullDisplayName {
    switch (type) {
      case PaymentMethodType.bankAccount:
        return '$bankName $bankAccountTypeDisplayName $maskedNumber';
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return '$cardBrandDisplayName $maskedNumber';
      case PaymentMethodType.paypalBalance:
        return 'PayPal Balance';
      case PaymentMethodType.paypalCredit:
        return 'PayPal Credit';
    }
  }

  bool get isExpired {
    if (expiryMonth == null || expiryYear == null) return false;
    
    final now = DateTime.now();
    final expiry = DateTime(
      int.parse('20$expiryYear!'),
      int.parse(expiryMonth!),
    );
    
    return now.isAfter(expiry);
  }

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      userId: json['userId'],
      type: PaymentMethodType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      displayName: json['displayName'],
      lastFourDigits: json['lastFourDigits'],
      bankName: json['bankName'],
      bankAccountType: json['bankAccountType'] != null
          ? BankAccountType.values.firstWhere(
              (e) => e.toString().split('.').last == json['bankAccountType'],
            )
          : null,
      cardBrand: json['cardBrand'] != null
          ? CardBrand.values.firstWhere(
              (e) => e.toString().split('.').last == json['cardBrand'],
            )
          : null,
      expiryMonth: json['expiryMonth'],
      expiryYear: json['expiryYear'],
      isDefault: json['isDefault'],
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUsedAt: json['lastUsedAt'] != null ? DateTime.parse(json['lastUsedAt']) : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.toString().split('.').last,
      'displayName': displayName,
      'lastFourDigits': lastFourDigits,
      'bankName': bankName,
      'bankAccountType': bankAccountType?.toString().split('.').last,
      'cardBrand': cardBrand?.toString().split('.').last,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'isDefault': isDefault,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  PaymentMethod copyWith({
    String? id,
    String? userId,
    PaymentMethodType? type,
    String? displayName,
    String? lastFourDigits,
    String? bankName,
    BankAccountType? bankAccountType,
    CardBrand? cardBrand,
    String? expiryMonth,
    String? expiryYear,
    bool? isDefault,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      bankName: bankName ?? this.bankName,
      bankAccountType: bankAccountType ?? this.bankAccountType,
      cardBrand: cardBrand ?? this.cardBrand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      isDefault: isDefault ?? this.isDefault,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}