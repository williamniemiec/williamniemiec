enum AchievementType {
  streak,
  xp,
  lessons,
  perfect,
  social,
  special,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final String iconUrl;
  final int targetValue;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int xpReward;
  final int gemsReward;
  final String rarity; // common, rare, epic, legendary

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.iconUrl,
    required this.targetValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
    this.xpReward = 50,
    this.gemsReward = 10,
    this.rarity = 'common',
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    String? iconUrl,
    int? targetValue,
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? xpReward,
    int? gemsReward,
    String? rarity,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      xpReward: xpReward ?? this.xpReward,
      gemsReward: gemsReward ?? this.gemsReward,
      rarity: rarity ?? this.rarity,
    );
  }

  double get progress => targetValue > 0 ? currentValue / targetValue : 0.0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'iconUrl': iconUrl,
      'targetValue': targetValue,
      'currentValue': currentValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'xpReward': xpReward,
      'gemsReward': gemsReward,
      'rarity': rarity,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: AchievementType.values.firstWhere((e) => e.name == json['type']),
      iconUrl: json['iconUrl'],
      targetValue: json['targetValue'],
      currentValue: json['currentValue'] ?? 0,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt']) 
          : null,
      xpReward: json['xpReward'] ?? 50,
      gemsReward: json['gemsReward'] ?? 10,
      rarity: json['rarity'] ?? 'common',
    );
  }
}