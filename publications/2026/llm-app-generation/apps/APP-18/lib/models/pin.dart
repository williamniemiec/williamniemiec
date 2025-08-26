enum PinType {
  image,
  video,
  product,
  article,
}

class Pin {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final String? videoUrl;
  final PinType type;
  final String userId;
  final String username;
  final String? userProfileImageUrl;
  final String? sourceUrl;
  final String? sourceDomain;
  final List<String> tags;
  final int width;
  final int height;
  final int likesCount;
  final int commentsCount;
  final int savesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isLiked;
  final bool isSaved;
  final String? boardId;
  final String? boardName;
  
  // Product-specific fields
  final double? price;
  final String? currency;
  final String? productTitle;
  final bool? inStock;
  final String? merchantName;

  // Colors extracted from image for better UI
  final List<String>? dominantColors;

  const Pin({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    this.videoUrl,
    required this.type,
    required this.userId,
    required this.username,
    this.userProfileImageUrl,
    this.sourceUrl,
    this.sourceDomain,
    this.tags = const [],
    required this.width,
    required this.height,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.savesCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
    this.isSaved = false,
    this.boardId,
    this.boardName,
    this.price,
    this.currency,
    this.productTitle,
    this.inStock,
    this.merchantName,
    this.dominantColors,
  });

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String,
      videoUrl: json['videoUrl'] as String?,
      type: PinType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => PinType.image,
      ),
      userId: json['userId'] as String,
      username: json['username'] as String,
      userProfileImageUrl: json['userProfileImageUrl'] as String?,
      sourceUrl: json['sourceUrl'] as String?,
      sourceDomain: json['sourceDomain'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      width: json['width'] as int,
      height: json['height'] as int,
      likesCount: json['likesCount'] as int? ?? 0,
      commentsCount: json['commentsCount'] as int? ?? 0,
      savesCount: json['savesCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isLiked: json['isLiked'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      boardId: json['boardId'] as String?,
      boardName: json['boardName'] as String?,
      price: json['price']?.toDouble(),
      currency: json['currency'] as String?,
      productTitle: json['productTitle'] as String?,
      inStock: json['inStock'] as bool?,
      merchantName: json['merchantName'] as String?,
      dominantColors: json['dominantColors'] != null
          ? List<String>.from(json['dominantColors'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'type': type.name,
      'userId': userId,
      'username': username,
      'userProfileImageUrl': userProfileImageUrl,
      'sourceUrl': sourceUrl,
      'sourceDomain': sourceDomain,
      'tags': tags,
      'width': width,
      'height': height,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'savesCount': savesCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isLiked': isLiked,
      'isSaved': isSaved,
      'boardId': boardId,
      'boardName': boardName,
      'price': price,
      'currency': currency,
      'productTitle': productTitle,
      'inStock': inStock,
      'merchantName': merchantName,
      'dominantColors': dominantColors,
    };
  }

  Pin copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? videoUrl,
    PinType? type,
    String? userId,
    String? username,
    String? userProfileImageUrl,
    String? sourceUrl,
    String? sourceDomain,
    List<String>? tags,
    int? width,
    int? height,
    int? likesCount,
    int? commentsCount,
    int? savesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
    bool? isSaved,
    String? boardId,
    String? boardName,
    double? price,
    String? currency,
    String? productTitle,
    bool? inStock,
    String? merchantName,
    List<String>? dominantColors,
  }) {
    return Pin(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceDomain: sourceDomain ?? this.sourceDomain,
      tags: tags ?? this.tags,
      width: width ?? this.width,
      height: height ?? this.height,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      savesCount: savesCount ?? this.savesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      boardId: boardId ?? this.boardId,
      boardName: boardName ?? this.boardName,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      productTitle: productTitle ?? this.productTitle,
      inStock: inStock ?? this.inStock,
      merchantName: merchantName ?? this.merchantName,
      dominantColors: dominantColors ?? this.dominantColors,
    );
  }

  double get aspectRatio => height > 0 ? width / height : 1.0;

  bool get isProduct => type == PinType.product;
  bool get isVideo => type == PinType.video;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pin && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Pin(id: $id, title: $title, type: $type)';
  }
}