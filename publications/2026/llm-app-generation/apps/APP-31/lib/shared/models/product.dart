class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final bool isFreeShipping;
  final bool isFlashSale;
  final DateTime? flashSaleEndTime;
  final int stockQuantity;
  final List<ProductVariant> variants;
  final String sellerId;
  final String sellerName;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.images,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.tags,
    required this.isFreeShipping,
    required this.isFlashSale,
    this.flashSaleEndTime,
    required this.stockQuantity,
    required this.variants,
    required this.sellerId,
    required this.sellerName,
    required this.createdAt,
  });

  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - price) / originalPrice * 100);
  }

  bool get hasDiscount => originalPrice > price;

  bool get isInStock => stockQuantity > 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isFreeShipping: json['isFreeShipping'] ?? false,
      isFlashSale: json['isFlashSale'] ?? false,
      flashSaleEndTime: json['flashSaleEndTime'] != null
          ? DateTime.parse(json['flashSaleEndTime'])
          : null,
      stockQuantity: json['stockQuantity'] ?? 0,
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => ProductVariant.fromJson(v))
              .toList() ??
          [],
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
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
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'isFreeShipping': isFreeShipping,
      'isFlashSale': isFlashSale,
      'flashSaleEndTime': flashSaleEndTime?.toIso8601String(),
      'stockQuantity': stockQuantity,
      'variants': variants.map((v) => v.toJson()).toList(),
      'sellerId': sellerId,
      'sellerName': sellerName,
      'createdAt': createdAt.toIso8601String(),
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
    double? rating,
    int? reviewCount,
    List<String>? tags,
    bool? isFreeShipping,
    bool? isFlashSale,
    DateTime? flashSaleEndTime,
    int? stockQuantity,
    List<ProductVariant>? variants,
    String? sellerId,
    String? sellerName,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      isFreeShipping: isFreeShipping ?? this.isFreeShipping,
      isFlashSale: isFlashSale ?? this.isFlashSale,
      flashSaleEndTime: flashSaleEndTime ?? this.flashSaleEndTime,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      variants: variants ?? this.variants,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class ProductVariant {
  final String id;
  final String name;
  final String value;
  final double? priceAdjustment;
  final int stockQuantity;
  final String? image;

  ProductVariant({
    required this.id,
    required this.name,
    required this.value,
    this.priceAdjustment,
    required this.stockQuantity,
    this.image,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      priceAdjustment: json['priceAdjustment']?.toDouble(),
      stockQuantity: json['stockQuantity'] ?? 0,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'priceAdjustment': priceAdjustment,
      'stockQuantity': stockQuantity,
      'image': image,
    };
  }
}