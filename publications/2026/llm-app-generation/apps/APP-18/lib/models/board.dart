enum BoardPrivacy {
  public,
  secret,
}

class Board {
  final String id;
  final String name;
  final String? description;
  final String userId;
  final String username;
  final String? userProfileImageUrl;
  final BoardPrivacy privacy;
  final String? coverImageUrl;
  final List<String> collaboratorIds;
  final int pinsCount;
  final int followersCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFollowing;
  final List<String> tags;
  final String? category;

  const Board({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.username,
    this.userProfileImageUrl,
    this.privacy = BoardPrivacy.public,
    this.coverImageUrl,
    this.collaboratorIds = const [],
    this.pinsCount = 0,
    this.followersCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isFollowing = false,
    this.tags = const [],
    this.category,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userProfileImageUrl: json['userProfileImageUrl'] as String?,
      privacy: BoardPrivacy.values.firstWhere(
        (e) => e.name == json['privacy'],
        orElse: () => BoardPrivacy.public,
      ),
      coverImageUrl: json['coverImageUrl'] as String?,
      collaboratorIds: List<String>.from(json['collaboratorIds'] ?? []),
      pinsCount: json['pinsCount'] as int? ?? 0,
      followersCount: json['followersCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isFollowing: json['isFollowing'] as bool? ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'username': username,
      'userProfileImageUrl': userProfileImageUrl,
      'privacy': privacy.name,
      'coverImageUrl': coverImageUrl,
      'collaboratorIds': collaboratorIds,
      'pinsCount': pinsCount,
      'followersCount': followersCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFollowing': isFollowing,
      'tags': tags,
      'category': category,
    };
  }

  Board copyWith({
    String? id,
    String? name,
    String? description,
    String? userId,
    String? username,
    String? userProfileImageUrl,
    BoardPrivacy? privacy,
    String? coverImageUrl,
    List<String>? collaboratorIds,
    int? pinsCount,
    int? followersCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFollowing,
    List<String>? tags,
    String? category,
  }) {
    return Board(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      privacy: privacy ?? this.privacy,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      collaboratorIds: collaboratorIds ?? this.collaboratorIds,
      pinsCount: pinsCount ?? this.pinsCount,
      followersCount: followersCount ?? this.followersCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFollowing: isFollowing ?? this.isFollowing,
      tags: tags ?? this.tags,
      category: category ?? this.category,
    );
  }

  bool get isSecret => privacy == BoardPrivacy.secret;
  bool get isPublic => privacy == BoardPrivacy.public;
  bool get hasCollaborators => collaboratorIds.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Board && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Board(id: $id, name: $name, privacy: $privacy)';
  }
}