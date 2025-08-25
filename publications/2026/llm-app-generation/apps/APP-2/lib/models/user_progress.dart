import 'package:json_annotation/json_annotation.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress {
  final String pageId;
  final Map<int, bool> coloredRegions; // region number -> is colored
  final double progressPercentage;
  final DateTime lastModified;
  final bool isCompleted;

  const UserProgress({
    required this.pageId,
    required this.coloredRegions,
    required this.progressPercentage,
    required this.lastModified,
    this.isCompleted = false,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  UserProgress copyWith({
    String? pageId,
    Map<int, bool>? coloredRegions,
    double? progressPercentage,
    DateTime? lastModified,
    bool? isCompleted,
  }) {
    return UserProgress(
      pageId: pageId ?? this.pageId,
      coloredRegions: coloredRegions ?? this.coloredRegions,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      lastModified: lastModified ?? this.lastModified,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  UserProgress markRegionColored(int regionNumber) {
    final newColoredRegions = Map<int, bool>.from(coloredRegions);
    newColoredRegions[regionNumber] = true;
    
    final totalRegions = newColoredRegions.length;
    final coloredCount = newColoredRegions.values.where((colored) => colored).length;
    final newProgress = totalRegions > 0 ? (coloredCount / totalRegions) * 100 : 0.0;
    
    return copyWith(
      coloredRegions: newColoredRegions,
      progressPercentage: newProgress,
      lastModified: DateTime.now(),
      isCompleted: newProgress >= 100.0,
    );
  }
}

@JsonSerializable()
class UserArtwork {
  final String id;
  final String pageId;
  final String title;
  final String thumbnailPath;
  final String completedImagePath;
  final DateTime completedAt;
  final int timeSpentMinutes;

  const UserArtwork({
    required this.id,
    required this.pageId,
    required this.title,
    required this.thumbnailPath,
    required this.completedImagePath,
    required this.completedAt,
    required this.timeSpentMinutes,
  });

  factory UserArtwork.fromJson(Map<String, dynamic> json) =>
      _$UserArtworkFromJson(json);

  Map<String, dynamic> toJson() => _$UserArtworkToJson(this);
}