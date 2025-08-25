// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automated_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomatedMessage _$AutomatedMessageFromJson(Map<String, dynamic> json) =>
    AutomatedMessage(
      id: json['id'] as String,
      type: $enumDecode(_$AutomatedMessageTypeEnumMap, json['type']),
      content: json['content'] as String,
      isEnabled: json['isEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AutomatedMessageToJson(AutomatedMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AutomatedMessageTypeEnumMap[instance.type]!,
      'content': instance.content,
      'isEnabled': instance.isEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AutomatedMessageTypeEnumMap = {
  AutomatedMessageType.greeting: 'greeting',
  AutomatedMessageType.away: 'away',
};

QuickReply _$QuickReplyFromJson(Map<String, dynamic> json) => QuickReply(
  id: json['id'] as String,
  shortcut: json['shortcut'] as String,
  message: json['message'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$QuickReplyToJson(QuickReply instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shortcut': instance.shortcut,
      'message': instance.message,
      'createdAt': instance.createdAt.toIso8601String(),
    };
