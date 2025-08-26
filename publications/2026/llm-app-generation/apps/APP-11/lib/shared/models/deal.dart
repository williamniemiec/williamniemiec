enum DealType {
  cashBack,
  discount,
  freeShipping,
  buyOneGetOne,
}

enum DealStatus {
  active,
  expired,
  used,
  saved,
}

class Deal {
  final String id;
  final String merchantId;
  final String merchantName;
  final String merchantLogoUrl;
  final String title;
  final String description;
  final DealType type;
  final DealStatus status;
  final double? cashBackPercentage;
  final double? discountAmount;
  final double? discountPercentage;
  final double? minimumPurchase;
  final DateTime startDate;
  final DateTime endDate;
  final String? termsAndConditions;
  final List<String> categories;
  final int usageCount;
  final int? maxUsage;
  final bool isExclusive;
  final DateTime createdAt;
  final DateTime? savedAt;
  final DateTime? usedAt;

  Deal({
    required this.id,
    required this.merchantId,
    required this.merchantName,
    required this.merchantLogoUrl,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    this.cashBackPercentage,
    this.discountAmount,
    this.discountPercentage,
    this.minimumPurchase,
    required this.startDate,
    required this.endDate,
    this.termsAndConditions,
    required this.categories,
    required this.usageCount,
    this.maxUsage,
    required this.isExclusive,
    required this.createdAt,
    this.savedAt,
    this.usedAt,
  });

  bool get isActive => status == DealStatus.active && DateTime.now().isBefore(endDate);
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get isSaved => status == DealStatus.saved;
  bool get isUsed => status == DealStatus.used;
  bool get hasUsageLimit => maxUsage != null;
  bool get isUsageLimitReached => maxUsage != null && usageCount >= maxUsage!;

  String get typeDisplayName {
    switch (type) {
      case DealType.cashBack:
        return 'Cash Back';
      case DealType.discount:
        return 'Discount';
      case DealType.freeShipping:
        return 'Free Shipping';
      case DealType.buyOneGetOne:
        return 'Buy One Get One';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case DealStatus.active:
        return 'Active';
      case DealStatus.expired:
        return 'Expired';
      case DealStatus.used:
        return 'Used';
      case DealStatus.saved:
        return 'Saved';
    }
  }

  String get dealValue {
    switch (type) {
      case DealType.cashBack:
        return '${cashBackPercentage?.toStringAsFixed(1)}% Cash Back';
      case DealType.discount:
        if (discountPercentage != null) {
          return '${discountPercentage?.toStringAsFixed(0)}% Off';
        } else if (discountAmount != null) {
          return '\$${discountAmount?.toStringAsFixed(2)} Off';
        }
        return 'Discount';
      case DealType.freeShipping:
        return 'Free Shipping';
      case DealType.buyOneGetOne:
        return 'Buy One Get One';
    }
  }

  String get minimumPurchaseText {
    if (minimumPurchase != null && minimumPurchase! > 0) {
      return 'Min. purchase: \$${minimumPurchase!.toStringAsFixed(2)}';
    }
    return '';
  }

  int get daysUntilExpiry {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  String get expiryText {
    final days = daysUntilExpiry;
    if (days == 0) return 'Expires today';
    if (days == 1) return 'Expires tomorrow';
    if (days <= 7) return 'Expires in $days days';
    return 'Expires ${endDate.day}/${endDate.month}/${endDate.year}';
  }

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['id'],
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      merchantLogoUrl: json['merchantLogoUrl'],
      title: json['title'],
      description: json['description'],
      type: DealType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      status: DealStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      cashBackPercentage: json['cashBackPercentage'] != null 
          ? (json['cashBackPercentage'] as num).toDouble() 
          : null,
      discountAmount: json['discountAmount'] != null 
          ? (json['discountAmount'] as num).toDouble() 
          : null,
      discountPercentage: json['discountPercentage'] != null 
          ? (json['discountPercentage'] as num).toDouble() 
          : null,
      minimumPurchase: json['minimumPurchase'] != null 
          ? (json['minimumPurchase'] as num).toDouble() 
          : null,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      termsAndConditions: json['termsAndConditions'],
      categories: List<String>.from(json['categories']),
      usageCount: json['usageCount'],
      maxUsage: json['maxUsage'],
      isExclusive: json['isExclusive'],
      createdAt: DateTime.parse(json['createdAt']),
      savedAt: json['savedAt'] != null ? DateTime.parse(json['savedAt']) : null,
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantId': merchantId,
      'merchantName': merchantName,
      'merchantLogoUrl': merchantLogoUrl,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'cashBackPercentage': cashBackPercentage,
      'discountAmount': discountAmount,
      'discountPercentage': discountPercentage,
      'minimumPurchase': minimumPurchase,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'termsAndConditions': termsAndConditions,
      'categories': categories,
      'usageCount': usageCount,
      'maxUsage': maxUsage,
      'isExclusive': isExclusive,
      'createdAt': createdAt.toIso8601String(),
      'savedAt': savedAt?.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
    };
  }

  Deal copyWith({
    String? id,
    String? merchantId,
    String? merchantName,
    String? merchantLogoUrl,
    String? title,
    String? description,
    DealType? type,
    DealStatus? status,
    double? cashBackPercentage,
    double? discountAmount,
    double? discountPercentage,
    double? minimumPurchase,
    DateTime? startDate,
    DateTime? endDate,
    String? termsAndConditions,
    List<String>? categories,
    int? usageCount,
    int? maxUsage,
    bool? isExclusive,
    DateTime? createdAt,
    DateTime? savedAt,
    DateTime? usedAt,
  }) {
    return Deal(
      id: id ?? this.id,
      merchantId: merchantId ?? this.merchantId,
      merchantName: merchantName ?? this.merchantName,
      merchantLogoUrl: merchantLogoUrl ?? this.merchantLogoUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      cashBackPercentage: cashBackPercentage ?? this.cashBackPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      minimumPurchase: minimumPurchase ?? this.minimumPurchase,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      categories: categories ?? this.categories,
      usageCount: usageCount ?? this.usageCount,
      maxUsage: maxUsage ?? this.maxUsage,
      isExclusive: isExclusive ?? this.isExclusive,
      createdAt: createdAt ?? this.createdAt,
      savedAt: savedAt ?? this.savedAt,
      usedAt: usedAt ?? this.usedAt,
    );
  }
}