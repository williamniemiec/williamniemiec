import 'message.dart';

class Conversation {
  final String id;
  String title;
  List<Message> messages;
  final DateTime createdAt;
  DateTime updatedAt;
  bool isPinned;
  List<String> tags;

  Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.tags = const [],
  });

  Conversation copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    List<String>? tags,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      tags: tags ?? this.tags,
    );
  }

  String get preview {
    if (messages.isEmpty) return 'New conversation';
    final lastMessage = messages.last;
    if (lastMessage.content.length > 100) {
      return '${lastMessage.content.substring(0, 100)}...';
    }
    return lastMessage.content;
  }

  int get messageCount => messages.length;

  bool get hasMessages => messages.isNotEmpty;

  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'tags': tags,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isPinned: json['isPinned'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}