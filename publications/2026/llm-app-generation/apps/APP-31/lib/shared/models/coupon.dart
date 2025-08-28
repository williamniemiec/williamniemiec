class Coupon {
  final String id;
  final String code;
  final String title;
  final String description;
  final CouponType type;
  final double value;
  final double? minimumOrderAmount;
  final DateTime expiryDate;
  final bool isUsed;
  final DateTime? usedAt;
  final String? applicableCategory;
  final List<String>? applicableProductIds;

  Coupon({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    this.minimumOrderAmount,
    required this.expiryDate,
    required this.isUsed,
    this.usedAt,
    this.applicableCategory,
    this.applicableProductIds,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isValid => !isUsed && !isExpired;

  String get displayValue {
    switch (type) {
      case CouponType.percentage:
        return '${value.toInt()}% OFF';
      case CouponType.fixedAmount:
        return '\$${value.toStringAsFixed(2)} OFF';
      case CouponType.freeShipping:
        return 'FREE SHIPPING';
    }
  }

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: CouponType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => CouponType.percentage,
      ),
      value: (json['value'] ?? 0).toDouble(),
      minimumOrderAmount: json['minimumOrderAmount']?.toDouble(),
      expiryDate: DateTime.parse(json['expiryDate'] ?? DateTime.now().toIso8601String()),
      isUsed: json['isUsed'] ?? false,
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      applicableCategory: json['applicableCategory'],
      applicableProductIds: json['applicableProductIds'] != null
          ? List<String>.from(json['applicableProductIds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'value': value,
      'minimumOrderAmount': minimumOrderAmount,
      'expiryDate': expiryDate.toIso8601String(),
      'isUsed': isUsed,
      'usedAt': usedAt?.toIso8601String(),
      'applicableCategory': applicableCategory,
      'applicableProductIds': applicableProductIds,
    };
  }
}

enum CouponType {
  percentage,
  fixedAmount,
  freeShipping,
}