// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Design _$DesignFromJson(Map<String, dynamic> json) => Design(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      userId: json['userId'] as String,
      format: $enumDecode(_$DesignFormatEnumMap, json['format']),
      dimensions: const SizeConverter()
          .fromJson(json['dimensions'] as Map<String, dynamic>),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      elements: (json['elements'] as List<dynamic>)
          .map((e) => DesignElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings:
          DesignSettings.fromJson(json['settings'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isTemplate: json['isTemplate'] as bool? ?? false,
      isPublic: json['isPublic'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      version: (json['version'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$DesignToJson(Design instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'userId': instance.userId,
      'format': _$DesignFormatEnumMap[instance.format]!,
      'dimensions': const SizeConverter().toJson(instance.dimensions),
      'thumbnailUrl': instance.thumbnailUrl,
      'elements': instance.elements,
      'settings': instance.settings,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isTemplate': instance.isTemplate,
      'isPublic': instance.isPublic,
      'tags': instance.tags,
      'version': instance.version,
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

DesignElement _$DesignElementFromJson(Map<String, dynamic> json) =>
    DesignElement(
      id: json['id'] as String,
      type: $enumDecode(_$ElementTypeEnumMap, json['type']),
      position: const OffsetConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      size:
          const SizeConverter().fromJson(json['size'] as Map<String, dynamic>),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      isLocked: json['isLocked'] as bool? ?? false,
      isVisible: json['isVisible'] as bool? ?? true,
      zIndex: (json['zIndex'] as num?)?.toInt() ?? 0,
      properties: json['properties'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$DesignElementToJson(DesignElement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ElementTypeEnumMap[instance.type]!,
      'position': const OffsetConverter().toJson(instance.position),
      'size': const SizeConverter().toJson(instance.size),
      'rotation': instance.rotation,
      'opacity': instance.opacity,
      'isLocked': instance.isLocked,
      'isVisible': instance.isVisible,
      'zIndex': instance.zIndex,
      'properties': instance.properties,
    };

const _$ElementTypeEnumMap = {
  ElementType.text: 'text',
  ElementType.image: 'image',
  ElementType.shape: 'shape',
  ElementType.icon: 'icon',
  ElementType.video: 'video',
  ElementType.audio: 'audio',
  ElementType.line: 'line',
  ElementType.group: 'group',
};

DesignSettings _$DesignSettingsFromJson(Map<String, dynamic> json) =>
    DesignSettings(
      backgroundColor: json['backgroundColor'] == null
          ? Colors.white
          : const ColorConverter()
              .fromJson((json['backgroundColor'] as num).toInt()),
      backgroundImageUrl: json['backgroundImageUrl'] as String?,
      showGrid: json['showGrid'] as bool? ?? false,
      snapToGrid: json['snapToGrid'] as bool? ?? true,
      gridSize: (json['gridSize'] as num?)?.toDouble() ?? 10.0,
      showRulers: json['showRulers'] as bool? ?? false,
      zoom: (json['zoom'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$DesignSettingsToJson(DesignSettings instance) =>
    <String, dynamic>{
      'backgroundColor':
          const ColorConverter().toJson(instance.backgroundColor),
      'backgroundImageUrl': instance.backgroundImageUrl,
      'showGrid': instance.showGrid,
      'snapToGrid': instance.snapToGrid,
      'gridSize': instance.gridSize,
      'showRulers': instance.showRulers,
      'zoom': instance.zoom,
    };

TextElementProperties _$TextElementPropertiesFromJson(
        Map<String, dynamic> json) =>
    TextElementProperties(
      text: json['text'] as String,
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
      fontWeight: json['fontWeight'] == null
          ? FontWeight.normal
          : const FontWeightConverter()
              .fromJson((json['fontWeight'] as num).toInt()),
      fontStyle: json['fontStyle'] == null
          ? FontStyle.normal
          : const FontStyleConverter().fromJson(json['fontStyle'] as String),
      color: json['color'] == null
          ? Colors.black
          : const ColorConverter().fromJson((json['color'] as num).toInt()),
      textAlign: json['textAlign'] == null
          ? TextAlign.left
          : const TextAlignConverter().fromJson(json['textAlign'] as String),
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble() ?? 0.0,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.2,
      hasStroke: json['hasStroke'] as bool? ?? false,
      strokeColor: _$JsonConverterFromJson<int, Color>(
          json['strokeColor'], const ColorConverter().fromJson),
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 1.0,
      hasShadow: json['hasShadow'] as bool? ?? false,
      shadowColor: _$JsonConverterFromJson<int, Color>(
          json['shadowColor'], const ColorConverter().fromJson),
      shadowOffset: json['shadowOffset'] == null
          ? Offset.zero
          : const OffsetConverter()
              .fromJson(json['shadowOffset'] as Map<String, dynamic>),
      shadowBlur: (json['shadowBlur'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$TextElementPropertiesToJson(
        TextElementProperties instance) =>
    <String, dynamic>{
      'text': instance.text,
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
      'fontWeight': const FontWeightConverter().toJson(instance.fontWeight),
      'fontStyle': const FontStyleConverter().toJson(instance.fontStyle),
      'color': const ColorConverter().toJson(instance.color),
      'textAlign': const TextAlignConverter().toJson(instance.textAlign),
      'letterSpacing': instance.letterSpacing,
      'lineHeight': instance.lineHeight,
      'hasStroke': instance.hasStroke,
      'strokeColor': _$JsonConverterToJson<int, Color>(
          instance.strokeColor, const ColorConverter().toJson),
      'strokeWidth': instance.strokeWidth,
      'hasShadow': instance.hasShadow,
      'shadowColor': _$JsonConverterToJson<int, Color>(
          instance.shadowColor, const ColorConverter().toJson),
      'shadowOffset': const OffsetConverter().toJson(instance.shadowOffset),
      'shadowBlur': instance.shadowBlur,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

ImageElementProperties _$ImageElementPropertiesFromJson(
        Map<String, dynamic> json) =>
    ImageElementProperties(
      imageUrl: json['imageUrl'] as String,
      altText: json['altText'] as String?,
      fit: json['fit'] == null
          ? BoxFit.cover
          : const BoxFitConverter().fromJson(json['fit'] as String),
      hasFilter: json['hasFilter'] as bool? ?? false,
      brightness: (json['brightness'] as num?)?.toDouble() ?? 0.0,
      contrast: (json['contrast'] as num?)?.toDouble() ?? 0.0,
      saturation: (json['saturation'] as num?)?.toDouble() ?? 0.0,
      blur: (json['blur'] as num?)?.toDouble() ?? 0.0,
      hasRoundedCorners: json['hasRoundedCorners'] as bool? ?? false,
      cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ImageElementPropertiesToJson(
        ImageElementProperties instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'altText': instance.altText,
      'fit': const BoxFitConverter().toJson(instance.fit),
      'hasFilter': instance.hasFilter,
      'brightness': instance.brightness,
      'contrast': instance.contrast,
      'saturation': instance.saturation,
      'blur': instance.blur,
      'hasRoundedCorners': instance.hasRoundedCorners,
      'cornerRadius': instance.cornerRadius,
    };

ShapeElementProperties _$ShapeElementPropertiesFromJson(
        Map<String, dynamic> json) =>
    ShapeElementProperties(
      shapeType: $enumDecode(_$ShapeTypeEnumMap, json['shapeType']),
      fillColor: json['fillColor'] == null
          ? Colors.blue
          : const ColorConverter().fromJson((json['fillColor'] as num).toInt()),
      hasStroke: json['hasStroke'] as bool? ?? false,
      strokeColor: _$JsonConverterFromJson<int, Color>(
          json['strokeColor'], const ColorConverter().fromJson),
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 1.0,
      hasGradient: json['hasGradient'] as bool? ?? false,
      gradientColors: const ColorListConverter()
          .fromJson(json['gradientColors'] as List<int>?),
      gradientBegin: json['gradientBegin'] == null
          ? Alignment.topLeft
          : const AlignmentConverter()
              .fromJson(json['gradientBegin'] as Map<String, dynamic>),
      gradientEnd: json['gradientEnd'] == null
          ? Alignment.bottomRight
          : const AlignmentConverter()
              .fromJson(json['gradientEnd'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShapeElementPropertiesToJson(
        ShapeElementProperties instance) =>
    <String, dynamic>{
      'shapeType': _$ShapeTypeEnumMap[instance.shapeType]!,
      'fillColor': const ColorConverter().toJson(instance.fillColor),
      'hasStroke': instance.hasStroke,
      'strokeColor': _$JsonConverterToJson<int, Color>(
          instance.strokeColor, const ColorConverter().toJson),
      'strokeWidth': instance.strokeWidth,
      'hasGradient': instance.hasGradient,
      'gradientColors':
          const ColorListConverter().toJson(instance.gradientColors),
      'gradientBegin':
          const AlignmentConverter().toJson(instance.gradientBegin),
      'gradientEnd': const AlignmentConverter().toJson(instance.gradientEnd),
    };

const _$ShapeTypeEnumMap = {
  ShapeType.rectangle: 'rectangle',
  ShapeType.circle: 'circle',
  ShapeType.triangle: 'triangle',
  ShapeType.star: 'star',
  ShapeType.heart: 'heart',
  ShapeType.arrow: 'arrow',
};
