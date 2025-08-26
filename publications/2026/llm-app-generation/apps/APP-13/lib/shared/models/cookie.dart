class Cookie {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final List<String> ingredients;
  final List<String> allergens;
  final int calories;
  final bool isAvailable;
  final bool isWeeklySpecial;
  final DateTime? availableUntil;

  const Cookie({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.ingredients,
    required this.allergens,
    required this.calories,
    this.isAvailable = true,
    this.isWeeklySpecial = false,
    this.availableUntil,
  });

  factory Cookie.fromJson(Map<String, dynamic> json) {
    return Cookie(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      ingredients: List<String>.from(json['ingredients'] as List),
      allergens: List<String>.from(json['allergens'] as List),
      calories: json['calories'] as int,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isWeeklySpecial: json['isWeeklySpecial'] as bool? ?? false,
      availableUntil: json['availableUntil'] != null
          ? DateTime.parse(json['availableUntil'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'ingredients': ingredients,
      'allergens': allergens,
      'calories': calories,
      'isAvailable': isAvailable,
      'isWeeklySpecial': isWeeklySpecial,
      'availableUntil': availableUntil?.toIso8601String(),
    };
  }

  Cookie copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    List<String>? ingredients,
    List<String>? allergens,
    int? calories,
    bool? isAvailable,
    bool? isWeeklySpecial,
    DateTime? availableUntil,
  }) {
    return Cookie(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      calories: calories ?? this.calories,
      isAvailable: isAvailable ?? this.isAvailable,
      isWeeklySpecial: isWeeklySpecial ?? this.isWeeklySpecial,
      availableUntil: availableUntil ?? this.availableUntil,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cookie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Cookie(id: $id, name: $name, price: \$${price.toStringAsFixed(2)})';
  }
}