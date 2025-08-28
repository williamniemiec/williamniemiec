import 'user.dart';
import 'video.dart';

enum MessageType {
  text,
  video,
  image,
  audio,
}

class Message {
  final String id;
  final String chatId;
  final User sender;
  final String? text;
  final MessageType type;
  final String? mediaUrl;
  final Video? sharedVideo;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Message({
    required this.id,
    required this.chatId,
    required this.sender,
    this.text,
    required this.type,
    this.mediaUrl,
    this.sharedVideo,
    this.isRead = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      sender: User.fromJson(json['sender'] as Map<String, dynamic>),
      text: json['text'] as String?,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      mediaUrl: json['mediaUrl'] as String?,
      sharedVideo: json['sharedVideo'] != null
          ? Video.fromJson(json['sharedVideo'] as Map<String, dynamic>)
          : null,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'sender': sender.toJson(),
      'text': text,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'sharedVideo': sharedVideo?.toJson(),
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Message copyWith({
    String? id,
    String? chatId,
    User? sender,
    String? text,
    MessageType? type,
    String? mediaUrl,
    Video? sharedVideo,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      sender: sender ?? this.sender,
      text: text ?? this.text,
      type: type ?? this.type,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      sharedVideo: sharedVideo ?? this.sharedVideo,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    return 'Message(id: $id, sender: ${sender.username}, type: $type)';
  }
}