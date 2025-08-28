class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String category;
  final String subCategory;
  final List<String> availableSizes;
  final List<String> availableColors;
  final double rating;
  final int reviewCount;
  final bool isOnSale;
  final bool isFlashSale;
  final DateTime? flashSaleEndTime;
  final int discountPercentage;
  final String brand;
  final String material;
  final String careInstructions;
  final Map<String, String> sizeGuide;
  final List<String> tags;
  final int stockQuantity;
  final bool isInStock;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;
  final bool isTrending;
  final bool isNewArrival;
  final double weight;
  final Map<String, dynamic> dimensions;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.availableSizes,
    required this.availableColors,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOnSale = false,
    this.isFlashSale = false,
    this.flashSaleEndTime,
    this.discountPercentage = 0,
    this.brand = '',
    this.material = '',
    this.careInstructions = '',
    this.sizeGuide = const {},
    this.tags = const [],
    this.stockQuantity = 0,
    this.isInStock = true,
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
    this.isTrending = false,
    this.isNewArrival = false,
    this.weight = 0.0,
    this.dimensions = const {},
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      subCategory: json['subCategory'] ?? '',
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
      availableColors: List<String>.from(json['availableColors'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      isOnSale: json['isOnSale'] ?? false,
      isFlashSale: json['isFlashSale'] ?? false,
      flashSaleEndTime: json['flashSaleEndTime'] != null
          ? DateTime.parse(json['flashSaleEndTime'])
          : null,
      discountPercentage: json['discountPercentage'] ?? 0,
      brand: json['brand'] ?? '',
      material: json['material'] ?? '',
      careInstructions: json['careInstructions'] ?? '',
      sizeGuide: Map<String, String>.from(json['sizeGuide'] ?? {}),
      tags: List<String>.from(json['tags'] ?? []),
      stockQuantity: json['stockQuantity'] ?? 0,
      isInStock: json['isInStock'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      isFeatured: json['isFeatured'] ?? false,
      isTrending: json['isTrending'] ?? false,
      isNewArrival: json['isNewArrival'] ?? false,
      weight: (json['weight'] ?? 0).toDouble(),
      dimensions: Map<String, dynamic>.from(json['dimensions'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'rating': rating,
      'reviewCount': reviewCount,
      'isOnSale': isOnSale,
      'isFlashSale': isFlashSale,
      'flashSaleEndTime': flashSaleEndTime?.toIso8601String(),
      'discountPercentage': discountPercentage,
      'brand': brand,
      'material': material,
      'careInstructions': careInstructions,
      'sizeGuide': sizeGuide,
      'tags': tags,
      'stockQuantity': stockQuantity,
      'isInStock': isInStock,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFeatured': isFeatured,
      'isTrending': isTrending,
      'isNewArrival': isNewArrival,
      'weight': weight,
      'dimensions': dimensions,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    List<String>? images,
    String? category,
    String? subCategory,
    List<String>? availableSizes,
    List<String>? availableColors,
    double? rating,
    int? reviewCount,
    bool? isOnSale,
    bool? isFlashSale,
    DateTime? flashSaleEndTime,
    int? discountPercentage,
    String? brand,
    String? material,
    String? careInstructions,
    Map<String, String>? sizeGuide,
    List<String>? tags,
    int? stockQuantity,
    bool? isInStock,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFeatured,
    bool? isTrending,
    bool? isNewArrival,
    double? weight,
    Map<String, dynamic>? dimensions,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      availableSizes: availableSizes ?? this.availableSizes,
      availableColors: availableColors ?? this.availableColors,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOnSale: isOnSale ?? this.isOnSale,
      isFlashSale: isFlashSale ?? this.isFlashSale,
      flashSaleEndTime: flashSaleEndTime ?? this.flashSaleEndTime,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      brand: brand ?? this.brand,
      material: material ?? this.material,
      careInstructions: careInstructions ?? this.careInstructions,
      sizeGuide: sizeGuide ?? this.sizeGuide,
      tags: tags ?? this.tags,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isInStock: isInStock ?? this.isInStock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isTrending: isTrending ?? this.isTrending,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      weight: weight ?? this.weight,
      dimensions: dimensions ?? this.dimensions,
    );
  }

  // Helper methods
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  
  double get discountAmount => hasDiscount ? originalPrice! - price : 0.0;
  
  String get primaryImage => images.isNotEmpty ? images.first : '';
  
  bool get isLowStock => stockQuantity <= 5 && stockQuantity > 0;
  
  bool get isOutOfStock => stockQuantity <= 0 || !isInStock;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, category: $category}';
  }
}