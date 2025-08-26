import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String? name;
  final String? email;
  final DateTime createdAt;
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final int dailyUsageCount;
  final DateTime? lastUsageReset;

  const User({
    required this.id,
    this.name,
    this.email,
    required this.createdAt,
    this.isPremium = false,
    this.premiumExpiresAt,
    this.dailyUsageCount = 0,
    this.lastUsageReset,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    int? dailyUsageCount,
    DateTime? lastUsageReset,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      dailyUsageCount: dailyUsageCount ?? this.dailyUsageCount,
      lastUsageReset: lastUsageReset ?? this.lastUsageReset,
    );
  }

  bool get hasValidPremium {
    if (!isPremium) return false;
    if (premiumExpiresAt == null) return true; // Lifetime subscription
    return premiumExpiresAt!.isAfter(DateTime.now());
  }

  bool get needsUsageReset {
    if (lastUsageReset == null) return true;
    final now = DateTime.now();
    final lastReset = lastUsageReset!;
    return now.day != lastReset.day || 
           now.month != lastReset.month || 
           now.year != lastReset.year;
  }
}