import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String username;
  final String displayName;
  final String? bio;
  final String? profileImageUrl;
  final String? instagramUsername;
  final bool isVerified;
  final bool isPrivate;
  final int followersCount;
  final int followingCount;
  final int threadsCount;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    this.bio,
    this.profileImageUrl,
    this.instagramUsername,
    this.isVerified = false,
    this.isPrivate = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.threadsCount = 0,
    required this.createdAt,
    this.lastActiveAt,
  });

  factory User.create({
    required String username,
    required String displayName,
    String? bio,
    String? profileImageUrl,
    String? instagramUsername,
  }) {
    return User(
      id: const Uuid().v4(),
      username: username,
      displayName: displayName,
      bio: bio,
      profileImageUrl: profileImageUrl,
      instagramUsername: instagramUsername,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      bio: json['bio'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      instagramUsername: json['instagramUsername'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      threadsCount: json['threadsCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: json['lastActiveAt'] != null
          ? DateTime.parse(json['lastActiveAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'instagramUsername': instagramUsername,
      'isVerified': isVerified,
      'isPrivate': isPrivate,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'threadsCount': threadsCount,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? bio,
    String? profileImageUrl,
    String? instagramUsername,
    bool? isVerified,
    bool? isPrivate,
    int? followersCount,
    int? followingCount,
    int? threadsCount,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      instagramUsername: instagramUsername ?? this.instagramUsername,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      threadsCount: threadsCount ?? this.threadsCount,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
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