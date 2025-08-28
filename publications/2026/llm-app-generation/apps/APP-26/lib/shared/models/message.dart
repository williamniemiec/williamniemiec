import 'package:hive/hive.dart';
import 'user.dart';

part 'message.g.dart';

@HiveType(typeId: 6)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String conversationId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final User sender;

  @HiveField(4)
  final String content;

  @HiveField(5)
  final MessageType type;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  @HiveField(8)
  final bool isRead;

  @HiveField(9)
  final bool isDelivered;

  @HiveField(10)
  final bool isEdited;

  @HiveField(11)
  final DateTime? editedAt;

  @HiveField(12)
  final String? replyToId;

  @HiveField(13)
  final Message? replyTo;

  @HiveField(14)
  final List<String> mediaUrls;

  @HiveField(15)
  final Map<String, dynamic>? metadata;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.sender,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
    this.isDelivered = false,
    this.isEdited = false,
    this.editedAt,
    this.replyToId,
    this.replyTo,
    this.mediaUrls = const [],
    this.metadata,
  });

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    User? sender,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isRead,
    bool? isDelivered,
    bool? isEdited,
    DateTime? editedAt,
    String? replyToId,
    Message? replyTo,
    List<String>? mediaUrls,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      replyToId: replyToId ?? this.replyToId,
      replyTo: replyTo ?? this.replyTo,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'sender': sender.toJson(),
      'content': content,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isRead': isRead,
      'isDelivered': isDelivered,
      'isEdited': isEdited,
      'editedAt': editedAt?.toIso8601String(),
      'replyToId': replyToId,
      'replyTo': replyTo?.toJson(),
      'mediaUrls': mediaUrls,
      'metadata': metadata,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      sender: User.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isDelivered: json['isDelivered'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] != null 
          ? DateTime.parse(json['editedAt'] as String)
          : null,
      replyToId: json['replyToId'] as String?,
      replyTo: json['replyTo'] != null 
          ? Message.fromJson(json['replyTo'] as Map<String, dynamic>)
          : null,
      mediaUrls: List<String>.from(json['mediaUrls'] as List? ?? []),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message(id: $id, senderId: $senderId, type: $type)';
  }
}

@HiveType(typeId: 7)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
  @HiveField(2)
  video,
  @HiveField(3)
  audio,
  @HiveField(4)
  file,
  @HiveField(5)
  location,
  @HiveField(6)
  contact,
  @HiveField(7)
  sticker,
  @HiveField(8)
  gif,
}

@HiveType(typeId: 8)
class Conversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<String> participantIds;

  @HiveField(2)
  final List<User> participants;

  @HiveField(3)
  final String? name;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime updatedAt;

  @HiveField(7)
  final Message? lastMessage;

  @HiveField(8)
  final int unreadCount;

  @HiveField(9)
  final bool isGroup;

  @HiveField(10)
  final bool isMuted;

  @HiveField(11)
  final bool isArchived;

  @HiveField(12)
  final String? creatorId;

  Conversation({
    required this.id,
    required this.participantIds,
    required this.participants,
    this.name,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.unreadCount = 0,
    this.isGroup = false,
    this.isMuted = false,
    this.isArchived = false,
    this.creatorId,
  });

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    List<User>? participants,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Message? lastMessage,
    int? unreadCount,
    bool? isGroup,
    bool? isMuted,
    bool? isArchived,
    String? creatorId,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      isMuted: isMuted ?? this.isMuted,
      isArchived: isArchived ?? this.isArchived,
      creatorId: creatorId ?? this.creatorId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'participants': participants.map((p) => p.toJson()).toList(),
      'name': name,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'isGroup': isGroup,
      'isMuted': isMuted,
      'isArchived': isArchived,
      'creatorId': creatorId,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      participantIds: List<String>.from(json['participantIds'] as List),
      participants: (json['participants'] as List)
          .map((p) => User.fromJson(p as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastMessage: json['lastMessage'] != null 
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isGroup: json['isGroup'] as bool? ?? false,
      isMuted: json['isMuted'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      creatorId: json['creatorId'] as String?,
    );
  }

  String getDisplayName(String currentUserId) {
    if (isGroup) {
      return name ?? 'Group Chat';
    }
    
    final otherParticipant = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => participants.first,
    );
    
    return otherParticipant.displayName;
  }

  String? getDisplayImage(String currentUserId) {
    if (isGroup) {
      return imageUrl;
    }
    
    final otherParticipant = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => participants.first,
    );
    
    return otherParticipant.profileImageUrl;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Conversation(id: $id, isGroup: $isGroup, participantCount: ${participants.length})';
  }
}