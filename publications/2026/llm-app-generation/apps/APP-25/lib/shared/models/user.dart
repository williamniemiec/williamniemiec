class RedditUser {
  final String id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String? bannerUrl;
  final int karma;
  final int commentKarma;
  final int linkKarma;
  final DateTime createdAt;
  final bool isVerified;
  final bool isPremium;
  final bool isModerator;
  final String? description;
  final List<String> trophies;
  final int followers;
  final int following;

  const RedditUser({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.bannerUrl,
    required this.karma,
    required this.commentKarma,
    required this.linkKarma,
    required this.createdAt,
    this.isVerified = false,
    this.isPremium = false,
    this.isModerator = false,
    this.description,
    this.trophies = const [],
    this.followers = 0,
    this.following = 0,
  });

  factory RedditUser.fromJson(Map<String, dynamic> json) {
    return RedditUser(
      id: json['id'] ?? '',
      username: json['name'] ?? '',
      displayName: json['subreddit']?['display_name'],
      avatarUrl: json['icon_img']?.isNotEmpty == true ? json['icon_img'] : null,
      bannerUrl: json['subreddit']?['banner_img'],
      karma: (json['total_karma'] ?? 0).toInt(),
      commentKarma: (json['comment_karma'] ?? 0).toInt(),
      linkKarma: (json['link_karma'] ?? 0).toInt(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((json['created_utc'] ?? 0) * 1000).toInt(),
      ),
      isVerified: json['verified'] ?? false,
      isPremium: json['is_gold'] ?? false,
      isModerator: json['is_mod'] ?? false,
      description: json['subreddit']?['public_description'],
      trophies: (json['trophies'] as List?)?.cast<String>() ?? [],
      followers: (json['subreddit']?['subscribers'] ?? 0).toInt(),
      following: (json['num_friends'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': username,
      'display_name': displayName,
      'icon_img': avatarUrl,
      'banner_img': bannerUrl,
      'total_karma': karma,
      'comment_karma': commentKarma,
      'link_karma': linkKarma,
      'created_utc': createdAt.millisecondsSinceEpoch / 1000,
      'verified': isVerified,
      'is_gold': isPremium,
      'is_mod': isModerator,
      'public_description': description,
      'trophies': trophies,
      'subscribers': followers,
      'num_friends': following,
    };
  }

  RedditUser copyWith({
    String? id,
    String? username,
    String? displayName,
    String? avatarUrl,
    String? bannerUrl,
    int? karma,
    int? commentKarma,
    int? linkKarma,
    DateTime? createdAt,
    bool? isVerified,
    bool? isPremium,
    bool? isModerator,
    String? description,
    List<String>? trophies,
    int? followers,
    int? following,
  }) {
    return RedditUser(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      karma: karma ?? this.karma,
      commentKarma: commentKarma ?? this.commentKarma,
      linkKarma: linkKarma ?? this.linkKarma,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      isPremium: isPremium ?? this.isPremium,
      isModerator: isModerator ?? this.isModerator,
      description: description ?? this.description,
      trophies: trophies ?? this.trophies,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RedditUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RedditUser(id: $id, username: $username, karma: $karma)';
  }
}