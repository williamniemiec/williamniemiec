import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'json_converters.dart';

part 'design.g.dart';

@JsonSerializable()
class Design extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String userId;
  final DesignFormat format;
  @SizeConverter()
  final Size dimensions;
  final String? thumbnailUrl;
  final List<DesignElement> elements;
  final DesignSettings settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isTemplate;
  final bool isPublic;
  final List<String> tags;
  final int version;

  const Design({
    required this.id,
    required this.name,
    this.description,
    required this.userId,
    required this.format,
    required this.dimensions,
    this.thumbnailUrl,
    required this.elements,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
    this.isTemplate = false,
    this.isPublic = false,
    required this.tags,
    this.version = 1,
  });

  factory Design.fromJson(Map<String, dynamic> json) => _$DesignFromJson(json);
  Map<String, dynamic> toJson() => _$DesignToJson(this);

  Design copyWith({
    String? id,
    String? name,
    String? description,
    String? userId,
    DesignFormat? format,
    Size? dimensions,
    String? thumbnailUrl,
    List<DesignElement>? elements,
    DesignSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isTemplate,
    bool? isPublic,
    List<String>? tags,
    int? version,
  }) {
    return Design(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      format: format ?? this.format,
      dimensions: dimensions ?? this.dimensions,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      elements: elements ?? this.elements,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isTemplate: isTemplate ?? this.isTemplate,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userId,
        format,
        dimensions,
        thumbnailUrl,
        elements,
        settings,
        createdAt,
        updatedAt,
        isTemplate,
        isPublic,
        tags,
        version,
      ];
}

@JsonSerializable()
class DesignElement extends Equatable {
  final String id;
  final ElementType type;
  @OffsetConverter()
  final Offset position;
  @SizeConverter()
  final Size size;
  final double rotation;
  final double opacity;
  final bool isLocked;
  final bool isVisible;
  final int zIndex;
  final Map<String, dynamic> properties;

  const DesignElement({
    required this.id,
    required this.type,
    required this.position,
    required this.size,
    this.rotation = 0.0,
    this.opacity = 1.0,
    this.isLocked = false,
    this.isVisible = true,
    this.zIndex = 0,
    required this.properties,
  });

  factory DesignElement.fromJson(Map<String, dynamic> json) =>
      _$DesignElementFromJson(json);
  Map<String, dynamic> toJson() => _$DesignElementToJson(this);

  DesignElement copyWith({
    String? id,
    ElementType? type,
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    bool? isLocked,
    bool? isVisible,
    int? zIndex,
    Map<String, dynamic>? properties,
  }) {
    return DesignElement(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      isLocked: isLocked ?? this.isLocked,
      isVisible: isVisible ?? this.isVisible,
      zIndex: zIndex ?? this.zIndex,
      properties: properties ?? this.properties,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        position,
        size,
        rotation,
        opacity,
        isLocked,
        isVisible,
        zIndex,
        properties,
      ];
}

@JsonSerializable()
class DesignSettings extends Equatable {
  @ColorConverter()
  final Color backgroundColor;
  final String? backgroundImageUrl;
  final bool showGrid;
  final bool snapToGrid;
  final double gridSize;
  final bool showRulers;
  final double zoom;

  const DesignSettings({
    this.backgroundColor = Colors.white,
    this.backgroundImageUrl,
    this.showGrid = false,
    this.snapToGrid = true,
    this.gridSize = 10.0,
    this.showRulers = false,
    this.zoom = 1.0,
  });

  factory DesignSettings.fromJson(Map<String, dynamic> json) =>
      _$DesignSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$DesignSettingsToJson(this);

