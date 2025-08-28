class DiscoverArticle {
  final String id;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String source;
  final String? sourceIcon;
  final DateTime publishedAt;
  final List<String> topics;
  final ArticleType type;
  final bool isBookmarked;
  final bool isRead;

  const DiscoverArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.source,
    this.sourceIcon,
    required this.publishedAt,
    required this.topics,
    required this.type,
    this.isBookmarked = false,
    this.isRead = false,
  });

  factory DiscoverArticle.fromJson(Map<String, dynamic> json) {
    return DiscoverArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String,
      source: json['source'] as String,
      sourceIcon: json['sourceIcon'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      topics: List<String>.from(json['topics'] as List),
      type: ArticleType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ArticleType.article,
      ),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'source': source,
      'sourceIcon': sourceIcon,
      'publishedAt': publishedAt.toIso8601String(),
      'topics': topics,
      'type': type.name,
      'isBookmarked': isBookmarked,
      'isRead': isRead,
    };
  }

  DiscoverArticle copyWith({
    String? id,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    String? source,
    String? sourceIcon,
    DateTime? publishedAt,
    List<String>? topics,
    ArticleType? type,
    bool? isBookmarked,
    bool? isRead,
  }) {
    return DiscoverArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      sourceIcon: sourceIcon ?? this.sourceIcon,
      publishedAt: publishedAt ?? this.publishedAt,
      topics: topics ?? this.topics,
      type: type ?? this.type,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isRead: isRead ?? this.isRead,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(publishedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DiscoverArticle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'DiscoverArticle(id: $id, title: $title, source: $source)';
  }
}

enum ArticleType {
  article,
  video,
  news,
  sports,
  weather,
  entertainment,
  technology,
  science,
  health,
  business,
}