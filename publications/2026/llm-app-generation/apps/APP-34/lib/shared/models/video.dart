import 'user.dart';

class Video {
  final String id;
  final String videoUrl;
  final String? thumbnailUrl;
  final String caption;
  final List<String> hashtags;
  final User creator;
  final String? soundId;
  final String? soundName;
  final String? soundUrl;
  final int duration; // in seconds
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Video({
    required this.id,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.caption,
    this.hashtags = const [],
    required this.creator,
    this.soundId,
    this.soundName,
    this.soundUrl,
    required this.duration,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.viewsCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String,
      hashtags: (json['hashtags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      creator: User.fromJson(json['creator'] as Map<String, dynamic>),
      soundId: json['soundId'] as String?,
      soundName: json['soundName'] as String?,
      soundUrl: json['soundUrl'] as String?,
      duration: json['duration'] as int,
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      sharesCount: json['sharesCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'caption': caption,
      'hashtags': hashtags,
      'creator': creator.toJson(),
      'soundId': soundId,
      'soundName': soundName,
      'soundUrl': soundUrl,
      'duration': duration,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Video copyWith({
    String? id,
    String? videoUrl,
    String? thumbnailUrl,
    String? caption,
    List<String>? hashtags,
    User? creator,
    String? soundId,
    String? soundName,
    String? soundUrl,
    int? duration,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? viewsCount,
    bool? isLiked,
    bool? isBookmarked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Video(
      id: id ?? this.id,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      creator: creator ?? this.creator,
      soundId: soundId ?? this.soundId,
      soundName: soundName ?? this.soundName,
      soundUrl: soundUrl ?? this.soundUrl,
      duration: duration ?? this.duration,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Video && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Video(id: $id, caption: $caption, creator: ${creator.username})';
  }
}