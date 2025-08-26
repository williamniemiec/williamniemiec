class Category {
  final String id;
  final String name;
  final String displayName;
  final String? description;
  final String? imageUrl;
  final String? iconUrl;
  final List<String> tags;
  final int pinsCount;
  final bool isPopular;
  final bool isTrending;
  final int sortOrder;

  const Category({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.tags = const [],
    this.pinsCount = 0,
    this.isPopular = false,
    this.isTrending = false,
    this.sortOrder = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      iconUrl: json['iconUrl'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      pinsCount: json['pinsCount'] as int? ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      isTrending: json['isTrending'] as bool? ?? false,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'description': description,
      'imageUrl': imageUrl,
      'iconUrl': iconUrl,
      'tags': tags,
      'pinsCount': pinsCount,
      'isPopular': isPopular,
      'isTrending': isTrending,
      'sortOrder': sortOrder,
    };
  }

  Category copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? imageUrl,
    String? iconUrl,
    List<String>? tags,
    int? pinsCount,
    bool? isPopular,
    bool? isTrending,
    int? sortOrder,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      tags: tags ?? this.tags,
      pinsCount: pinsCount ?? this.pinsCount,
      isPopular: isPopular ?? this.isPopular,
      isTrending: isTrending ?? this.isTrending,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, displayName: $displayName)';
  }
}

// Predefined categories for Pinterest
class PinterestCategories {
  static const List<Category> defaultCategories = [
    Category(
      id: 'home-decor',
      name: 'home_decor',
      displayName: 'Home Decor',
      description: 'Beautiful home decoration ideas and inspiration',
      isPopular: true,
      sortOrder: 1,
    ),
    Category(
      id: 'fashion',
      name: 'fashion',
      displayName: 'Fashion',
      description: 'Style inspiration and fashion trends',
      isPopular: true,
      sortOrder: 2,
    ),
    Category(
      id: 'food-drink',
      name: 'food_drink',
      displayName: 'Food & Drink',
      description: 'Delicious recipes and food inspiration',
      isPopular: true,
      sortOrder: 3,
    ),
    Category(
      id: 'travel',
      name: 'travel',
      displayName: 'Travel',
      description: 'Travel destinations and vacation ideas',
      isPopular: true,
      sortOrder: 4,
    ),
    Category(
      id: 'diy-crafts',
      name: 'diy_crafts',
      displayName: 'DIY & Crafts',
      description: 'Creative DIY projects and craft ideas',
      isPopular: true,
      sortOrder: 5,
    ),
    Category(
      id: 'beauty',
      name: 'beauty',
      displayName: 'Beauty',
      description: 'Beauty tips, makeup, and skincare',
      sortOrder: 6,
    ),
    Category(
      id: 'wedding',
      name: 'wedding',
      displayName: 'Wedding',
      description: 'Wedding planning and inspiration',
      sortOrder: 7,
    ),
    Category(
      id: 'art',
      name: 'art',
      displayName: 'Art',
      description: 'Artistic inspiration and creative works',
      sortOrder: 8,
    ),
    Category(
      id: 'photography',
      name: 'photography',
      displayName: 'Photography',
      description: 'Photography inspiration and techniques',
      sortOrder: 9,
    ),
    Category(
      id: 'gardening',
      name: 'gardening',
      displayName: 'Gardening',
      description: 'Garden ideas and plant care tips',
      sortOrder: 10,
    ),
  ];

  static Category? getCategoryById(String id) {
    try {
      return defaultCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static Category? getCategoryByName(String name) {
    try {
      return defaultCategories.firstWhere((category) => category.name == name);
    } catch (e) {
      return null;
    }
  }

  static List<Category> getPopularCategories() {
    return defaultCategories.where((category) => category.isPopular).toList();
  }

  static List<Category> getTrendingCategories() {
    return defaultCategories.where((category) => category.isTrending).toList();
  }
}