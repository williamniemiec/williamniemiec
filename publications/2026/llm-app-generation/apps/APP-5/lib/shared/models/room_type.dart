enum RoomCategory {
  interior,
  exterior,
}

class RoomType {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final RoomCategory category;
  final List<String> suggestedStyles;

  const RoomType({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    this.suggestedStyles = const [],
  });

  factory RoomType.fromJson(Map<String, dynamic> json) {
    return RoomType(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['iconPath'] as String,
      category: RoomCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => RoomCategory.interior,
      ),
      suggestedStyles: List<String>.from(json['suggestedStyles'] as List? ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconPath': iconPath,
      'category': category.name,
      'suggestedStyles': suggestedStyles,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoomType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}