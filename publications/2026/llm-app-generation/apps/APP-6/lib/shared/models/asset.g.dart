// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) => Asset(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: $enumDecode(_$AssetTypeEnumMap, json['type']),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      category: json['category'] as String,
      isPremium: json['isPremium'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      downloadCount: (json['downloadCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String?,
      metadata:
          AssetMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'tags': instance.tags,
      'category': instance.category,
      'isPremium': instance.isPremium,
      'isFeatured': instance.isFeatured,
      'downloadCount': instance.downloadCount,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$AssetTypeEnumMap = {
  AssetType.photo: 'photo',
  AssetType.illustration: 'illustration',
  AssetType.graphic: 'graphic',
  AssetType.icon: 'icon',
  AssetType.video: 'video',
  AssetType.audio: 'audio',
  AssetType.font: 'font',
  AssetType.shape: 'shape',
  AssetType.sticker: 'sticker',
  AssetType.frame: 'frame',
  AssetType.background: 'background',
};

AssetMetadata _$AssetMetadataFromJson(Map<String, dynamic> json) =>
    AssetMetadata(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt(),
      fileFormat: json['fileFormat'] as String?,
      durationMs: (json['durationMs'] as num?)?.toInt(),
      dominantColors: const ColorListConverter()
          .fromJson(json['dominantColors'] as List<int>?),
      hasTransparency: json['hasTransparency'] as bool?,
      license: json['license'] as String?,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AssetMetadataToJson(AssetMetadata instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'fileSizeBytes': instance.fileSizeBytes,
      'fileFormat': instance.fileFormat,
      'durationMs': instance.durationMs,
      'dominantColors':
          const ColorListConverter().toJson(instance.dominantColors),
      'hasTransparency': instance.hasTransparency,
      'license': instance.license,
      'additionalData': instance.additionalData,
    };

AssetCategory _$AssetCategoryFromJson(Map<String, dynamic> json) =>
    AssetCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$AssetTypeEnumMap, json['type']),
      iconUrl: json['iconUrl'] as String,
      assetCount: (json['assetCount'] as num?)?.toInt() ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AssetCategoryToJson(AssetCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'iconUrl': instance.iconUrl,
      'assetCount': instance.assetCount,
      'isPopular': instance.isPopular,
      'subcategories': instance.subcategories,
    };

AssetCollection _$AssetCollectionFromJson(Map<String, dynamic> json) =>
    AssetCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      assetIds:
          (json['assetIds'] as List<dynamic>).map((e) => e as String).toList(),
      type: $enumDecodeNullable(_$AssetTypeEnumMap, json['type']),
      curatorId: json['curatorId'] as String,
      curatorName: json['curatorName'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AssetCollectionToJson(AssetCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'coverImageUrl': instance.coverImageUrl,
      'assetIds': instance.assetIds,
      'type': _$AssetTypeEnumMap[instance.type],
      'curatorId': instance.curatorId,
      'curatorName': instance.curatorName,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
