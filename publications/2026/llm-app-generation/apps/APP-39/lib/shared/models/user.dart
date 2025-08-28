class User {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final UserPreferences preferences;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.preferences,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'preferences': preferences.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    UserPreferences? preferences,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  String get displayName => name ?? email.split('@').first;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }
}

class UserPreferences {
  final bool isDarkMode;
  final bool isIncognitoMode;
  final bool safeSearchEnabled;
  final bool voiceSearchEnabled;
  final bool locationEnabled;
  final bool personalizedAdsEnabled;
  final bool searchHistoryEnabled;
  final List<String> followedTopics;
  final List<String> blockedSources;
  final String language;
  final String region;

  const UserPreferences({
    this.isDarkMode = false,
    this.isIncognitoMode = false,
    this.safeSearchEnabled = true,
    this.voiceSearchEnabled = true,
    this.locationEnabled = false,
    this.personalizedAdsEnabled = true,
    this.searchHistoryEnabled = true,
    this.followedTopics = const [],
    this.blockedSources = const [],
    this.language = 'en',
    this.region = 'US',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      isIncognitoMode: json['isIncognitoMode'] as bool? ?? false,
      safeSearchEnabled: json['safeSearchEnabled'] as bool? ?? true,
      voiceSearchEnabled: json['voiceSearchEnabled'] as bool? ?? true,
      locationEnabled: json['locationEnabled'] as bool? ?? false,
      personalizedAdsEnabled: json['personalizedAdsEnabled'] as bool? ?? true,
      searchHistoryEnabled: json['searchHistoryEnabled'] as bool? ?? true,
      followedTopics: List<String>.from(json['followedTopics'] as List? ?? []),
      blockedSources: List<String>.from(json['blockedSources'] as List? ?? []),
      language: json['language'] as String? ?? 'en',
      region: json['region'] as String? ?? 'US',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'isIncognitoMode': isIncognitoMode,
      'safeSearchEnabled': safeSearchEnabled,
      'voiceSearchEnabled': voiceSearchEnabled,
      'locationEnabled': locationEnabled,
      'personalizedAdsEnabled': personalizedAdsEnabled,
      'searchHistoryEnabled': searchHistoryEnabled,
      'followedTopics': followedTopics,
      'blockedSources': blockedSources,
      'language': language,
      'region': region,
    };
  }

  UserPreferences copyWith({
    bool? isDarkMode,
    bool? isIncognitoMode,
    bool? safeSearchEnabled,
    bool? voiceSearchEnabled,
    bool? locationEnabled,
    bool? personalizedAdsEnabled,
    bool? searchHistoryEnabled,
    List<String>? followedTopics,
    List<String>? blockedSources,
    String? language,
    String? region,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isIncognitoMode: isIncognitoMode ?? this.isIncognitoMode,
      safeSearchEnabled: safeSearchEnabled ?? this.safeSearchEnabled,
      voiceSearchEnabled: voiceSearchEnabled ?? this.voiceSearchEnabled,
      locationEnabled: locationEnabled ?? this.locationEnabled,
      personalizedAdsEnabled: personalizedAdsEnabled ?? this.personalizedAdsEnabled,
      searchHistoryEnabled: searchHistoryEnabled ?? this.searchHistoryEnabled,
      followedTopics: followedTopics ?? this.followedTopics,
      blockedSources: blockedSources ?? this.blockedSources,
      language: language ?? this.language,
      region: region ?? this.region,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserPreferences &&
        other.isDarkMode == isDarkMode &&
        other.isIncognitoMode == isIncognitoMode &&
        other.safeSearchEnabled == safeSearchEnabled &&
        other.voiceSearchEnabled == voiceSearchEnabled &&
        other.locationEnabled == locationEnabled &&
        other.personalizedAdsEnabled == personalizedAdsEnabled &&
        other.searchHistoryEnabled == searchHistoryEnabled &&
        other.language == language &&
        other.region == region;
  }

  @override
  int get hashCode {
    return Object.hash(
      isDarkMode,
      isIncognitoMode,
      safeSearchEnabled,
      voiceSearchEnabled,
      locationEnabled,
      personalizedAdsEnabled,
      searchHistoryEnabled,
      language,
      region,
    );
  }

  @override
  String toString() {
    return 'UserPreferences(isDarkMode: $isDarkMode, language: $language, region: $region)';
  }
}