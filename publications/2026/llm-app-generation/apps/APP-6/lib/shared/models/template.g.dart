// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Template _$TemplateFromJson(Map<String, dynamic> json) => Template(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      thumbnailUrl: json['thumbnailUrl'] as String,
      previewUrl: json['previewUrl'] as String?,
      format: $enumDecode(_$DesignFormatEnumMap, json['format']),
      isPremium: json['isPremium'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      designData: Design.fromJson(json['designData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TemplateToJson(Template instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'tags': instance.tags,
      'thumbnailUrl': instance.thumbnailUrl,
      'previewUrl': instance.previewUrl,
      'format': _$DesignFormatEnumMap[instance.format]!,
      'isPremium': instance.isPremium,
      'isFeatured': instance.isFeatured,
      'usageCount': instance.usageCount,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'designData': instance.designData,
    };

const _$DesignFormatEnumMap = {
  DesignFormat.instagramPost: 'instagram_post',
  DesignFormat.instagramStory: 'instagram_story',
  DesignFormat.facebookPost: 'facebook_post',
  DesignFormat.twitterPost: 'twitter_post',
  DesignFormat.linkedinPost: 'linkedin_post',
  DesignFormat.youtubeThumbnail: 'youtube_thumbnail',
  DesignFormat.presentation: 'presentation',
  DesignFormat.a4Document: 'a4_document',
  DesignFormat.businessCard: 'business_card',
  DesignFormat.flyer: 'flyer',
  DesignFormat.logo: 'logo',
  DesignFormat.banner: 'banner',
  DesignFormat.custom: 'custom',
};

TemplateCategory _$TemplateCategoryFromJson(Map<String, dynamic> json) =>
    TemplateCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['iconUrl'] as String,
      templateCount: (json['templateCount'] as num?)?.toInt() ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      subcategories: (json['subcategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TemplateCategoryToJson(TemplateCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'templateCount': instance.templateCount,
      'isPopular': instance.isPopular,
      'subcategories': instance.subcategories,
    };

TemplateCollection _$TemplateCollectionFromJson(Map<String, dynamic> json) =>
    TemplateCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      templateIds: (json['templateIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      curatorId: json['curatorId'] as String,
      curatorName: json['curatorName'] as String?,
      isFeatured: json['isFeatured'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TemplateCollectionToJson(TemplateCollection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'coverImageUrl': instance.coverImageUrl,
      'templateIds': instance.templateIds,
      'curatorId': instance.curatorId,
      'curatorName': instance.curatorName,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
