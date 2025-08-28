enum MessageRole {
  user,
  assistant,
  system,
}

enum MessageType {
  text,
  image,
  generatedImage,
  voice,
}

class Message {
  final String id;
  final String content;
  final MessageType type;
  final MessageRole role;
  final DateTime timestamp;
  final String? imagePath;
  final String? audioPath;
  final bool isStreaming;

  Message({
    required this.id,
    required this.content,
    required this.type,
    required this.role,
    required this.timestamp,
    this.imagePath,
    this.audioPath,
    this.isStreaming = false,
  });

  Message copyWith({
    String? id,
    String? content,
    MessageType? type,
    MessageRole? role,
    DateTime? timestamp,
    String? imagePath,
    String? audioPath,
    bool? isStreaming,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
      audioPath: audioPath ?? this.audioPath,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.toString(),
      'role': role.toString(),
      'timestamp': timestamp.toIso8601String(),
      'imagePath': imagePath,
      'audioPath': audioPath,
      'isStreaming': isStreaming,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      role: MessageRole.values.firstWhere(
        (e) => e.toString() == json['role'],
        orElse: () => MessageRole.user,
      ),
      timestamp: DateTime.parse(json['timestamp']),
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      isStreaming: json['isStreaming'] ?? false,
    );
  }
}