  DesignSettings copyWith({
    Color? backgroundColor,
    String? backgroundImageUrl,
    bool? showGrid,
    bool? snapToGrid,
    double? gridSize,
    bool? showRulers,
    double? zoom,
  }) {
    return DesignSettings(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      showGrid: showGrid ?? this.showGrid,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      gridSize: gridSize ?? this.gridSize,
      showRulers: showRulers ?? this.showRulers,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        backgroundImageUrl,
        showGrid,
        snapToGrid,
        gridSize,
        showRulers,
        zoom,
      ];
}

enum DesignFormat {
  @JsonValue('instagram_post')
  instagramPost,
  @JsonValue('instagram_story')
  instagramStory,
  @JsonValue('facebook_post')
  facebookPost,
  @JsonValue('twitter_post')
  twitterPost,
  @JsonValue('linkedin_post')
  linkedinPost,
  @JsonValue('youtube_thumbnail')
  youtubeThumbnail,
  @JsonValue('presentation')
  presentation,
  @JsonValue('a4_document')
  a4Document,
  @JsonValue('business_card')
  businessCard,
  @JsonValue('flyer')
  flyer,
  @JsonValue('logo')
  logo,
  @JsonValue('banner')
  banner,
  @JsonValue('custom')
  custom,
}

extension DesignFormatExtension on DesignFormat {
  String get displayName {
    switch (this) {
      case DesignFormat.instagramPost:
        return 'Instagram Post';
      case DesignFormat.instagramStory:
        return 'Instagram Story';
      case DesignFormat.facebookPost:
        return 'Facebook Post';
      case DesignFormat.twitterPost:
        return 'Twitter Post';
      case DesignFormat.linkedinPost:
        return 'LinkedIn Post';
      case DesignFormat.youtubeThumbnail:
        return 'YouTube Thumbnail';
      case DesignFormat.presentation:
        return 'Presentation';
      case DesignFormat.a4Document:
        return 'A4 Document';
      case DesignFormat.businessCard:
        return 'Business Card';
      case DesignFormat.flyer:
        return 'Flyer';
      case DesignFormat.logo:
        return 'Logo';
      case DesignFormat.banner:
        return 'Banner';
      case DesignFormat.custom:
        return 'Custom';
    }
  }

  Size get defaultSize {
    switch (this) {
      case DesignFormat.instagramPost:
        return const Size(1080, 1080);
      case DesignFormat.instagramStory:
        return const Size(1080, 1920);
      case DesignFormat.facebookPost:
        return const Size(1200, 630);
      case DesignFormat.twitterPost:
        return const Size(1024, 512);
      case DesignFormat.linkedinPost:
        return const Size(1200, 627);
      case DesignFormat.youtubeThumbnail:
        return const Size(1280, 720);
      case DesignFormat.presentation:
        return const Size(1920, 1080);
      case DesignFormat.a4Document:
        return const Size(2480, 3508);
      case DesignFormat.businessCard:
        return const Size(1050, 600);
      case DesignFormat.flyer:
        return const Size(2480, 3508);
      case DesignFormat.logo:
        return const Size(500, 500);
      case DesignFormat.banner:
        return const Size(1500, 500);
      case DesignFormat.custom:
        return const Size(1080, 1080);
    }
  }

  String get category {
    switch (this) {
      case DesignFormat.instagramPost:
      case DesignFormat.instagramStory:
      case DesignFormat.facebookPost:
      case DesignFormat.twitterPost:
      case DesignFormat.linkedinPost:
      case DesignFormat.youtubeThumbnail:
        return 'Social Media';
      case DesignFormat.presentation:
        return 'Presentations';
      case DesignFormat.a4Document:
        return 'Documents';
      case DesignFormat.businessCard:
      case DesignFormat.flyer:
      case DesignFormat.banner:
        return 'Marketing';
      case DesignFormat.logo:
        return 'Branding';
      case DesignFormat.custom:
        return 'Custom';
    }
  }
}

enum ElementType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('shape')
  shape,
  @JsonValue('icon')
  icon,
  @JsonValue('video')
  video,
  @JsonValue('audio')
  audio,
  @JsonValue('line')
  line,
  @JsonValue('group')
  group,
}

extension ElementTypeExtension on ElementType {
  String get displayName {
    switch (this) {
      case ElementType.text:
        return 'Text';
      case ElementType.image:
        return 'Image';
      case ElementType.shape:
        return 'Shape';
      case ElementType.icon:
        return 'Icon';
      case ElementType.video:
        return 'Video';
      case ElementType.audio:
        return 'Audio';
      case ElementType.line:
        return 'Line';
      case ElementType.group:
        return 'Group';
    }
  }

