import 'package:hive/hive.dart';

part 'trend.g.dart';

@HiveType(typeId: 13)
class Trend extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String query;

  @HiveField(3)
  final int postsCount;

  @HiveField(4)
  final TrendType type;

  @HiveField(5)
  final String? description;

  @HiveField(6)
  final String? location;

  @HiveField(7)
  final DateTime updatedAt;

  @HiveField(8)
  final int rank;

  @HiveField(9)
  final double score;

  @HiveField(10)
  final Map<String, dynamic>? metadata;

  Trend({
    required this.id,
    required this.name,
    required this.query,
    required this.postsCount,
    required this.type,
    this.description,
    this.location,
    required this.updatedAt,
    required this.rank,
    required this.score,
    this.metadata,
  });

  Trend copyWith({
    String? id,
    String? name,
    String? query,
    int? postsCount,
    TrendType? type,
    String? description,
    String? location,
    DateTime? updatedAt,
    int? rank,
    double? score,
    Map<String, dynamic>? metadata,
  }) {
    return Trend(
      id: id ?? this.id,
      name: name ?? this.name,
      query: query ?? this.query,
      postsCount: postsCount ?? this.postsCount,
      type: type ?? this.type,
      description: description ?? this.description,
      location: location ?? this.location,
      updatedAt: updatedAt ?? this.updatedAt,
      rank: rank ?? this.rank,
      score: score ?? this.score,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'query': query,
      'postsCount': postsCount,
      'type': type.name,
      'description': description,
      'location': location,
      'updatedAt': updatedAt.toIso8601String(),
      'rank': rank,
      'score': score,
      'metadata': metadata,
    };
  }

  factory Trend.fromJson(Map<String, dynamic> json) {
    return Trend(
      id: json['id'] as String,
      name: json['name'] as String,
      query: json['query'] as String,
      postsCount: json['postsCount'] as int,
      type: TrendType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TrendType.hashtag,
      ),
      description: json['description'] as String?,
      location: json['location'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      rank: json['rank'] as int,
      score: (json['score'] as num).toDouble(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  String get formattedPostsCount {
    if (postsCount < 1000) {
      return postsCount.toString();
    } else if (postsCount < 1000000) {
      return '${(postsCount / 1000).toStringAsFixed(1)}K';
    } else {
      return '${(postsCount / 1000000).toStringAsFixed(1)}M';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Trend && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Trend(id: $id, name: $name, postsCount: $postsCount, rank: $rank)';
  }
}

@HiveType(typeId: 14)
enum TrendType {
  @HiveField(0)
  hashtag,
  @HiveField(1)
  topic,
  @HiveField(2)
  event,
  @HiveField(3)
  person,
  @HiveField(4)
  location,
  @HiveField(5)
  news,
  @HiveField(6)
  sports,
  @HiveField(7)
  entertainment,
  @HiveField(8)
  technology,
  @HiveField(9)
  politics,
}