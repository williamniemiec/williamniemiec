// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
  id: json['id'] as String,
  author: json['author'] as String,
  body: json['body'] as String,
  score: (json['score'] as num).toInt(),
  depth: (json['depth'] as num).toInt(),
);

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
  'id': instance.id,
  'author': instance.author,
  'body': instance.body,
  'score': instance.score,
  'depth': instance.depth,
};
