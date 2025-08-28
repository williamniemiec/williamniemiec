class User {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int likesCount;
  final bool isVerified;
  final bool isFollowing;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesCount = 0,
    this.isVerified = false,
    this.isFollowing = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      likesCount: json['likesCount'] as int? ?? 0,
      isVerified: json['isVerified'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'displayName': displayName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'likesCount': likesCount,
      'isVerified': isVerified,
      'isFollowing': isFollowing,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? email,
    String? profileImageUrl,
    String? bio,
    int? followersCount,
    int? followingCount,
    int? likesCount,
    bool? isVerified,
    bool? isFollowing,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      likesCount: likesCount ?? this.likesCount,
      isVerified: isVerified ?? this.isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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