import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'json_converters.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset extends Equatable {
  final String id;
  final String name;
  final String? description;
  final AssetType type;
  final String url;
  final String? thumbnailUrl;
  final List<String> tags;
  final String category;
  final bool isPremium;
  final bool isFeatured;
  final int downloadCount;
  final double rating;
  final int reviewCount;
  final String authorId;
  final String? authorName;
  final AssetMetadata metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Asset({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    required this.tags,
    required this.category,
    this.isPremium = false,
    this.isFeatured = false,
    this.downloadCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.authorId,
    this.authorName,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
  Map<String, dynamic> toJson() => _$AssetToJson(this);

  Asset copyWith({
    String? id,
    String? name,
    String? description,
    AssetType? type,
    String? url,
    String? thumbnailUrl,
    List<String>? tags,
    String? category,
    bool? isPremium,
    bool? isFeatured,
    int? downloadCount,
    double? rating,
    int? reviewCount,
    String? authorId,
    String? authorName,
    AssetMetadata? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Asset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPremium: isPremium ?? this.isPremium,
      isFeatured: isFeatured ?? this.isFeatured,
      downloadCount: downloadCount ?? this.downloadCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        url,
        thumbnailUrl,
        tags,
        category,
        isPremium,
        isFeatured,
        downloadCount,
        rating,
        reviewCount,
        authorId,
        authorName,
        metadata,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class AssetMetadata extends Equatable {
  final int? width;
  final int? height;
  final int? fileSizeBytes;
  final String? fileFormat;
  final int? durationMs; // For video/audio assets
  @ColorListConverter()
  final List<Color>? dominantColors; // For images
  final bool? hasTransparency; // For images
  final String? license;
  final Map<String, dynamic>? additionalData;

  const AssetMetadata({
    this.width,
    this.height,
    this.fileSizeBytes,
    this.fileFormat,
    this.durationMs,
    this.dominantColors,
    this.hasTransparency,
    this.license,
    this.additionalData,
  });

  factory AssetMetadata.fromJson(Map<String, dynamic> json) =>
      _$AssetMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$AssetMetadataToJson(this);

  AssetMetadata copyWith({
    int? width,
    int? height,
    int? fileSizeBytes,
    String? fileFormat,
    int? durationMs,
    List<Color>? dominantColors,
    bool? hasTransparency,
    String? license,
    Map<String, dynamic>? additionalData,
  }) {
    return AssetMetadata(
      width: width ?? this.width,
      height: height ?? this.height,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      fileFormat: fileFormat ?? this.fileFormat,
      durationMs: durationMs ?? this.durationMs,
      dominantColors: dominantColors ?? this.dominantColors,
      hasTransparency: hasTransparency ?? this.hasTransparency,
      license: license ?? this.license,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  List<Object?> get props => [
        width,
        height,
        fileSizeBytes,
        fileFormat,
        durationMs,
        dominantColors,
        hasTransparency,
        license,
        additionalData,
      ];
}

enum AssetType {
  @JsonValue('photo')
  photo,
  @JsonValue('illustration')
  illustration,
  @JsonValue('graphic')
  graphic,
  @JsonValue('icon')
  icon,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('font')
  font,
  @JsonValue('shape')
  shape,
  @JsonValue('sticker')
  sticker,
  @JsonValue('frame')
  frame,
  @JsonValue('background')
  background,
}

extension AssetTypeExtension on AssetType {
  String get displayName {
    switch (this) {
      case AssetType.photo:
        return 'Photo';
      case AssetType.illustration:
        return 'Illustration';
      case AssetType.graphic:
        return 'Graphic';
      case AssetType.icon:
        return 'Icon';
      case AssetType.video:
        return 'Video';
      case AssetType.audio:
        return 'Audio';
      case AssetType.font:
        return 'Font';
      case AssetType.shape:
        return 'Shape';
      case AssetType.sticker:
        return 'Sticker';
      case AssetType.frame:
        return 'Frame';
      case AssetType.background:
        return 'Background';
    }
  }

  IconData get icon {
    switch (this) {
      case AssetType.photo:
        return Icons.photo;
      case AssetType.illustration:
        return Icons.brush;
      case AssetType.graphic:
        return Icons.image;
      case AssetType.icon:
        return Icons.star;
      case AssetType.video:
        return Icons.videocam;
      case AssetType.audio:
        return Icons.audiotrack;
      case AssetType.font:
        return Icons.text_format;
      case AssetType.shape:
        return Icons.category;
      case AssetType.sticker:
        return Icons.emoji_emotions;
      case AssetType.frame:
        return Icons.crop_free;
      case AssetType.background:
        return Icons.wallpaper;
    }
  }

  List<String> get supportedFormats {
    switch (this) {
      case AssetType.photo:
      case AssetType.illustration:
      case AssetType.graphic:
      case AssetType.icon:
      case AssetType.sticker:
      case AssetType.frame:
      case AssetType.background:
        return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'svg'];
      case AssetType.video:
        return ['mp4', 'mov', 'avi', 'webm'];
      case AssetType.audio:
        return ['mp3', 'wav', 'aac', 'ogg'];
      case AssetType.font:
        return ['ttf', 'otf', 'woff', 'woff2'];
      case AssetType.shape:
        return ['svg', 'png'];
    }
  }
}

@JsonSerializable()
class AssetCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final AssetType type;
  final String iconUrl;
  final int assetCount;
  final bool isPopular;
  final List<String> subcategories;

  const AssetCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.iconUrl,
    this.assetCount = 0,
    this.isPopular = false,
    required this.subcategories,
  });

  factory AssetCategory.fromJson(Map<String, dynamic> json) =>
      _$AssetCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$AssetCategoryToJson(this);

  AssetCategory copyWith({
    String? id,
    String? name,
    String? description,
    AssetType? type,
    String? iconUrl,
    int? assetCount,
    bool? isPopular,
    List<String>? subcategories,
  }) {
    return AssetCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      assetCount: assetCount ?? this.assetCount,
      isPopular: isPopular ?? this.isPopular,
      subcategories: subcategories ?? this.subcategories,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        iconUrl,
        assetCount,
        isPopular,
        subcategories,
      ];
}

@JsonSerializable()
class AssetCollection extends Equatable {
  final String id;
  final String name;
  final String description;
  final String coverImageUrl;
  final List<String> assetIds;
  final AssetType? type; // null means mixed types
  final String curatorId;
  final String? curatorName;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetCollection({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImageUrl,
    required this.assetIds,
    this.type,
    required this.curatorId,
    this.curatorName,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssetCollection.fromJson(Map<String, dynamic> json) =>
      _$AssetCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$AssetCollectionToJson(this);

  AssetCollection copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImageUrl,
    List<String>? assetIds,
    AssetType? type,
    String? curatorId,
    String? curatorName,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssetCollection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      assetIds: assetIds ?? this.assetIds,
      type: type ?? this.type,
      curatorId: curatorId ?? this.curatorId,
      curatorName: curatorName ?? this.curatorName,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        coverImageUrl,
        assetIds,
        type,
        curatorId,
        curatorName,
        isFeatured,
        createdAt,
        updatedAt,
      ];
}

// Predefined asset categories
class AssetCategories {
  static const List<AssetCategory> photoCategories = [
    AssetCategory(
      id: 'nature',
      name: 'Nature',
      description: 'Beautiful nature photography',
      type: AssetType.photo,
      iconUrl: 'assets/icons/nature.png',
      assetCount: 50000,
      isPopular: true,
      subcategories: ['Landscapes', 'Animals', 'Plants', 'Weather'],
    ),
    AssetCategory(
      id: 'business',
      name: 'Business',
      description: 'Professional business photos',
      type: AssetType.photo,
      iconUrl: 'assets/icons/business.png',
      assetCount: 30000,
      isPopular: true,
      subcategories: ['Office', 'People', 'Technology', 'Finance'],
    ),
    AssetCategory(
      id: 'lifestyle',
      name: 'Lifestyle',
      description: 'Lifestyle and people photos',
      type: AssetType.photo,
      iconUrl: 'assets/icons/lifestyle.png',
      assetCount: 40000,
      isPopular: true,
      subcategories: ['Family', 'Food', 'Travel', 'Health'],
    ),
  ];

  static const List<AssetCategory> graphicCategories = [
    AssetCategory(
      id: 'illustrations',
      name: 'Illustrations',
      description: 'Hand-drawn and digital illustrations',
      type: AssetType.illustration,
      iconUrl: 'assets/icons/illustrations.png',
      assetCount: 25000,
      isPopular: true,
      subcategories: ['Abstract', 'Characters', 'Objects', 'Patterns'],
    ),
    AssetCategory(
      id: 'icons',
      name: 'Icons',
      description: 'Vector icons for all purposes',
      type: AssetType.icon,
      iconUrl: 'assets/icons/icons.png',
      assetCount: 100000,
      isPopular: true,
      subcategories: ['UI', 'Social', 'Business', 'Technology'],
    ),
    AssetCategory(
      id: 'shapes',
      name: 'Shapes',
      description: 'Geometric shapes and elements',
      type: AssetType.shape,
      iconUrl: 'assets/icons/shapes.png',
      assetCount: 15000,
      subcategories: ['Basic', 'Decorative', 'Arrows', 'Frames'],
    ),
  ];

  static List<AssetCategory> getAllCategories() {
    return [...photoCategories, ...graphicCategories];
  }

  static List<AssetCategory> getCategoriesByType(AssetType type) {
    return getAllCategories().where((category) => category.type == type).toList();
  }

  static AssetCategory? getCategoryById(String id) {
    try {
      return getAllCategories().firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<AssetCategory> getPopularCategories() {
    return getAllCategories().where((category) => category.isPopular).toList();
  }
}