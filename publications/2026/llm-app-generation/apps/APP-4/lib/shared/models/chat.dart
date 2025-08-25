import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  final String id;
  final String contactId;
  final String contactName;
  final String? contactPhone;
  final String? contactAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final List<String> labels;
  final bool isArchived;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Chat({
    required this.id,
    required this.contactId,
    required this.contactName,
    this.contactPhone,
    this.contactAvatar,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.labels = const [],
    this.isArchived = false,
    this.isPinned = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);

  Chat copyWith({
    String? id,
    String? contactId,
    String? contactName,
    String? contactPhone,
    String? contactAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    List<String>? labels,
    bool? isArchived,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Chat(
      id: id ?? this.id,
      contactId: contactId ?? this.contactId,
      contactName: contactName ?? this.contactName,
      contactPhone: contactPhone ?? this.contactPhone,
      contactAvatar: contactAvatar ?? this.contactAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      labels: labels ?? this.labels,
      isArchived: isArchived ?? this.isArchived,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;
  final String? mediaUrl;
  final String? mediaFileName;
  final int? mediaDuration;
  final String? replyToMessageId;
  final bool isFromBusiness;

  const Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.type,
    required this.status,
    required this.timestamp,
    this.mediaUrl,
    this.mediaFileName,
    this.mediaDuration,
    this.replyToMessageId,
    this.isFromBusiness = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? mediaUrl,
    String? mediaFileName,
    int? mediaDuration,
    String? replyToMessageId,
    bool? isFromBusiness,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaFileName: mediaFileName ?? this.mediaFileName,
      mediaDuration: mediaDuration ?? this.mediaDuration,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isFromBusiness: isFromBusiness ?? this.isFromBusiness,
    );
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  document,
  location,
  contact,
  catalog,
  system
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed
}