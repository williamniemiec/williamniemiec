class Account {
  final String id;
  final String userId;
  final double balance;
  final String accountNumber;
  final String agency;
  final AccountType type;
  final DateTime createdAt;
  final bool isActive;
  final double savingsBalance;

  const Account({
    required this.id,
    required this.userId,
    required this.balance,
    required this.accountNumber,
    required this.agency,
    required this.type,
    required this.createdAt,
    this.isActive = true,
    this.savingsBalance = 0.0,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num).toDouble(),
      accountNumber: json['accountNumber'] as String,
      agency: json['agency'] as String,
      type: AccountType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AccountType.checking,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      savingsBalance: (json['savingsBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': balance,
      'accountNumber': accountNumber,
      'agency': agency,
      'type': type.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
      'savingsBalance': savingsBalance,
    };
  }

  Account copyWith({
    String? id,
    String? userId,
    double? balance,
    String? accountNumber,
    String? agency,
    AccountType? type,
    DateTime? createdAt,
    bool? isActive,
    double? savingsBalance,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      accountNumber: accountNumber ?? this.accountNumber,
      agency: agency ?? this.agency,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      savingsBalance: savingsBalance ?? this.savingsBalance,
    );
  }

  String get formattedBalance {
    return 'R\$ ${balance.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get formattedSavingsBalance {
    return 'R\$ ${savingsBalance.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

enum AccountType {
  checking,
  savings,
  investment,
}