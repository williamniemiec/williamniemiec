// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coloring_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ColoringPage _$ColoringPageFromJson(Map<String, dynamic> json) => ColoringPage(
  id: json['id'] as String,
  title: json['title'] as String,
  category: json['category'] as String,
  imagePath: json['imagePath'] as String,
  thumbnailPath: json['thumbnailPath'] as String,
  regions: (json['regions'] as List<dynamic>)
      .map((e) => ColorRegion.fromJson(e as Map<String, dynamic>))
      .toList(),
  palette: (json['palette'] as List<dynamic>)
      .map((e) => ColorPalette.fromJson(e as Map<String, dynamic>))
      .toList(),
  difficulty: (json['difficulty'] as num).toInt(),
  isPremium: json['isPremium'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ColoringPageToJson(ColoringPage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'imagePath': instance.imagePath,
      'thumbnailPath': instance.thumbnailPath,
      'regions': instance.regions,
      'palette': instance.palette,
      'difficulty': instance.difficulty,
      'isPremium': instance.isPremium,
      'createdAt': instance.createdAt.toIso8601String(),
    };

ColorRegion _$ColorRegionFromJson(Map<String, dynamic> json) => ColorRegion(
  number: (json['number'] as num).toInt(),
  coordinates: (json['coordinates'] as List<dynamic>)
      .map((e) => (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
      .toList(),
  colorCode: json['colorCode'] as String,
);

Map<String, dynamic> _$ColorRegionToJson(ColorRegion instance) =>
    <String, dynamic>{
      'number': instance.number,
      'coordinates': instance.coordinates,
      'colorCode': instance.colorCode,
    };

ColorPalette _$ColorPaletteFromJson(Map<String, dynamic> json) => ColorPalette(
  number: (json['number'] as num).toInt(),
  colorCode: json['colorCode'] as String,
  colorName: json['colorName'] as String,
);

Map<String, dynamic> _$ColorPaletteToJson(ColorPalette instance) =>
    <String, dynamic>{
      'number': instance.number,
      'colorCode': instance.colorCode,
      'colorName': instance.colorName,
    };
