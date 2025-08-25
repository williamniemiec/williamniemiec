import 'package:json_annotation/json_annotation.dart';

part 'automated_message.g.dart';

@JsonSerializable()
class AutomatedMessage {
  final String id;
  final AutomatedMessageType type;
  final String content;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AutomatedMessage({
    required this.id,
    required this.type,
    required this.content,
    this.isEnabled = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AutomatedMessage.fromJson(Map<String, dynamic> json) =>
      _$AutomatedMessageFromJson(json);

  Map<String, dynamic> toJson() => _$AutomatedMessageToJson(this);

  AutomatedMessage copyWith({
    String? id,
    AutomatedMessageType? type,
    String? content,
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AutomatedMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      content: content ?? this.content,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class QuickReply {
  final String id;
  final String shortcut;
  final String message;
  final DateTime createdAt;

  const QuickReply({
    required this.id,
    required this.shortcut,
    required this.message,
    required this.createdAt,
  });

  factory QuickReply.fromJson(Map<String, dynamic> json) =>
      _$QuickReplyFromJson(json);

  Map<String, dynamic> toJson() => _$QuickReplyToJson(this);

  QuickReply copyWith({
    String? id,
    String? shortcut,
    String? message,
    DateTime? createdAt,
  }) {
    return QuickReply(
      id: id ?? this.id,
      shortcut: shortcut ?? this.shortcut,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum AutomatedMessageType {
  greeting,
  away,
}