class User {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final String? website;
  final int followersCount;
  final int followingCount;
  final int pinsCount;
  final int boardsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isVerified;
  final bool isPrivate;

  const User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.profileImageUrl,
    this.bio,
    this.website,
    this.followersCount = 0,
    this.followingCount = 0,
    this.pinsCount = 0,
    this.boardsCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isVerified = false,
    this.isPrivate = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      website: json['website'] as String?,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      pinsCount: json['pinsCount'] as int? ?? 0,
      boardsCount: json['boardsCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
      isPrivate: json['isPrivate'] as bool? ?? false,
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
      'website': website,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'pinsCount': pinsCount,
      'boardsCount': boardsCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isVerified': isVerified,
      'isPrivate': isPrivate,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? displayName,
    String? email,
    String? profileImageUrl,
    String? bio,
    String? website,
    int? followersCount,
    int? followingCount,
    int? pinsCount,
    int? boardsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    bool? isPrivate,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      pinsCount: pinsCount ?? this.pinsCount,
      boardsCount: boardsCount ?? this.boardsCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      isPrivate: isPrivate ?? this.isPrivate,
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