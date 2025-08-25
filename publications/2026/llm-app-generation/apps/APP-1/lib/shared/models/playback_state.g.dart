// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaybackState _$PlaybackStateFromJson(Map<String, dynamic> json) =>
    PlaybackState(
      currentItemId: json['currentItemId'] as String?,
      currentContentType:
          $enumDecodeNullable(_$ContentTypeEnumMap, json['currentContentType']),
      currentPosition: json['currentPosition'] == null
          ? Duration.zero
          : Duration(microseconds: (json['currentPosition'] as num).toInt()),
      totalDuration: json['totalDuration'] == null
          ? Duration.zero
          : Duration(microseconds: (json['totalDuration'] as num).toInt()),
      isPlaying: json['isPlaying'] as bool? ?? false,
      isLoading: json['isLoading'] as bool? ?? false,
      playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
      repeatMode:
          $enumDecodeNullable(_$RepeatModeEnumMap, json['repeatMode']) ??
              RepeatMode.none,
      shuffleEnabled: json['shuffleEnabled'] as bool? ?? false,
      queue:
          (json['queue'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      currentQueueIndex: (json['currentQueueIndex'] as num?)?.toInt() ?? 0,
      currentChapterId: json['currentChapterId'] as String?,
    );

Map<String, dynamic> _$PlaybackStateToJson(PlaybackState instance) =>
    <String, dynamic>{
      'currentItemId': instance.currentItemId,
      'currentContentType': _$ContentTypeEnumMap[instance.currentContentType],
      'currentPosition': instance.currentPosition.inMicroseconds,
      'totalDuration': instance.totalDuration.inMicroseconds,
      'isPlaying': instance.isPlaying,
      'isLoading': instance.isLoading,
      'playbackSpeed': instance.playbackSpeed,
      'repeatMode': _$RepeatModeEnumMap[instance.repeatMode]!,
      'shuffleEnabled': instance.shuffleEnabled,
      'queue': instance.queue,
      'currentQueueIndex': instance.currentQueueIndex,
      'currentChapterId': instance.currentChapterId,
    };

const _$ContentTypeEnumMap = {
  ContentType.audiobook: 'audiobook',
  ContentType.podcast: 'podcast',
  ContentType.original: 'original',
};

const _$RepeatModeEnumMap = {
  RepeatMode.none: 'none',
  RepeatMode.one: 'one',
  RepeatMode.all: 'all',
};

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => Bookmark(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      contentType: $enumDecode(_$ContentTypeEnumMap, json['contentType']),
      position: Duration(microseconds: (json['position'] as num).toInt()),
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      chapterId: json['chapterId'] as String?,
    );

Map<String, dynamic> _$BookmarkToJson(Bookmark instance) => <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'contentType': _$ContentTypeEnumMap[instance.contentType]!,
      'position': instance.position.inMicroseconds,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'chapterId': instance.chapterId,
    };

Collection _$CollectionFromJson(Map<String, dynamic> json) => Collection(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      itemIds:
          (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      coverImageUrl: json['coverImageUrl'] as String?,
    );

Map<String, dynamic> _$CollectionToJson(Collection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'itemIds': instance.itemIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'coverImageUrl': instance.coverImageUrl,
    };