  IconData get icon {
    switch (this) {
      case ElementType.text:
        return Icons.text_fields;
      case ElementType.image:
        return Icons.image;
      case ElementType.shape:
        return Icons.category;
      case ElementType.icon:
        return Icons.star;
      case ElementType.video:
        return Icons.videocam;
      case ElementType.audio:
        return Icons.audiotrack;
      case ElementType.line:
        return Icons.horizontal_rule;
      case ElementType.group:
        return Icons.group_work;
    }
  }
}

// Text Element Properties
@JsonSerializable()
class TextElementProperties extends Equatable {
  final String text;
  final String fontFamily;
  final double fontSize;
  @FontWeightConverter()
  final FontWeight fontWeight;
  @FontStyleConverter()
  final FontStyle fontStyle;
  @ColorConverter()
  final Color color;
  @TextAlignConverter()
  final TextAlign textAlign;
  final double letterSpacing;
  final double lineHeight;
  final bool hasStroke;
  @ColorConverter()
  final Color? strokeColor;
  final double strokeWidth;
  final bool hasShadow;
  @ColorConverter()
  final Color? shadowColor;
  @OffsetConverter()
  final Offset shadowOffset;
  final double shadowBlur;

  const TextElementProperties({
    required this.text,
    this.fontFamily = 'Inter',
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.left,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.2,
    this.hasStroke = false,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.hasShadow = false,
    this.shadowColor,
    this.shadowOffset = Offset.zero,
    this.shadowBlur = 0.0,
  });

  factory TextElementProperties.fromJson(Map<String, dynamic> json) =>
      _$TextElementPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$TextElementPropertiesToJson(this);

  @override
  List<Object?> get props => [
        text,
        fontFamily,
        fontSize,
        fontWeight,
        fontStyle,
        color,
        textAlign,
        letterSpacing,
        lineHeight,
        hasStroke,
        strokeColor,
        strokeWidth,
        hasShadow,
        shadowColor,
        shadowOffset,
        shadowBlur,
      ];
}

// Image Element Properties
@JsonSerializable()
class ImageElementProperties extends Equatable {
  final String imageUrl;
  final String? altText;
  @BoxFitConverter()
  final BoxFit fit;
  final bool hasFilter;
  final double brightness;
  final double contrast;
  final double saturation;
  final double blur;
  final bool hasRoundedCorners;
  final double cornerRadius;

  const ImageElementProperties({
    required this.imageUrl,
    this.altText,
    this.fit = BoxFit.cover,
    this.hasFilter = false,
    this.brightness = 0.0,
    this.contrast = 0.0,
    this.saturation = 0.0,
    this.blur = 0.0,
    this.hasRoundedCorners = false,
    this.cornerRadius = 0.0,
  });

  factory ImageElementProperties.fromJson(Map<String, dynamic> json) =>
      _$ImageElementPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$ImageElementPropertiesToJson(this);

  @override
  List<Object?> get props => [
        imageUrl,
        altText,
        fit,
        hasFilter,
        brightness,
        contrast,
        saturation,
        blur,
        hasRoundedCorners,
        cornerRadius,
      ];
}

// Shape Element Properties
@JsonSerializable()
class ShapeElementProperties extends Equatable {
  final ShapeType shapeType;
  @ColorConverter()
  final Color fillColor;
  final bool hasStroke;
  @ColorConverter()
  final Color? strokeColor;
  final double strokeWidth;
  final bool hasGradient;
  @ColorListConverter()
  final List<Color>? gradientColors;
  @AlignmentConverter()
  final Alignment gradientBegin;
  @AlignmentConverter()
  final Alignment gradientEnd;

  const ShapeElementProperties({
    required this.shapeType,
    this.fillColor = Colors.blue,
    this.hasStroke = false,
    this.strokeColor,
    this.strokeWidth = 1.0,
    this.hasGradient = false,
    this.gradientColors,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
  });

  factory ShapeElementProperties.fromJson(Map<String, dynamic> json) =>
      _$ShapeElementPropertiesFromJson(json);
  Map<String, dynamic> toJson() => _$ShapeElementPropertiesToJson(this);

  @override
  List<Object?> get props => [
        shapeType,
        fillColor,
        hasStroke,
        strokeColor,
        strokeWidth,
        hasGradient,
        gradientColors,
        gradientBegin,
        gradientEnd,
      ];
}

enum ShapeType {
  @JsonValue('rectangle')
  rectangle,
  @JsonValue('circle')
  circle,
  @JsonValue('triangle')
  triangle,
  @JsonValue('star')
  star,
  @JsonValue('heart')
  heart,
  @JsonValue('arrow')
  arrow,
}