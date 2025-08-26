class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderImageUrl;
  final String content;
  final List<MessageAttachment> attachments;
  final MessageType type;
  final MessageStatus status;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? editedAt;
  final String? replyToMessageId;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderImageUrl,
    required this.content,
    this.attachments = const [],
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    required this.createdAt,
    this.readAt,
    this.editedAt,
    this.replyToMessageId,
  });

  bool get isRead => readAt != null;
  bool get isEdited => editedAt != null;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversationId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderImageUrl: json['senderImageUrl'],
      content: json['content'],
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => MessageAttachment.fromJson(e))
          .toList() ?? [],
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      editedAt: json['editedAt'] != null ? DateTime.parse(json['editedAt']) : null,
      replyToMessageId: json['replyToMessageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'content': content,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'replyToMessageId': replyToMessageId,
    };
  }
}

class Conversation {
  final String id;
  final String title;
  final ConversationType type;
  final List<String> participantIds;
  final List<ConversationParticipant> participants;
  final Message? lastMessage;
  final int unreadCount;
  final bool isMuted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Conversation({
    required this.id,
    required this.title,
    required this.type,
    required this.participantIds,
    required this.participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.isMuted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      type: ConversationType.values.firstWhere((e) => e.name == json['type']),
      participantIds: List<String>.from(json['participantIds']),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => ConversationParticipant.fromJson(e))
          .toList(),
      lastMessage: json['lastMessage'] != null 
          ? Message.fromJson(json['lastMessage']) 
          : null,
      unreadCount: json['unreadCount'] ?? 0,
      isMuted: json['isMuted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.name,
      'participantIds': participantIds,
      'participants': participants.map((e) => e.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'isMuted': isMuted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class ConversationParticipant {
  final String userId;
  final String name;
  final String role;
  final String? imageUrl;
  final bool isActive;
  final DateTime? lastSeenAt;

  ConversationParticipant({
    required this.userId,
    required this.name,
    required this.role,
    this.imageUrl,
    this.isActive = true,
    this.lastSeenAt,
  });

  factory ConversationParticipant.fromJson(Map<String, dynamic> json) {
    return ConversationParticipant(
      userId: json['userId'],
      name: json['name'],
      role: json['role'],
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      lastSeenAt: json['lastSeenAt'] != null 
          ? DateTime.parse(json['lastSeenAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'role': role,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'lastSeenAt': lastSeenAt?.toIso8601String(),
    };
  }
}

class MessageAttachment {
  final String id;
  final String name;
  final String url;
  final AttachmentType type;
  final int? size;
  final String? mimeType;
  final String? thumbnailUrl;

  MessageAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    this.size,
    this.mimeType,
    this.thumbnailUrl,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: AttachmentType.values.firstWhere((e) => e.name == json['type']),
      size: json['size'],
      mimeType: json['mimeType'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type.name,
      'size': size,
      'mimeType': mimeType,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  document,
  system,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

enum ConversationType {
  direct,
  group,
  classroom,
  announcement,
}

enum AttachmentType {
  image,
  video,
  document,
  audio,
}