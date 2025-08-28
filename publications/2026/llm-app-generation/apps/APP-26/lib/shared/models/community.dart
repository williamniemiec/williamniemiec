import 'package:hive/hive.dart';
import 'user.dart';

part 'community.g.dart';

@HiveType(typeId: 4)
class Community extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String? bannerUrl;

  @HiveField(5)
  final String creatorId;

  @HiveField(6)
  final User creator;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime updatedAt;

  @HiveField(9)
  final int membersCount;

  @HiveField(10)
  final int postsCount;

  @HiveField(11)
  final bool isPrivate;

  @HiveField(12)
  final bool isMember;

  @HiveField(13)
  final bool isModerator;

  @HiveField(14)
  final bool isAdmin;

  @HiveField(15)
  final List<String> rules;

  @HiveField(16)
  final List<String> topics;

  @HiveField(17)
  final List<String> moderatorIds;

  @HiveField(18)
  final CommunitySettings settings;

  Community({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.bannerUrl,
    required this.creatorId,
    required this.creator,
    required this.createdAt,
    required this.updatedAt,
    this.membersCount = 0,
    this.postsCount = 0,
    this.isPrivate = false,
    this.isMember = false,
    this.isModerator = false,
    this.isAdmin = false,
    this.rules = const [],
    this.topics = const [],
    this.moderatorIds = const [],
    required this.settings,
  });

  Community copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? bannerUrl,
    String? creatorId,
    User? creator,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? membersCount,
    int? postsCount,
    bool? isPrivate,
    bool? isMember,
    bool? isModerator,
    bool? isAdmin,
    List<String>? rules,
    List<String>? topics,
    List<String>? moderatorIds,
    CommunitySettings? settings,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      creatorId: creatorId ?? this.creatorId,
      creator: creator ?? this.creator,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      membersCount: membersCount ?? this.membersCount,
      postsCount: postsCount ?? this.postsCount,
      isPrivate: isPrivate ?? this.isPrivate,
      isMember: isMember ?? this.isMember,
      isModerator: isModerator ?? this.isModerator,
      isAdmin: isAdmin ?? this.isAdmin,
      rules: rules ?? this.rules,
      topics: topics ?? this.topics,
      moderatorIds: moderatorIds ?? this.moderatorIds,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'creatorId': creatorId,
      'creator': creator.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'membersCount': membersCount,
      'postsCount': postsCount,
      'isPrivate': isPrivate,
      'isMember': isMember,
      'isModerator': isModerator,
      'isAdmin': isAdmin,
      'rules': rules,
      'topics': topics,
      'moderatorIds': moderatorIds,
      'settings': settings.toJson(),
    };
  }

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      creatorId: json['creatorId'] as String,
      creator: User.fromJson(json['creator'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      membersCount: json['membersCount'] as int? ?? 0,
      postsCount: json['postsCount'] as int? ?? 0,
      isPrivate: json['isPrivate'] as bool? ?? false,
      isMember: json['isMember'] as bool? ?? false,
      isModerator: json['isModerator'] as bool? ?? false,
      isAdmin: json['isAdmin'] as bool? ?? false,
      rules: List<String>.from(json['rules'] as List? ?? []),
      topics: List<String>.from(json['topics'] as List? ?? []),
      moderatorIds: List<String>.from(json['moderatorIds'] as List? ?? []),
      settings: CommunitySettings.fromJson(json['settings'] as Map<String, dynamic>),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Community && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Community(id: $id, name: $name, membersCount: $membersCount)';
  }
}

@HiveType(typeId: 5)
class CommunitySettings extends HiveObject {
  @HiveField(0)
  final bool allowImages;

  @HiveField(1)
  final bool allowVideos;

  @HiveField(2)
  final bool allowPolls;

  @HiveField(3)
  final bool requireApproval;

  @HiveField(4)
  final bool allowInvites;

  @HiveField(5)
  final int maxPostLength;

  @HiveField(6)
  final List<String> bannedWords;

  CommunitySettings({
    this.allowImages = true,
    this.allowVideos = true,
    this.allowPolls = true,
    this.requireApproval = false,
    this.allowInvites = true,
    this.maxPostLength = 280,
    this.bannedWords = const [],
  });

  CommunitySettings copyWith({
    bool? allowImages,
    bool? allowVideos,
    bool? allowPolls,
    bool? requireApproval,
    bool? allowInvites,
    int? maxPostLength,
    List<String>? bannedWords,
  }) {
    return CommunitySettings(
      allowImages: allowImages ?? this.allowImages,
      allowVideos: allowVideos ?? this.allowVideos,
      allowPolls: allowPolls ?? this.allowPolls,
      requireApproval: requireApproval ?? this.requireApproval,
      allowInvites: allowInvites ?? this.allowInvites,
      maxPostLength: maxPostLength ?? this.maxPostLength,
      bannedWords: bannedWords ?? this.bannedWords,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'allowImages': allowImages,
      'allowVideos': allowVideos,
      'allowPolls': allowPolls,
      'requireApproval': requireApproval,
      'allowInvites': allowInvites,
      'maxPostLength': maxPostLength,
      'bannedWords': bannedWords,
    };
  }

  factory CommunitySettings.fromJson(Map<String, dynamic> json) {
    return CommunitySettings(
      allowImages: json['allowImages'] as bool? ?? true,
      allowVideos: json['allowVideos'] as bool? ?? true,
      allowPolls: json['allowPolls'] as bool? ?? true,
      requireApproval: json['requireApproval'] as bool? ?? false,
      allowInvites: json['allowInvites'] as bool? ?? true,
      maxPostLength: json['maxPostLength'] as int? ?? 280,
      bannedWords: List<String>.from(json['bannedWords'] as List? ?? []),
    );
  }
}