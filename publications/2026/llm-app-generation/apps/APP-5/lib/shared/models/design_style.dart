class DesignStyle {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final String category;
  final bool isPremium;
  final List<String> tags;

  const DesignStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.category,
    this.isPremium = false,
    this.tags = const [],
  });

  factory DesignStyle.fromJson(Map<String, dynamic> json) {
    return DesignStyle(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      category: json['category'] as String,
      isPremium: json['isPremium'] as bool? ?? false,
      tags: List<String>.from(json['tags'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'isPremium': isPremium,
      'tags': tags,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignStyle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}