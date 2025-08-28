class SearchResult {
  final String id;
  final String title;
  final String url;
  final String description;
  final String? favicon;
  final String? thumbnail;
  final DateTime timestamp;
  final SearchResultType type;

  const SearchResult({
    required this.id,
    required this.title,
    required this.url,
    required this.description,
    this.favicon,
    this.thumbnail,
    required this.timestamp,
    required this.type,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String,
      favicon: json['favicon'] as String?,
      thumbnail: json['thumbnail'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: SearchResultType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SearchResultType.web,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'description': description,
      'favicon': favicon,
      'thumbnail': thumbnail,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
    };
  }

  SearchResult copyWith({
    String? id,
    String? title,
    String? url,
    String? description,
    String? favicon,
    String? thumbnail,
    DateTime? timestamp,
    SearchResultType? type,
  }) {
    return SearchResult(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      description: description ?? this.description,
      favicon: favicon ?? this.favicon,
      thumbnail: thumbnail ?? this.thumbnail,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SearchResult(id: $id, title: $title, url: $url)';
  }
}

enum SearchResultType {
  web,
  image,
  video,
  news,
  shopping,
  maps,
}