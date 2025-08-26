class Caixinha {
  final String id;
  final String userId;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final String? iconName;
  final String? color;
  final DateTime createdAt;
  final DateTime? targetDate;
  final bool isActive;
  final CaixinhaType type;

  const Caixinha({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    this.iconName,
    this.color,
    required this.createdAt,
    this.targetDate,
    this.isActive = true,
    required this.type,
  });

  factory Caixinha.fromJson(Map<String, dynamic> json) {
    return Caixinha(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      iconName: json['iconName'] as String?,
      color: json['color'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      targetDate: json['targetDate'] != null 
          ? DateTime.parse(json['targetDate'] as String) 
          : null,
      isActive: json['isActive'] as bool? ?? true,
      type: CaixinhaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => CaixinhaType.general,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'iconName': iconName,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'targetDate': targetDate?.toIso8601String(),
      'isActive': isActive,
      'type': type.toString().split('.').last,
    };
  }

  Caixinha copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? targetAmount,
    double? currentAmount,
    String? iconName,
    String? color,
    DateTime? createdAt,
    DateTime? targetDate,
    bool? isActive,
    CaixinhaType? type,
  }) {
    return Caixinha(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      iconName: iconName ?? this.iconName,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      targetDate: targetDate ?? this.targetDate,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
    );
  }

  String get formattedTargetAmount {
    return 'R\$ ${targetAmount.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  String get formattedCurrentAmount {
    return 'R\$ ${currentAmount.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  double get progressPercentage {
    if (targetAmount == 0) return 0;
    return (currentAmount / targetAmount) * 100;
  }

  bool get isCompleted => currentAmount >= targetAmount;

  double get remainingAmount => targetAmount - currentAmount;

  String get formattedRemainingAmount {
    return 'R\$ ${remainingAmount.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}

enum CaixinhaType {
  emergency,
  vacation,
  house,
  car,
  education,
  health,
  general,
}