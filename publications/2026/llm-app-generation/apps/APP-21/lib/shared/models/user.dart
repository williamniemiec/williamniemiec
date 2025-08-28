import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String displayName;

  @HiveField(3)
  final String? profileImageUrl;

  @HiveField(4)
  final bool isPremium;

  @HiveField(5)
  final DateTime? premiumExpiryDate;

  @HiveField(6)
  final List<String> likedSongs;

  @HiveField(7)
  final List<String> followedArtists;

  @HiveField(8)
  final List<String> createdPlaylists;

  @HiveField(9)
  final List<String> followedPlaylists;

  @HiveField(10)
  final List<String> recentlyPlayed;

  @HiveField(11)
  final Map<String, dynamic> preferences;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final DateTime lastLoginAt;

  @HiveField(14)
  final List<String> downloadedSongs;

  @HiveField(15)
  final List<String> downloadedPlaylists;

  @HiveField(16)
  final String? country;

  @HiveField(17)
  final String? language;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.profileImageUrl,
    this.isPremium = false,
    this.premiumExpiryDate,
    this.likedSongs = const [],
    this.followedArtists = const [],
    this.createdPlaylists = const [],
    this.followedPlaylists = const [],
    this.recentlyPlayed = const [],
    this.preferences = const {},
    required this.createdAt,
    required this.lastLoginAt,
    this.downloadedSongs = const [],
    this.downloadedPlaylists = const [],
    this.country,
    this.language,
  });

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? profileImageUrl,
    bool? isPremium,
    DateTime? premiumExpiryDate,
    List<String>? likedSongs,
    List<String>? followedArtists,
    List<String>? createdPlaylists,
    List<String>? followedPlaylists,
    List<String>? recentlyPlayed,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? downloadedSongs,
    List<String>? downloadedPlaylists,
    String? country,
    String? language,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      likedSongs: likedSongs ?? this.likedSongs,
      followedArtists: followedArtists ?? this.followedArtists,
      createdPlaylists: createdPlaylists ?? this.createdPlaylists,
      followedPlaylists: followedPlaylists ?? this.followedPlaylists,
      recentlyPlayed: recentlyPlayed ?? this.recentlyPlayed,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      downloadedSongs: downloadedSongs ?? this.downloadedSongs,
      downloadedPlaylists: downloadedPlaylists ?? this.downloadedPlaylists,
      country: country ?? this.country,
      language: language ?? this.language,
    );
  }

  bool get hasActivePremium {
    if (!isPremium) return false;
    if (premiumExpiryDate == null) return true;
    return DateTime.now().isBefore(premiumExpiryDate!);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate?.toIso8601String(),
      'likedSongs': likedSongs,
      'followedArtists': followedArtists,
      'createdPlaylists': createdPlaylists,
      'followedPlaylists': followedPlaylists,
      'recentlyPlayed': recentlyPlayed,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'downloadedSongs': downloadedSongs,
      'downloadedPlaylists': downloadedPlaylists,
      'country': country,
      'language': language,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      profileImageUrl: json['profileImageUrl'],
      isPremium: json['isPremium'] ?? false,
      premiumExpiryDate: json['premiumExpiryDate'] != null
          ? DateTime.parse(json['premiumExpiryDate'])
          : null,
      likedSongs: List<String>.from(json['likedSongs'] ?? []),
      followedArtists: List<String>.from(json['followedArtists'] ?? []),
      createdPlaylists: List<String>.from(json['createdPlaylists'] ?? []),
      followedPlaylists: List<String>.from(json['followedPlaylists'] ?? []),
      recentlyPlayed: List<String>.from(json['recentlyPlayed'] ?? []),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      downloadedSongs: List<String>.from(json['downloadedSongs'] ?? []),
      downloadedPlaylists: List<String>.from(json['downloadedPlaylists'] ?? []),
      country: json['country'],
      language: json['language'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, displayName: $displayName, isPremium: $isPremium)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}