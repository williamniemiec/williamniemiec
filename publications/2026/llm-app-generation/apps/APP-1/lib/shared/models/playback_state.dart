import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'playback_state.g.dart';

@JsonSerializable()
class PlaybackState extends Equatable {
  final String? currentItemId;
  final ContentType? currentContentType;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isPlaying;
  final bool isLoading;
  final double playbackSpeed;
  final RepeatMode repeatMode;
  final bool shuffleEnabled;
  final List<String> queue;
  final int currentQueueIndex;
  final String? currentChapterId;

  const PlaybackState({
    this.currentItemId,
    this.currentContentType,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
    this.isLoading = false,
    this.playbackSpeed = 1.0,
    this.repeatMode = RepeatMode.none,
    this.shuffleEnabled = false,
    this.queue = const [],
    this.currentQueueIndex = 0,
    this.currentChapterId,
  });

  factory PlaybackState.fromJson(Map<String, dynamic> json) =>
      _$PlaybackStateFromJson(json);

  Map<String, dynamic> toJson() => _$PlaybackStateToJson(this);

  PlaybackState copyWith({
    String? currentItemId,
    ContentType? currentContentType,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? isPlaying,
    bool? isLoading,
    double? playbackSpeed,
    RepeatMode? repeatMode,
    bool? shuffleEnabled,
    List<String>? queue,
    int? currentQueueIndex,
    String? currentChapterId,
  }) {
    return PlaybackState(
      currentItemId: currentItemId ?? this.currentItemId,
      currentContentType: currentContentType ?? this.currentContentType,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      repeatMode: repeatMode ?? this.repeatMode,
      shuffleEnabled: shuffleEnabled ?? this.shuffleEnabled,
      queue: queue ?? this.queue,
      currentQueueIndex: currentQueueIndex ?? this.currentQueueIndex,
      currentChapterId: currentChapterId ?? this.currentChapterId,
    );
  }

  bool get hasCurrentItem => currentItemId != null;
  
  double get progress {
    if (totalDuration.inMilliseconds == 0) return 0.0;
    return currentPosition.inMilliseconds / totalDuration.inMilliseconds;
  }

  Duration get remainingTime => totalDuration - currentPosition;

  @override
  List<Object?> get props => [
        currentItemId,
        currentContentType,
        currentPosition,
        totalDuration,
        isPlaying,
        isLoading,
        playbackSpeed,
        repeatMode,
        shuffleEnabled,
        queue,
        currentQueueIndex,
        currentChapterId,
      ];
}

enum ContentType {
  @JsonValue('audiobook')
  audiobook,
  @JsonValue('podcast')
  podcast,
  @JsonValue('original')
  original,
}

enum RepeatMode {
  @JsonValue('none')
  none,
  @JsonValue('one')
  one,
  @JsonValue('all')
  all,
}

@JsonSerializable()
class Bookmark extends Equatable {
  final String id;
  final String itemId;
  final ContentType contentType;
  final Duration position;
  final String? note;
  final DateTime createdAt;
  final String? chapterId;

  const Bookmark({
    required this.id,
    required this.itemId,
    required this.contentType,
    required this.position,
    this.note,
    required this.createdAt,
    this.chapterId,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);

  Map<String, dynamic> toJson() => _$BookmarkToJson(this);

  Bookmark copyWith({
    String? id,
    String? itemId,
    ContentType? contentType,
    Duration? position,
    String? note,
    DateTime? createdAt,
    String? chapterId,
  }) {
    return Bookmark(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      contentType: contentType ?? this.contentType,
      position: position ?? this.position,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      chapterId: chapterId ?? this.chapterId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        itemId,
        contentType,
        position,
        note,
        createdAt,
        chapterId,
      ];
}

@JsonSerializable()
class Collection extends Equatable {
  final String id;
  final String name;
  final String? description;
  final List<String> itemIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? coverImageUrl;

  const Collection({
    required this.id,
    required this.name,
    this.description,
    required this.itemIds,
    required this.createdAt,
    required this.updatedAt,
    this.coverImageUrl,
  });

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  Collection copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? itemIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? coverImageUrl,
  }) {
    return Collection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      itemIds: itemIds ?? this.itemIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
    );
  }

  int get itemCount => itemIds.length;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        itemIds,
        createdAt,
        updatedAt,
        coverImageUrl,
      ];
}