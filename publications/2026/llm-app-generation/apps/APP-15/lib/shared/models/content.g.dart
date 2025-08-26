// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContentAdapter extends TypeAdapter<Content> {
  @override
  final int typeId = 2;

  @override
  Content read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Content(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as ContentType,
      thumbnailUrl: fields[4] as String?,
      videoUrl: fields[5] as String?,
      audioUrl: fields[6] as String?,
      durationMinutes: fields[7] as int,
      category: fields[8] as ContentCategory,
      difficulty: fields[9] as DifficultyLevel,
      partner: fields[10] as String,
      tags: (fields[11] as List).cast<String>(),
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      isFeatured: fields[14] as bool,
      isPremium: fields[15] as bool,
      rating: fields[16] as double,
      viewCount: fields[17] as int,
      instructorName: fields[18] as String?,
      equipment: fields[19] as String?,
      targetMuscles: (fields[20] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Content obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.thumbnailUrl)
      ..writeByte(5)
      ..write(obj.videoUrl)
      ..writeByte(6)
      ..write(obj.audioUrl)
      ..writeByte(7)
      ..write(obj.durationMinutes)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.difficulty)
      ..writeByte(10)
      ..write(obj.partner)
      ..writeByte(11)
      ..write(obj.tags)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.isFeatured)
      ..writeByte(15)
      ..write(obj.isPremium)
      ..writeByte(16)
      ..write(obj.rating)
      ..writeByte(17)
      ..write(obj.viewCount)
      ..writeByte(18)
      ..write(obj.instructorName)
      ..writeByte(19)
      ..write(obj.equipment)
      ..writeByte(20)
      ..write(obj.targetMuscles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentTypeAdapter extends TypeAdapter<ContentType> {
  @override
  final int typeId = 3;

  @override
  ContentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContentType.video;
      case 1:
        return ContentType.audio;
      case 2:
        return ContentType.article;
      case 3:
        return ContentType.recipe;
      default:
        return ContentType.video;
    }
  }

  @override
  void write(BinaryWriter writer, ContentType obj) {
    switch (obj) {
      case ContentType.video:
        writer.writeByte(0);
        break;
      case ContentType.audio:
        writer.writeByte(1);
        break;
      case ContentType.article:
        writer.writeByte(2);
        break;
      case ContentType.recipe:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentCategoryAdapter extends TypeAdapter<ContentCategory> {
  @override
  final int typeId = 4;

  @override
  ContentCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ContentCategory.cardio;
      case 1:
        return ContentCategory.strength;
      case 2:
        return ContentCategory.yoga;
      case 3:
        return ContentCategory.meditation;
      case 4:
        return ContentCategory.nutrition;
      case 5:
        return ContentCategory.wellness;
      case 6:
        return ContentCategory.hiit;
      case 7:
        return ContentCategory.stretching;
      default:
        return ContentCategory.cardio;
    }
  }

  @override
  void write(BinaryWriter writer, ContentCategory obj) {
    switch (obj) {
      case ContentCategory.cardio:
        writer.writeByte(0);
        break;
      case ContentCategory.strength:
        writer.writeByte(1);
        break;
      case ContentCategory.yoga:
        writer.writeByte(2);
        break;
      case ContentCategory.meditation:
        writer.writeByte(3);
        break;
      case ContentCategory.nutrition:
        writer.writeByte(4);
        break;
      case ContentCategory.wellness:
        writer.writeByte(5);
        break;
      case ContentCategory.hiit:
        writer.writeByte(6);
        break;
      case ContentCategory.stretching:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyLevelAdapter extends TypeAdapter<DifficultyLevel> {
  @override
  final int typeId = 5;

  @override
  DifficultyLevel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DifficultyLevel.beginner;
      case 1:
        return DifficultyLevel.intermediate;
      case 2:
        return DifficultyLevel.advanced;
      default:
        return DifficultyLevel.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, DifficultyLevel obj) {
    switch (obj) {
      case DifficultyLevel.beginner:
        writer.writeByte(0);
        break;
      case DifficultyLevel.intermediate:
        writer.writeByte(1);
        break;
      case DifficultyLevel.advanced:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
