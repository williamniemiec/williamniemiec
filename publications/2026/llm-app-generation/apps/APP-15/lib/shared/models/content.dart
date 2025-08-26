import 'package:hive/hive.dart';

part 'content.g.dart';

@HiveType(typeId: 2)
class Content extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final ContentType type;

  @HiveField(4)
  final String? thumbnailUrl;

  @HiveField(5)
  final String? videoUrl;

  @HiveField(6)
  final String? audioUrl;

  @HiveField(7)
  final int durationMinutes;

  @HiveField(8)
  final ContentCategory category;

  @HiveField(9)
  final DifficultyLevel difficulty;

  @HiveField(10)
  final String partner;

  @HiveField(11)
  final List<String> tags;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final DateTime updatedAt;

  @HiveField(14)
  final bool isFeatured;

  @HiveField(15)
  final bool isPremium;

  @HiveField(16)
  final double rating;

  @HiveField(17)
  final int viewCount;

  @HiveField(18)
  final String? instructorName;

  @HiveField(19)
  final String? equipment;

  @HiveField(20)
  final List<String> targetMuscles;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.thumbnailUrl,
    this.videoUrl,
    this.audioUrl,
    required this.durationMinutes,
    required this.category,
    required this.difficulty,
    required this.partner,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
    this.isPremium = false,
    this.rating = 0.0,
    this.viewCount = 0,
    this.instructorName,
    this.equipment,
    this.targetMuscles = const [],
  });

  String get durationDisplay {
    if (durationMinutes < 60) {
      return '${durationMinutes}min';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      return minutes > 0 ? '${hours}h ${minutes}min' : '${hours}h';
    }
  }

  String get difficultyDisplay {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return 'Beginner';
      case DifficultyLevel.intermediate:
        return 'Intermediate';
      case DifficultyLevel.advanced:
        return 'Advanced';
    }
  }

  String get categoryDisplay {
    switch (category) {
      case ContentCategory.cardio:
        return 'Cardio';
      case ContentCategory.strength:
        return 'Strength';
      case ContentCategory.yoga:
        return 'Yoga';
      case ContentCategory.meditation:
        return 'Meditation';
      case ContentCategory.nutrition:
        return 'Nutrition';
      case ContentCategory.wellness:
        return 'Wellness';
      case ContentCategory.hiit:
        return 'HIIT';
      case ContentCategory.stretching:
        return 'Stretching';
    }
  }

  Content copyWith({
    String? id,
    String? title,
    String? description,
    ContentType? type,
    String? thumbnailUrl,
    String? videoUrl,
    String? audioUrl,
    int? durationMinutes,
    ContentCategory? category,
    DifficultyLevel? difficulty,
    String? partner,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFeatured,
    bool? isPremium,
    double? rating,
    int? viewCount,
    String? instructorName,
    String? equipment,
    List<String>? targetMuscles,
  }) {
    return Content(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      partner: partner ?? this.partner,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isPremium: isPremium ?? this.isPremium,
      rating: rating ?? this.rating,
      viewCount: viewCount ?? this.viewCount,
      instructorName: instructorName ?? this.instructorName,
      equipment: equipment ?? this.equipment,
      targetMuscles: targetMuscles ?? this.targetMuscles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'durationMinutes': durationMinutes,
      'category': category.name,
      'difficulty': difficulty.name,
      'partner': partner,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFeatured': isFeatured,
      'isPremium': isPremium,
      'rating': rating,
      'viewCount': viewCount,
      'instructorName': instructorName,
      'equipment': equipment,
      'targetMuscles': targetMuscles,
    };
  }

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ContentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ContentType.video,
      ),
      thumbnailUrl: json['thumbnailUrl'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      durationMinutes: json['durationMinutes'],
      category: ContentCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ContentCategory.cardio,
      ),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => DifficultyLevel.beginner,
      ),
      partner: json['partner'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isFeatured: json['isFeatured'] ?? false,
      isPremium: json['isPremium'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      viewCount: json['viewCount'] ?? 0,
      instructorName: json['instructorName'],
      equipment: json['equipment'],
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
    );
  }
}

@HiveType(typeId: 3)
enum ContentType {
  @HiveField(0)
  video,
  @HiveField(1)
  audio,
  @HiveField(2)
  article,
  @HiveField(3)
  recipe,
}

@HiveType(typeId: 4)
enum ContentCategory {
  @HiveField(0)
  cardio,
  @HiveField(1)
  strength,
  @HiveField(2)
  yoga,
  @HiveField(3)
  meditation,
  @HiveField(4)
  nutrition,
  @HiveField(5)
  wellness,
  @HiveField(6)
  hiit,
  @HiveField(7)
  stretching,
}

@HiveType(typeId: 5)
enum DifficultyLevel {
  @HiveField(0)
  beginner,
  @HiveField(1)
  intermediate,
  @HiveField(2)
  advanced,
}