class Subreddit {
  final String id;
  final String name;
  final String displayName;
  final String title;
  final String description;
  final String? publicDescription;
  final String? iconUrl;
  final String? bannerUrl;
  final String? headerUrl;
  final int subscribers;
  final int activeUsers;
  final DateTime createdAt;
  final bool isNsfw;
  final bool isQuarantined;
  final bool isSubscribed;
  final bool isModerator;
  final bool isContributor;
  final List<String> rules;
  final List<String> moderators;
  final String primaryColor;
  final String keyColor;
  final Map<String, dynamic> flairSettings;

  const Subreddit({
    required this.id,
    required this.name,
    required this.displayName,
    required this.title,
    required this.description,
    this.publicDescription,
    this.iconUrl,
    this.bannerUrl,
    this.headerUrl,
    required this.subscribers,
    this.activeUsers = 0,
    required this.createdAt,
    this.isNsfw = false,
    this.isQuarantined = false,
    this.isSubscribed = false,
    this.isModerator = false,
    this.isContributor = false,
    this.rules = const [],
    this.moderators = const [],
    this.primaryColor = '#0079D3',
    this.keyColor = '#0079D3',
    this.flairSettings = const {},
  });

  factory Subreddit.fromJson(Map<String, dynamic> json) {
    return Subreddit(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      publicDescription: json['public_description'],
      iconUrl: _cleanImageUrl(json['icon_img']),
      bannerUrl: _cleanImageUrl(json['banner_img']),
      headerUrl: _cleanImageUrl(json['header_img']),
      subscribers: (json['subscribers'] ?? 0).toInt(),
      activeUsers: (json['accounts_active'] ?? 0).toInt(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((json['created_utc'] ?? 0) * 1000).toInt(),
      ),
      isNsfw: json['over18'] ?? false,
      isQuarantined: json['quarantine'] ?? false,
      isSubscribed: json['user_is_subscriber'] ?? false,
      isModerator: json['user_is_moderator'] ?? false,
      isContributor: json['user_is_contributor'] ?? false,
      rules: _parseRules(json['rules']),
      moderators: (json['moderators'] as List?)?.cast<String>() ?? [],
      primaryColor: json['primary_color'] ?? '#0079D3',
      keyColor: json['key_color'] ?? '#0079D3',
      flairSettings: json['user_flair_enabled_in_sr'] != null
          ? {
              'enabled': json['user_flair_enabled_in_sr'],
              'position': json['user_flair_position'],
              'type': json['user_flair_type'],
            }
          : {},
    );
  }

  static String? _cleanImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    // Remove Reddit's image processing parameters
    return url.split('?').first;
  }

  static List<String> _parseRules(dynamic rulesData) {
    if (rulesData == null) return [];
    if (rulesData is List) {
      return rulesData
          .map((rule) => rule is Map ? rule['short_name'] ?? '' : rule.toString())
          .where((rule) => rule.isNotEmpty)
          .cast<String>()
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'title': title,
      'description': description,
      'public_description': publicDescription,
      'icon_img': iconUrl,
      'banner_img': bannerUrl,
      'header_img': headerUrl,
      'subscribers': subscribers,
      'accounts_active': activeUsers,
      'created_utc': createdAt.millisecondsSinceEpoch / 1000,
      'over18': isNsfw,
      'quarantine': isQuarantined,
      'user_is_subscriber': isSubscribed,
      'user_is_moderator': isModerator,
      'user_is_contributor': isContributor,
      'rules': rules,
      'moderators': moderators,
      'primary_color': primaryColor,
      'key_color': keyColor,
      'flair_settings': flairSettings,
    };
  }

  Subreddit copyWith({
    String? id,
    String? name,
    String? displayName,
    String? title,
    String? description,
    String? publicDescription,
    String? iconUrl,
    String? bannerUrl,
    String? headerUrl,
    int? subscribers,
    int? activeUsers,
    DateTime? createdAt,
    bool? isNsfw,
    bool? isQuarantined,
    bool? isSubscribed,
    bool? isModerator,
    bool? isContributor,
    List<String>? rules,
    List<String>? moderators,
    String? primaryColor,
    String? keyColor,
    Map<String, dynamic>? flairSettings,
  }) {
    return Subreddit(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      title: title ?? this.title,
      description: description ?? this.description,
      publicDescription: publicDescription ?? this.publicDescription,
      iconUrl: iconUrl ?? this.iconUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      headerUrl: headerUrl ?? this.headerUrl,
      subscribers: subscribers ?? this.subscribers,
      activeUsers: activeUsers ?? this.activeUsers,
      createdAt: createdAt ?? this.createdAt,
      isNsfw: isNsfw ?? this.isNsfw,
      isQuarantined: isQuarantined ?? this.isQuarantined,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      isModerator: isModerator ?? this.isModerator,
      isContributor: isContributor ?? this.isContributor,
      rules: rules ?? this.rules,
      moderators: moderators ?? this.moderators,
      primaryColor: primaryColor ?? this.primaryColor,
      keyColor: keyColor ?? this.keyColor,
      flairSettings: flairSettings ?? this.flairSettings,
    );
  }

  String get formattedSubscribers {
    if (subscribers >= 1000000) {
      return '${(subscribers / 1000000).toStringAsFixed(1)}M';
    } else if (subscribers >= 1000) {
      return '${(subscribers / 1000).toStringAsFixed(1)}k';
    }
    return subscribers.toString();
  }

  String get displayNameWithPrefix => 'r/$displayName';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subreddit && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Subreddit(id: $id, displayName: $displayName, subscribers: $subscribers)';
  }
}