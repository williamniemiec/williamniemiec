// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatLabel _$ChatLabelFromJson(Map<String, dynamic> json) => ChatLabel(
  id: json['id'] as String,
  name: json['name'] as String,
  colorHex: json['colorHex'] as String,
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ChatLabelToJson(ChatLabel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'colorHex': instance.colorHex,
  'description': instance.description,
  'createdAt': instance.createdAt.toIso8601String(),
};
