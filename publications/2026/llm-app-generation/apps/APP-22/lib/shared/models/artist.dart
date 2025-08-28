class Artist {
  final String id;
  final String name;
  final String? bio;
  final String profileImage;
  final List<String> genres;
  final int followerCount;
  final bool isFollowing;
  final double popularity;
  final int monthlyListeners;
  final List<String> topTrackIds;
  final List<String> albumIds;
  final bool isVerified;
  final Map<String, String> socialLinks;

  const Artist({
    required this.id,
    required this.name,
    this.bio,
    required this.profileImage,
    this.genres = const [],
    this.followerCount = 0,
    this.isFollowing = false,
    this.popularity = 0.0,
    this.monthlyListeners = 0,
    this.topTrackIds = const [],
    this.albumIds = const [],
    this.isVerified = false,
    this.socialLinks = const {},
  });

  Artist copyWith({
    String? id,
    String? name,
    String? bio,
    String? profileImage,
    List<String>? genres,
    int? followerCount,
    bool? isFollowing,
    double? popularity,
    int? monthlyListeners,
    List<String>? topTrackIds,
    List<String>? albumIds,
    bool? isVerified,
    Map<String, String>? socialLinks,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      genres: genres ?? this.genres,
      followerCount: followerCount ?? this.followerCount,
      isFollowing: isFollowing ?? this.isFollowing,
      popularity: popularity ?? this.popularity,
      monthlyListeners: monthlyListeners ?? this.monthlyListeners,
      topTrackIds: topTrackIds ?? this.topTrackIds,
      albumIds: albumIds ?? this.albumIds,
      isVerified: isVerified ?? this.isVerified,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }

  String get formattedFollowerCount {
    if (followerCount >= 1000000) {
      return '${(followerCount / 1000000).toStringAsFixed(1)}M';
    } else if (followerCount >= 1000) {
      return '${(followerCount / 1000).toStringAsFixed(1)}K';
    }
    return followerCount.toString();
  }

  String get formattedMonthlyListeners {
    if (monthlyListeners >= 1000000) {
      return '${(monthlyListeners / 1000000).toStringAsFixed(1)}M';
    } else if (monthlyListeners >= 1000) {
      return '${(monthlyListeners / 1000).toStringAsFixed(1)}K';
    }
    return monthlyListeners.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'profileImage': profileImage,
      'genres': genres,
      'followerCount': followerCount,
      'isFollowing': isFollowing,
      'popularity': popularity,
      'monthlyListeners': monthlyListeners,
      'topTrackIds': topTrackIds,
      'albumIds': albumIds,
      'isVerified': isVerified,
      'socialLinks': socialLinks,
    };
  }

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String?,
      profileImage: json['profileImage'] as String,
      genres: List<String>.from(json['genres'] as List? ?? []),
      followerCount: json['followerCount'] as int? ?? 0,
      isFollowing: json['isFollowing'] as bool? ?? false,
      popularity: (json['popularity'] as num?)?.toDouble() ?? 0.0,
      monthlyListeners: json['monthlyListeners'] as int? ?? 0,
      topTrackIds: List<String>.from(json['topTrackIds'] as List? ?? []),
      albumIds: List<String>.from(json['albumIds'] as List? ?? []),
      isVerified: json['isVerified'] as bool? ?? false,
      socialLinks: Map<String, String>.from(json['socialLinks'] as Map? ?? {}),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Artist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, followers: $formattedFollowerCount)';
  }
}