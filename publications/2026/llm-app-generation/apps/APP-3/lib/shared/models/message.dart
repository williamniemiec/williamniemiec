import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 3)
class Message extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String senderName;

  @HiveField(3)
  final String? senderAvatarUrl;

  @HiveField(4)
  final String content;

  @HiveField(5)
  final MessageType type;

  @HiveField(6)
  final String? chatId;

  @HiveField(7)
  final String? channelId;

  @HiveField(8)
  final String? threadId;

  @HiveField(9)
  final DateTime timestamp;

  @HiveField(10)
  final DateTime? editedAt;

  @HiveField(11)
  final bool isEdited;

  @HiveField(12)
  final bool isDeleted;

  @HiveField(13)
  final List<MessageAttachment> attachments;

  @HiveField(14)
  final List<MessageReaction> reactions;

  @HiveField(15)
  final List<String> mentions;

  @HiveField(16)
  final String? replyToMessageId;

  @HiveField(17)
  final MessageStatus status;

  @HiveField(18)
  final Map<String, dynamic>? metadata;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    required this.content,
    this.type = MessageType.text,
    this.chatId,
    this.channelId,
    this.threadId,
    required this.timestamp,
    this.editedAt,
    this.isEdited = false,
    this.isDeleted = false,
    this.attachments = const [],
    this.reactions = const [],
    this.mentions = const [],
    this.replyToMessageId,
    this.status = MessageStatus.sent,
    this.metadata,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatarUrl: json['senderAvatarUrl'] as String?,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MessageType.text,
      ),
      chatId: json['chatId'] as String?,
      channelId: json['channelId'] as String?,
      threadId: json['threadId'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      editedAt: json['editedAt'] != null 
          ? DateTime.parse(json['editedAt'] as String)
          : null,
      isEdited: json['isEdited'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      attachments: (json['attachments'] as List?)
          ?.map((e) => MessageAttachment.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      reactions: (json['reactions'] as List?)
          ?.map((e) => MessageReaction.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      mentions: List<String>.from(json['mentions'] as List? ?? []),
      replyToMessageId: json['replyToMessageId'] as String?,
      status: MessageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatarUrl': senderAvatarUrl,
      'content': content,
      'type': type.toString().split('.').last,
      'chatId': chatId,
      'channelId': channelId,
      'threadId': threadId,
      'timestamp': timestamp.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'reactions': reactions.map((e) => e.toJson()).toList(),
      'mentions': mentions,
      'replyToMessageId': replyToMessageId,
      'status': status.toString().split('.').last,
      'metadata': metadata,
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatarUrl,
    String? content,
    MessageType? type,
    String? chatId,
    String? channelId,
    String? threadId,
    DateTime? timestamp,
    DateTime? editedAt,
    bool? isEdited,
    bool? isDeleted,
    List<MessageAttachment>? attachments,
    List<MessageReaction>? reactions,
    List<String>? mentions,
    String? replyToMessageId,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      content: content ?? this.content,
      type: type ?? this.type,
      chatId: chatId ?? this.chatId,
      channelId: channelId ?? this.channelId,
      threadId: threadId ?? this.threadId,
      timestamp: timestamp ?? this.timestamp,
      editedAt: editedAt ?? this.editedAt,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      attachments: attachments ?? this.attachments,
      reactions: reactions ?? this.reactions,
      mentions: mentions ?? this.mentions,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }
}

@HiveType(typeId: 4)
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
  gif,
  @HiveField(6)
  sticker,
  @HiveField(7)
  system,
  @HiveField(8)
  call,
  @HiveField(9)
  meeting,
}

@HiveType(typeId: 5)
enum MessageStatus {
  @HiveField(0)
  sending,
  @HiveField(1)
  sent,
  @HiveField(2)
  delivered,
  @HiveField(3)
  read,
  @HiveField(4)
  failed,
}

@HiveType(typeId: 6)
class MessageAttachment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final String mimeType;

  @HiveField(4)
  final int size;

  @HiveField(5)
  final String? thumbnailUrl;

  @HiveField(6)
  final int? width;

  @HiveField(7)
  final int? height;

  @HiveField(8)
  final int? duration;

  MessageAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.mimeType,
    required this.size,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.duration,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      mimeType: json['mimeType'] as String,
      size: json['size'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      duration: json['duration'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'mimeType': mimeType,
      'size': size,
      'thumbnailUrl': thumbnailUrl,
      'width': width,
      'height': height,
      'duration': duration,
    };
  }
}

@HiveType(typeId: 7)
class MessageReaction extends HiveObject {
  @HiveField(0)
  final String emoji;

  @HiveField(1)
  final List<String> userIds;

  @HiveField(2)
  final int count;

  MessageReaction({
    required this.emoji,
    required this.userIds,
    required this.count,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      emoji: json['emoji'] as String,
      userIds: List<String>.from(json['userIds'] as List),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'userIds': userIds,
      'count': count,
    };
  }
}