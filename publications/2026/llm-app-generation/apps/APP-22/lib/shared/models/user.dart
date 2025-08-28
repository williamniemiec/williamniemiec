enum SubscriptionType {
  free,
  premium,
  student,
  family,
}

class User {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? profileImage;
  final SubscriptionType subscriptionType;
  final DateTime? subscriptionExpiryDate;
  final List<String> followingIds;
  final List<String> followerIds;
  final int playlistCount;
  final int followingCount;
  final int followerCount;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final Map<String, dynamic> preferences;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.profileImage,
    this.subscriptionType = SubscriptionType.free,
    this.subscriptionExpiryDate,
    this.followingIds = const [],
    this.followerIds = const [],
    this.playlistCount = 0,
    this.followingCount = 0,
    this.followerCount = 0,
    required this.createdAt,
    required this.lastActiveAt,
    this.preferences = const {},
  });

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? email,
    String? profileImage,
    SubscriptionType? subscriptionType,
    DateTime? subscriptionExpiryDate,
    List<String>? followingIds,
    List<String>? followerIds,
    int? playlistCount,
    int? followingCount,
    int? followerCount,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      subscriptionExpiryDate: subscriptionExpiryDate ?? this.subscriptionExpiryDate,
      followingIds: followingIds ?? this.followingIds,
      followerIds: followerIds ?? this.followerIds,
      playlistCount: playlistCount ?? this.playlistCount,
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      preferences: preferences ?? this.preferences,
    );
  }

  bool get isPremium => subscriptionType != SubscriptionType.free;

  bool get isSubscriptionActive {
    if (subscriptionType == SubscriptionType.free) return false;
    if (subscriptionExpiryDate == null) return true;
    return DateTime.now().isBefore(subscriptionExpiryDate!);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'profileImage': profileImage,
      'subscriptionType': subscriptionType.name,
      'subscriptionExpiryDate': subscriptionExpiryDate?.toIso8601String(),
      'followingIds': followingIds,
      'followerIds': followerIds,
      'playlistCount': playlistCount,
      'followingCount': followingCount,
      'followerCount': followerCount,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'preferences': preferences,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      subscriptionType: SubscriptionType.values.firstWhere(
        (type) => type.name == json['subscriptionType'],
        orElse: () => SubscriptionType.free,
      ),
      subscriptionExpiryDate: json['subscriptionExpiryDate'] != null
          ? DateTime.parse(json['subscriptionExpiryDate'] as String)
          : null,
      followingIds: List<String>.from(json['followingIds'] as List? ?? []),
      followerIds: List<String>.from(json['followerIds'] as List? ?? []),
      playlistCount: json['playlistCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      followerCount: json['followerCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
      preferences: Map<String, dynamic>.from(json['preferences'] as Map? ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, username: $username, displayName: $displayName)';
  }
}