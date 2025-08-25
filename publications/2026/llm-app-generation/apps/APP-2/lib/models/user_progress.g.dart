// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
  pageId: json['pageId'] as String,
  coloredRegions: (json['coloredRegions'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(int.parse(k), e as bool),
  ),
  progressPercentage: (json['progressPercentage'] as num).toDouble(),
  lastModified: DateTime.parse(json['lastModified'] as String),
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'pageId': instance.pageId,
      'coloredRegions': instance.coloredRegions.map(
        (k, e) => MapEntry(k.toString(), e),
      ),
      'progressPercentage': instance.progressPercentage,
      'lastModified': instance.lastModified.toIso8601String(),
      'isCompleted': instance.isCompleted,
    };

UserArtwork _$UserArtworkFromJson(Map<String, dynamic> json) => UserArtwork(
  id: json['id'] as String,
  pageId: json['pageId'] as String,
  title: json['title'] as String,
  thumbnailPath: json['thumbnailPath'] as String,
  completedImagePath: json['completedImagePath'] as String,
  completedAt: DateTime.parse(json['completedAt'] as String),
  timeSpentMinutes: (json['timeSpentMinutes'] as num).toInt(),
);

Map<String, dynamic> _$UserArtworkToJson(UserArtwork instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pageId': instance.pageId,
      'title': instance.title,
      'thumbnailPath': instance.thumbnailPath,
      'completedImagePath': instance.completedImagePath,
      'completedAt': instance.completedAt.toIso8601String(),
      'timeSpentMinutes': instance.timeSpentMinutes,
    };
