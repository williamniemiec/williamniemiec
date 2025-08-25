import 'package:json_annotation/json_annotation.dart';

part 'catalog.g.dart';

@JsonSerializable()
class CatalogItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String? productCode;
  final List<String> imageUrls;
  final String category;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CatalogItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'USD',
    this.productCode,
    this.imageUrls = const [],
    this.category = 'General',
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) =>
      _$CatalogItemFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogItemToJson(this);

  CatalogItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? productCode,
    List<String>? imageUrls,
    String? category,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      productCode: productCode ?? this.productCode,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
}

@JsonSerializable()
class CartItem {
  final String catalogItemId;
  final int quantity;
  final String? notes;

  const CartItem({
    required this.catalogItemId,
    this.quantity = 1,
    this.notes,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  CartItem copyWith({
    String? catalogItemId,
    int? quantity,
    String? notes,
  }) {
    return CartItem(
      catalogItemId: catalogItemId ?? this.catalogItemId,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}