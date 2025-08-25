import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'design.dart';

part 'template.g.dart';

@JsonSerializable()
class Template extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> tags;
  final String thumbnailUrl;
  final String? previewUrl;
  final DesignFormat format;
  final bool isPremium;
  final bool isFeatured;
  final int usageCount;
  final double rating;
  final int reviewCount;
  final String authorId;
  final String? authorName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Design designData;

  const Template({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.tags,
    required this.thumbnailUrl,
    this.previewUrl,
    required this.format,
    this.isPremium = false,
    this.isFeatured = false,
    this.usageCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.authorId,
    this.authorName,
    required this.createdAt,
    required this.updatedAt,
    required this.designData,
  });

  factory Template.fromJson(Map<String, dynamic> json) => _$TemplateFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateToJson(this);

  Template copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    List<String>? tags,
    String? thumbnailUrl,
    String? previewUrl,
    DesignFormat? format,
    bool? isPremium,
    bool? isFeatured,
    int? usageCount,
    double? rating,
    int? reviewCount,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    Design? designData,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      format: format ?? this.format,
      isPremium: isPremium ?? this.isPremium,
      isFeatured: isFeatured ?? this.isFeatured,
      usageCount: usageCount ?? this.usageCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      designData: designData ?? this.designData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        tags,
        thumbnailUrl,
        previewUrl,
        format,
        isPremium,
        isFeatured,
        usageCount,
        rating,
        reviewCount,
        authorId,
        authorName,
        createdAt,
        updatedAt,
        designData,
      ];
}

@JsonSerializable()
class TemplateCategory extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int templateCount;
  final bool isPopular;
  final List<String> subcategories;

  const TemplateCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    this.templateCount = 0,
    this.isPopular = false,
    required this.subcategories,
  });

  factory TemplateCategory.fromJson(Map<String, dynamic> json) =>
      _$TemplateCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateCategoryToJson(this);

  TemplateCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? iconUrl,
    int? templateCount,
    bool? isPopular,
    List<String>? subcategories,
  }) {
    return TemplateCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      templateCount: templateCount ?? this.templateCount,
      isPopular: isPopular ?? this.isPopular,
      subcategories: subcategories ?? this.subcategories,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconUrl,
        templateCount,
        isPopular,
        subcategories,
      ];
}

@JsonSerializable()
class TemplateCollection extends Equatable {
  final String id;
  final String name;
  final String description;
  final String coverImageUrl;
  final List<String> templateIds;
  final String curatorId;
  final String? curatorName;
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TemplateCollection({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImageUrl,
    required this.templateIds,
    required this.curatorId,
    this.curatorName,
    this.isFeatured = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TemplateCollection.fromJson(Map<String, dynamic> json) =>
      _$TemplateCollectionFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateCollectionToJson(this);

  TemplateCollection copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImageUrl,
    List<String>? templateIds,
    String? curatorId,
    String? curatorName,
    bool? isFeatured,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TemplateCollection(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      templateIds: templateIds ?? this.templateIds,
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
        templateIds,
        curatorId,
        curatorName,
        isFeatured,
        createdAt,
        updatedAt,
      ];
}

// Predefined template categories
class TemplateCategories {
  static const List<TemplateCategory> categories = [
    TemplateCategory(
      id: 'social_media',
      name: 'Social Media',
      description: 'Templates for social media posts and stories',
      iconUrl: 'assets/icons/social_media.png',
      templateCount: 15000,
      isPopular: true,
      subcategories: [
        'Instagram Post',
        'Instagram Story',
        'Facebook Post',
        'Twitter Post',
        'LinkedIn Post',
        'YouTube Thumbnail',
      ],
    ),
    TemplateCategory(
      id: 'presentations',
      name: 'Presentations',
      description: 'Professional presentation templates',
      iconUrl: 'assets/icons/presentations.png',
      templateCount: 8000,
      isPopular: true,
      subcategories: [
        'Business Presentation',
        'Educational Presentation',
        'Pitch Deck',
        'Report',
      ],
    ),
    TemplateCategory(
      id: 'marketing',
      name: 'Marketing',
      description: 'Marketing and promotional materials',
      iconUrl: 'assets/icons/marketing.png',
      templateCount: 12000,
      isPopular: true,
      subcategories: [
        'Flyer',
        'Poster',
        'Banner',
        'Brochure',
        'Business Card',
        'Advertisement',
      ],
    ),
    TemplateCategory(
      id: 'documents',
      name: 'Documents',
      description: 'Document templates for various purposes',
      iconUrl: 'assets/icons/documents.png',
      templateCount: 5000,
      subcategories: [
        'Resume',
        'Letter',
        'Invoice',
        'Certificate',
        'Newsletter',
      ],
    ),
    TemplateCategory(
      id: 'personal',
      name: 'Personal',
      description: 'Templates for personal use',
      iconUrl: 'assets/icons/personal.png',
      templateCount: 7000,
      subcategories: [
        'Invitation',
        'Greeting Card',
        'Photo Collage',
        'Calendar',
        'Planner',
      ],
    ),
    TemplateCategory(
      id: 'education',
      name: 'Education',
      description: 'Educational materials and resources',
      iconUrl: 'assets/icons/education.png',
      templateCount: 4000,
      subcategories: [
        'Worksheet',
        'Lesson Plan',
        'Infographic',
        'Mind Map',
        'Timeline',
      ],
    ),
    TemplateCategory(
      id: 'events',
      name: 'Events',
      description: 'Event-related templates',
      iconUrl: 'assets/icons/events.png',
      templateCount: 3000,
      subcategories: [
        'Event Invitation',
        'Event Poster',
        'Program',
        'Ticket',
        'Menu',
      ],
    ),
    TemplateCategory(
      id: 'branding',
      name: 'Branding',
      description: 'Brand identity and logo templates',
      iconUrl: 'assets/icons/branding.png',
      templateCount: 2000,
      subcategories: [
        'Logo',
        'Brand Kit',
        'Letterhead',
        'Brand Guidelines',
      ],
    ),
  ];

  static TemplateCategory? getCategoryById(String id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<TemplateCategory> getPopularCategories() {
    return categories.where((category) => category.isPopular).toList();
  }

  static List<String> getAllSubcategories() {
    return categories
        .expand((category) => category.subcategories)
        .toSet()
        .toList();
  }
}