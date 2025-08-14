// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: json['id'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  subreddit: json['subreddit'] as String,
  score: (json['score'] as num).toInt(),
  numComments: (json['num_comments'] as num).toInt(),
  thumbnail: json['thumbnail'] as String?,
  imageUrl: json['url_overridden_by_dest'] as String?,
  isVideo: json['is_video'] as bool,
  selftext: json['selftext'] as String,
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author,
  'subreddit': instance.subreddit,
  'score': instance.score,
  'num_comments': instance.numComments,
  'thumbnail': instance.thumbnail,
  'url_overridden_by_dest': instance.imageUrl,
  'is_video': instance.isVideo,
  'selftext': instance.selftext,
};
