import 'package:json_annotation/json_annotation.dart';

part 'coloring_page.g.dart';

@JsonSerializable()
class ColoringPage {
  final String id;
  final String title;
  final String category;
  final String imagePath;
  final String thumbnailPath;
  final List<ColorRegion> regions;
  final List<ColorPalette> palette;
  final int difficulty;
  final bool isPremium;
  final DateTime createdAt;

  const ColoringPage({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.thumbnailPath,
    required this.regions,
    required this.palette,
    required this.difficulty,
    this.isPremium = false,
    required this.createdAt,
  });

  factory ColoringPage.fromJson(Map<String, dynamic> json) =>
      _$ColoringPageFromJson(json);

  Map<String, dynamic> toJson() => _$ColoringPageToJson(this);

  ColoringPage copyWith({
    String? id,
    String? title,
    String? category,
    String? imagePath,
    String? thumbnailPath,
    List<ColorRegion>? regions,
    List<ColorPalette>? palette,
    int? difficulty,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return ColoringPage(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      regions: regions ?? this.regions,
      palette: palette ?? this.palette,
      difficulty: difficulty ?? this.difficulty,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class ColorRegion {
  final int number;
  final List<List<int>> coordinates; // List of polygon points
  final String colorCode;

  const ColorRegion({
    required this.number,
    required this.coordinates,
    required this.colorCode,
  });

  factory ColorRegion.fromJson(Map<String, dynamic> json) =>
      _$ColorRegionFromJson(json);

  Map<String, dynamic> toJson() => _$ColorRegionToJson(this);
}

@JsonSerializable()
class ColorPalette {
  final int number;
  final String colorCode;
  final String colorName;

  const ColorPalette({
    required this.number,
    required this.colorCode,
    required this.colorName,
  });

  factory ColorPalette.fromJson(Map<String, dynamic> json) =>
      _$ColorPaletteFromJson(json);

  Map<String, dynamic> toJson() => _$ColorPaletteToJson(this);
}