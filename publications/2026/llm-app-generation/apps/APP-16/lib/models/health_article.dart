enum ArticleCategory {
  bloodPressure,
  diet,
  exercise,
  lifestyle,
  medication,
  general,
}

extension ArticleCategoryExtension on ArticleCategory {
  String get displayName {
    switch (this) {
      case ArticleCategory.bloodPressure:
        return 'Blood Pressure';
      case ArticleCategory.diet:
        return 'Diet & Nutrition';
      case ArticleCategory.exercise:
        return 'Exercise';
      case ArticleCategory.lifestyle:
        return 'Lifestyle';
      case ArticleCategory.medication:
        return 'Medication';
      case ArticleCategory.general:
        return 'General Health';
    }
  }

  String get iconName {
    switch (this) {
      case ArticleCategory.bloodPressure:
        return 'favorite';
      case ArticleCategory.diet:
        return 'restaurant';
      case ArticleCategory.exercise:
        return 'fitness_center';
      case ArticleCategory.lifestyle:
        return 'self_improvement';
      case ArticleCategory.medication:
        return 'medication';
      case ArticleCategory.general:
        return 'health_and_safety';
    }
  }
}

class HealthArticle {
  final int? id;
  final String title;
  final String summary;
  final String content;
  final ArticleCategory category;
  final String? imageUrl;
  final int readTimeMinutes;
  final List<String> tags;
  final DateTime publishedAt;
  final bool isFavorite;

  HealthArticle({
    this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    this.imageUrl,
    required this.readTimeMinutes,
    this.tags = const [],
    required this.publishedAt,
    this.isFavorite = false,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'category': category.index,
      'imageUrl': imageUrl,
      'readTimeMinutes': readTimeMinutes,
      'tags': tags.join(','),
      'publishedAt': publishedAt.millisecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Create from Map (database)
  factory HealthArticle.fromMap(Map<String, dynamic> map) {
    return HealthArticle(
      id: map['id'],
      title: map['title'],
      summary: map['summary'],
      content: map['content'],
      category: ArticleCategory.values[map['category']],
      imageUrl: map['imageUrl'],
      readTimeMinutes: map['readTimeMinutes'],
      tags: map['tags'] != null && map['tags'].isNotEmpty
          ? map['tags'].split(',')
          : [],
      publishedAt: DateTime.fromMillisecondsSinceEpoch(map['publishedAt']),
      isFavorite: map['isFavorite'] == 1,
    );
  }

  // Copy with method for updates
  HealthArticle copyWith({
    int? id,
    String? title,
    String? summary,
    String? content,
    ArticleCategory? category,
    String? imageUrl,
    int? readTimeMinutes,
    List<String>? tags,
    DateTime? publishedAt,
    bool? isFavorite,
  }) {
    return HealthArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      tags: tags ?? this.tags,
      publishedAt: publishedAt ?? this.publishedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'HealthArticle(id: $id, title: $title, summary: $summary, category: $category, readTimeMinutes: $readTimeMinutes, tags: $tags, publishedAt: $publishedAt, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthArticle &&
        other.id == id &&
        other.title == title &&
        other.summary == summary &&
        other.content == content &&
        other.category == category &&
        other.imageUrl == imageUrl &&
        other.readTimeMinutes == readTimeMinutes &&
        other.tags.toString() == tags.toString() &&
        other.publishedAt == publishedAt &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        summary.hashCode ^
        content.hashCode ^
        category.hashCode ^
        imageUrl.hashCode ^
        readTimeMinutes.hashCode ^
        tags.hashCode ^
        publishedAt.hashCode ^
        isFavorite.hashCode;
  }
}