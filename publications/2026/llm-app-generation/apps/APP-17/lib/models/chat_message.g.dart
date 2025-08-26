// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      featureType:
          $enumDecodeNullable(_$FeatureTypeEnumMap, json['featureType']),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      isLoading: json['isLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'featureType': _$FeatureTypeEnumMap[instance.featureType],
      'imageUrls': instance.imageUrls,
      'metadata': instance.metadata,
      'isLoading': instance.isLoading,
    };

const _$MessageTypeEnumMap = {
  MessageType.user: 'user',
  MessageType.assistant: 'assistant',
  MessageType.system: 'system',
};

const _$FeatureTypeEnumMap = {
  FeatureType.chatAnalysis: 'chatAnalysis',
  FeatureType.profileRoast: 'profileRoast',
  FeatureType.bioGenerator: 'bioGenerator',
  FeatureType.rizzGenerator: 'rizzGenerator',
  FeatureType.generalAdvice: 'generalAdvice',
};
