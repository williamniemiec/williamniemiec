import 'package:hive/hive.dart';

part 'team.g.dart';

@HiveType(typeId: 8)
class Team extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final String ownerId;

  @HiveField(5)
  final List<String> memberIds;

  @HiveField(6)
  final List<String> adminIds;

  @HiveField(7)
  final List<Channel> channels;

  @HiveField(8)
  final TeamType type;

  @HiveField(9)
  final TeamVisibility visibility;

  @HiveField(10)
  final bool isArchived;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final Map<String, dynamic>? settings;

  Team({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.ownerId,
    this.memberIds = const [],
    this.adminIds = const [],
    this.channels = const [],
    this.type = TeamType.standard,
    this.visibility = TeamVisibility.private,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
    this.settings,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      ownerId: json['ownerId'] as String,
      memberIds: List<String>.from(json['memberIds'] as List? ?? []),
      adminIds: List<String>.from(json['adminIds'] as List? ?? []),
      channels: (json['channels'] as List?)
          ?.map((e) => Channel.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      type: TeamType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TeamType.standard,
      ),
      visibility: TeamVisibility.values.firstWhere(
        (e) => e.toString().split('.').last == json['visibility'],
        orElse: () => TeamVisibility.private,
      ),
      isArchived: json['isArchived'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'memberIds': memberIds,
      'adminIds': adminIds,
      'channels': channels.map((e) => e.toJson()).toList(),
      'type': type.toString().split('.').last,
      'visibility': visibility.toString().split('.').last,
      'isArchived': isArchived,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'settings': settings,
    };
  }

  Team copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? ownerId,
    List<String>? memberIds,
    List<String>? adminIds,
    List<Channel>? channels,
    TeamType? type,
    TeamVisibility? visibility,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? settings,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      ownerId: ownerId ?? this.ownerId,
      memberIds: memberIds ?? this.memberIds,
      adminIds: adminIds ?? this.adminIds,
      channels: channels ?? this.channels,
      type: type ?? this.type,
      visibility: visibility ?? this.visibility,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
    );
  }

  int get totalMembers => memberIds.length + adminIds.length + 1; // +1 for owner

  Channel? getChannelById(String channelId) {
    try {
      return channels.firstWhere((channel) => channel.id == channelId);
    } catch (e) {
      return null;
    }
  }

  bool isUserMember(String userId) {
    return ownerId == userId || 
           memberIds.contains(userId) || 
           adminIds.contains(userId);
  }

  bool isUserAdmin(String userId) {
    return ownerId == userId || adminIds.contains(userId);
  }
}

@HiveType(typeId: 9)
enum TeamType {
  @HiveField(0)
  standard,
  @HiveField(1)
  community,
  @HiveField(2)
  educational,
  @HiveField(3)
  project,
}

@HiveType(typeId: 10)
enum TeamVisibility {
  @HiveField(0)
  private,
  @HiveField(1)
  public,
  @HiveField(2)
  orgWide,
}

@HiveType(typeId: 11)
class Channel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String teamId;

  @HiveField(4)
  final ChannelType type;

  @HiveField(5)
  final bool isPrivate;

  @HiveField(6)
  final List<String> memberIds;

  @HiveField(7)
  final String? lastMessageId;

  @HiveField(8)
  final DateTime? lastMessageAt;

  @HiveField(9)
  final int unreadCount;

  @HiveField(10)
  final bool isMuted;

  @HiveField(11)
  final bool isPinned;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final DateTime updatedAt;

  @HiveField(14)
  final Map<String, dynamic>? settings;

  Channel({
    required this.id,
    required this.name,
    this.description,
    required this.teamId,
    this.type = ChannelType.standard,
    this.isPrivate = false,
    this.memberIds = const [],
    this.lastMessageId,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
    this.settings,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      teamId: json['teamId'] as String,
      type: ChannelType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ChannelType.standard,
      ),
      isPrivate: json['isPrivate'] as bool? ?? false,
      memberIds: List<String>.from(json['memberIds'] as List? ?? []),
      lastMessageId: json['lastMessageId'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'teamId': teamId,
      'type': type.toString().split('.').last,
      'isPrivate': isPrivate,
      'memberIds': memberIds,
      'lastMessageId': lastMessageId,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'unreadCount': unreadCount,
      'isMuted': isMuted,
      'isPinned': isPinned,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'settings': settings,
    };
  }

  Channel copyWith({
    String? id,
    String? name,
    String? description,
    String? teamId,
    ChannelType? type,
    bool? isPrivate,
    List<String>? memberIds,
    String? lastMessageId,
    DateTime? lastMessageAt,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? settings,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      teamId: teamId ?? this.teamId,
      type: type ?? this.type,
      isPrivate: isPrivate ?? this.isPrivate,
      memberIds: memberIds ?? this.memberIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settings: settings ?? this.settings,
    );
  }

  bool get hasUnreadMessages => unreadCount > 0;
}

@HiveType(typeId: 12)
enum ChannelType {
  @HiveField(0)
  standard,
  @HiveField(1)
  announcement,
  @HiveField(2)
  general,
  @HiveField(3)
  files,
  @HiveField(4)
  wiki,
}