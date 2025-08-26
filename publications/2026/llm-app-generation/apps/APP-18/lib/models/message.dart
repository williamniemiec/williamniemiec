enum MessageType {
  text,
  pin,
  board,
  image,
}

class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderUsername;
  final String? senderProfileImageUrl;
  final String receiverId;
  final MessageType type;
  final String? content;
  final String? pinId;
  final String? boardId;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  final bool isDelivered;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderUsername,
    this.senderProfileImageUrl,
    required this.receiverId,
    required this.type,
    this.content,
    this.pinId,
    this.boardId,
    this.imageUrl,
    required this.createdAt,
    this.isRead = false,
    this.isDelivered = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderUsername: json['senderUsername'] as String,
      senderProfileImageUrl: json['senderProfileImageUrl'] as String?,
      receiverId: json['receiverId'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      content: json['content'] as String?,
      pinId: json['pinId'] as String?,
      boardId: json['boardId'] as String?,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      isDelivered: json['isDelivered'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderUsername': senderUsername,
      'senderProfileImageUrl': senderProfileImageUrl,
      'receiverId': receiverId,
      'type': type.name,
      'content': content,
      'pinId': pinId,
      'boardId': boardId,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'isDelivered': isDelivered,
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderUsername,
    String? senderProfileImageUrl,
    String? receiverId,
    MessageType? type,
    String? content,
    String? pinId,
    String? boardId,
    String? imageUrl,
    DateTime? createdAt,
    bool? isRead,
    bool? isDelivered,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      senderProfileImageUrl: senderProfileImageUrl ?? this.senderProfileImageUrl,
      receiverId: receiverId ?? this.receiverId,
      type: type ?? this.type,
      content: content ?? this.content,
      pinId: pinId ?? this.pinId,
      boardId: boardId ?? this.boardId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  bool get isTextMessage => type == MessageType.text;
  bool get isPinMessage => type == MessageType.pin;
  bool get isBoardMessage => type == MessageType.board;
  bool get isImageMessage => type == MessageType.image;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Message(id: $id, type: $type, senderId: $senderId)';
  }
}

class Conversation {
  final String id;
  final List<String> participantIds;
  final List<String> participantUsernames;
  final List<String?> participantProfileImages;
  final Message? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;

  const Conversation({
    required this.id,
    required this.participantIds,
    required this.participantUsernames,
    required this.participantProfileImages,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.unreadCount = 0,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      participantIds: List<String>.from(json['participantIds']),
      participantUsernames: List<String>.from(json['participantUsernames']),
      participantProfileImages: List<String?>.from(json['participantProfileImages']),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'participantUsernames': participantUsernames,
      'participantProfileImages': participantProfileImages,
      'lastMessage': lastMessage?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    List<String>? participantUsernames,
    List<String?>? participantProfileImages,
    Message? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadCount,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      participantUsernames: participantUsernames ?? this.participantUsernames,
      participantProfileImages: participantProfileImages ?? this.participantProfileImages,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  bool get hasUnreadMessages => unreadCount > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Conversation(id: $id, participants: $participantUsernames)';
  }
}