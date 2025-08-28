import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String displayName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String? bio;

  @HiveField(5)
  final String? location;

  @HiveField(6)
  final String? website;

  @HiveField(7)
  final String? profileImageUrl;

  @HiveField(8)
  final String? bannerImageUrl;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime updatedAt;

  @HiveField(11)
  final int followersCount;

  @HiveField(12)
  final int followingCount;

  @HiveField(13)
  final int postsCount;

  @HiveField(14)
  final bool isVerified;

  @HiveField(15)
  final bool isPremium;

  @HiveField(16)
  final bool isPrivate;

  @HiveField(17)
  final bool isFollowing;

  @HiveField(18)
  final bool isFollowedBy;

  @HiveField(19)
  final bool isBlocked;

  @HiveField(20)
  final bool isMuted;

  @HiveField(21)
  final List<String> interests;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.bio,
    this.location,
    this.website,
    this.profileImageUrl,
    this.bannerImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isVerified = false,
    this.isPremium = false,
    this.isPrivate = false,
    this.isFollowing = false,
    this.isFollowedBy = false,
    this.isBlocked = false,
    this.isMuted = false,
    this.interests = const [],
  });

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? email,
    String? bio,
    String? location,
    String? website,
    String? profileImageUrl,
    String? bannerImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? followersCount,
    int? followingCount,
    int? postsCount,
    bool? isVerified,
    bool? isPremium,
    bool? isPrivate,
    bool? isFollowing,
    bool? isFollowedBy,
    bool? isBlocked,
    bool? isMuted,
    List<String>? interests,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      website: website ?? this.website,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      isPrivate: isPrivate ?? this.isPrivate,
      isFollowing: isFollowing ?? this.isFollowing,
      isFollowedBy: isFollowedBy ?? this.isFollowedBy,
      isBlocked: isBlocked ?? this.isBlocked,
      isMuted: isMuted ?? this.isMuted,
      interests: interests ?? this.interests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'bio': bio,
      'location': location,
      'website': website,
      'profileImageUrl': profileImageUrl,
      'bannerImageUrl': bannerImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
      'isVerified': isVerified,
      'isPremium': isPremium,
      'isPrivate': isPrivate,
      'isFollowing': isFollowing,
      'isFollowedBy': isFollowedBy,
      'isBlocked': isBlocked,
      'isMuted': isMuted,
      'interests': interests,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      website: json['website'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      bannerImageUrl: json['bannerImageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      postsCount: json['postsCount'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isPremium: json['isPremium'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      isFollowedBy: json['isFollowedBy'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      interests: List<String>.from(json['interests'] as List? ?? []),
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