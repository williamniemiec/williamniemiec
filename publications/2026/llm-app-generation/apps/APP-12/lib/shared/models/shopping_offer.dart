class ShoppingOffer {
  final String id;
  final String merchantName;
  final String merchantLogo;
  final String title;
  final String description;
  final double cashbackPercentage;
  final double? fixedCashback;
  final String category;
  final DateTime validUntil;
  final bool isActive;
  final String? promoCode;
  final String? deepLink;
  final List<String> tags;
  final OfferType type;

  const ShoppingOffer({
    required this.id,
    required this.merchantName,
    required this.merchantLogo,
    required this.title,
    required this.description,
    required this.cashbackPercentage,
    this.fixedCashback,
    required this.category,
    required this.validUntil,
    this.isActive = true,
    this.promoCode,
    this.deepLink,
    this.tags = const [],
    required this.type,
  });

  factory ShoppingOffer.fromJson(Map<String, dynamic> json) {
    return ShoppingOffer(
      id: json['id'] as String,
      merchantName: json['merchantName'] as String,
      merchantLogo: json['merchantLogo'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      cashbackPercentage: (json['cashbackPercentage'] as num).toDouble(),
      fixedCashback: (json['fixedCashback'] as num?)?.toDouble(),
      category: json['category'] as String,
      validUntil: DateTime.parse(json['validUntil'] as String),
      isActive: json['isActive'] as bool? ?? true,
      promoCode: json['promoCode'] as String?,
      deepLink: json['deepLink'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      type: OfferType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => OfferType.cashback,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'merchantLogo': merchantLogo,
      'title': title,
      'description': description,
      'cashbackPercentage': cashbackPercentage,
      'fixedCashback': fixedCashback,
      'category': category,
      'validUntil': validUntil.toIso8601String(),
      'isActive': isActive,
      'promoCode': promoCode,
      'deepLink': deepLink,
      'tags': tags,
      'type': type.toString().split('.').last,
    };
  }

  ShoppingOffer copyWith({
    String? id,
    String? merchantName,
    String? merchantLogo,
    String? title,
    String? description,
    double? cashbackPercentage,
    double? fixedCashback,
    String? category,
    DateTime? validUntil,
    bool? isActive,
    String? promoCode,
    String? deepLink,
    List<String>? tags,
    OfferType? type,
  }) {
    return ShoppingOffer(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      merchantLogo: merchantLogo ?? this.merchantLogo,
      title: title ?? this.title,
      description: description ?? this.description,
      cashbackPercentage: cashbackPercentage ?? this.cashbackPercentage,
      fixedCashback: fixedCashback ?? this.fixedCashback,
      category: category ?? this.category,
      validUntil: validUntil ?? this.validUntil,
      isActive: isActive ?? this.isActive,
      promoCode: promoCode ?? this.promoCode,
      deepLink: deepLink ?? this.deepLink,
      tags: tags ?? this.tags,
      type: type ?? this.type,
    );
  }

  String get formattedCashback {
    if (fixedCashback != null) {
      return 'R\$ ${fixedCashback!.toStringAsFixed(2).replaceAll('.', ',')} de volta';
    }
    return '${cashbackPercentage.toStringAsFixed(1)}% de volta';
  }

  bool get isExpired => DateTime.now().isAfter(validUntil);

  int get daysUntilExpiry {
    final now = DateTime.now();
    if (isExpired) return 0;
    return validUntil.difference(now).inDays;
  }

  String get expiryText {
    if (isExpired) return 'Expirado';
    final days = daysUntilExpiry;
    if (days == 0) return 'Expira hoje';
    if (days == 1) return 'Expira amanhã';
    return 'Expira em $days dias';
  }
}

enum OfferType {
  cashback,
  discount,
  freeShipping,
  giftCard,
}