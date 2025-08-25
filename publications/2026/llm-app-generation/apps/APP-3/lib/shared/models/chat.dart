import 'package:hive/hive.dart';

part 'chat.g.dart';

@HiveType(typeId: 13)
class Chat extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final ChatType type;

  @HiveField(3)
  final List<String> participantIds;

  @HiveField(4)
  final String? lastMessageId;

  @HiveField(5)
  final DateTime? lastMessageAt;

  @HiveField(6)
  final String? lastMessagePreview;

  @HiveField(7)
  final String? lastMessageSenderId;

  @HiveField(8)
  final int unreadCount;

  @HiveField(9)
  final bool isMuted;

  @HiveField(10)
  final bool isPinned;

  @HiveField(11)
  final bool isArchived;

  @HiveField(12)
  final String? imageUrl;

  @HiveField(13)
  final DateTime createdAt;

  @HiveField(14)
  final DateTime updatedAt;

  @HiveField(15)
  final Map<String, dynamic>? metadata;

  Chat({
    required this.id,
    required this.name,
    required this.type,
    required this.participantIds,
    this.lastMessageId,
    this.lastMessageAt,
    this.lastMessagePreview,
    this.lastMessageSenderId,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    this.isArchived = false,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ChatType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ChatType.direct,
      ),
      participantIds: List<String>.from(json['participantIds'] as List),
      lastMessageId: json['lastMessageId'] as String?,
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageSenderId: json['lastMessageSenderId'] as String?,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'participantIds': participantIds,
      'lastMessageId': lastMessageId,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'lastMessagePreview': lastMessagePreview,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'isMuted': isMuted,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  Chat copyWith({
    String? id,
    String? name,
    ChatType? type,
    List<String>? participantIds,
    String? lastMessageId,
    DateTime? lastMessageAt,
    String? lastMessagePreview,
    String? lastMessageSenderId,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    bool? isArchived,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      participantIds: participantIds ?? this.participantIds,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasUnreadMessages => unreadCount > 0;
  bool get isDirectMessage => type == ChatType.direct;
  bool get isGroupChat => type == ChatType.group;
}

@HiveType(typeId: 14)
enum ChatType {
  @HiveField(0)
  direct,
  @HiveField(1)
  group,
  @HiveField(2)
  community,
}