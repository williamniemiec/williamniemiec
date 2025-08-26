class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String logoUrl;
  final List<String> categories;
  final double rating;
  final int reviewCount;
  final int deliveryTime; // in minutes
  final double deliveryFee;
  final double minimumOrder;
  final bool isOpen;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> paymentMethods;
  final bool isFavorite;
  final List<ProductCategory> menu;
  final List<String> promotions;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.logoUrl,
    required this.categories,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isOpen,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.paymentMethods,
    this.isFavorite = false,
    this.menu = const [],
    this.promotions = const [],
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      logoUrl: json['logoUrl'],
      categories: List<String>.from(json['categories']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      deliveryTime: json['deliveryTime'],
      deliveryFee: json['deliveryFee'].toDouble(),
      minimumOrder: json['minimumOrder'].toDouble(),
      isOpen: json['isOpen'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      paymentMethods: List<String>.from(json['paymentMethods']),
      isFavorite: json['isFavorite'] ?? false,
      menu: (json['menu'] as List<dynamic>?)
          ?.map((e) => ProductCategory.fromJson(e))
          .toList() ?? [],
      promotions: List<String>.from(json['promotions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      'categories': categories,
      'rating': rating,
      'reviewCount': reviewCount,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'isOpen': isOpen,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'paymentMethods': paymentMethods,
      'isFavorite': isFavorite,
      'menu': menu.map((e) => e.toJson()).toList(),
      'promotions': promotions,
    };
  }

  String get deliveryTimeText {
    return '${deliveryTime}min';
  }

  String get deliveryFeeText {
    return deliveryFee == 0 ? 'Grátis' : 'R\$ ${deliveryFee.toStringAsFixed(2)}';
  }

  String get ratingText {
    return rating.toStringAsFixed(1);
  }
}

class ProductCategory {
  final String id;
  final String name;
  final String? description;
  final List<Product> products;

  ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.products = const [],
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}

class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final double? originalPrice;
  final bool isAvailable;
  final List<ProductOption> options;
  final List<String> allergens;
  final int preparationTime; // in minutes
  final bool isPopular;
  final bool isPromotion;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.originalPrice,
    this.isAvailable = true,
    this.options = const [],
    this.allergens = const [],
    this.preparationTime = 0,
    this.isPopular = false,
    this.isPromotion = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      isAvailable: json['isAvailable'] ?? true,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => ProductOption.fromJson(e))
          .toList() ?? [],
      allergens: List<String>.from(json['allergens'] ?? []),
      preparationTime: json['preparationTime'] ?? 0,
      isPopular: json['isPopular'] ?? false,
      isPromotion: json['isPromotion'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'originalPrice': originalPrice,
      'isAvailable': isAvailable,
      'options': options.map((e) => e.toJson()).toList(),
      'allergens': allergens,
      'preparationTime': preparationTime,
      'isPopular': isPopular,
      'isPromotion': isPromotion,
    };
  }

  String get priceText {
    return 'R\$ ${price.toStringAsFixed(2)}';
  }

  String? get originalPriceText {
    return originalPrice != null ? 'R\$ ${originalPrice!.toStringAsFixed(2)}' : null;
  }

  bool get hasDiscount {
    return originalPrice != null && originalPrice! > price;
  }

  double get discountPercentage {
    if (!hasDiscount) return 0;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }
}

class ProductOption {
  final String id;
  final String name;
  final String type; // 'single', 'multiple'
  final bool isRequired;
  final int? minSelections;
  final int? maxSelections;
  final List<ProductOptionItem> items;

  ProductOption({
    required this.id,
    required this.name,
    required this.type,
    this.isRequired = false,
    this.minSelections,
    this.maxSelections,
    this.items = const [],
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) {
    return ProductOption(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      isRequired: json['isRequired'] ?? false,
      minSelections: json['minSelections'],
      maxSelections: json['maxSelections'],
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ProductOptionItem.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isRequired': isRequired,
      'minSelections': minSelections,
      'maxSelections': maxSelections,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductOptionItem {
  final String id;
  final String name;
  final double price;
  final bool isDefault;

  ProductOptionItem({
    required this.id,
    required this.name,
    required this.price,
    this.isDefault = false,
  });

  factory ProductOptionItem.fromJson(Map<String, dynamic> json) {
    return ProductOptionItem(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'isDefault': isDefault,
    };
  }

  String get priceText {
    return price == 0 ? 'Grátis' : '+ R\$ ${price.toStringAsFixed(2)}';
  }
}