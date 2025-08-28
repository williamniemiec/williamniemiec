// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrendAdapter extends TypeAdapter<Trend> {
  @override
  final int typeId = 13;

  @override
  Trend read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trend(
      id: fields[0] as String,
      name: fields[1] as String,
      query: fields[2] as String,
      postsCount: fields[3] as int,
      type: fields[4] as TrendType,
      description: fields[5] as String?,
      location: fields[6] as String?,
      updatedAt: fields[7] as DateTime,
      rank: fields[8] as int,
      score: fields[9] as double,
      metadata: (fields[10] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Trend obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.query)
      ..writeByte(3)
      ..write(obj.postsCount)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.location)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.rank)
      ..writeByte(9)
      ..write(obj.score)
      ..writeByte(10)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TrendTypeAdapter extends TypeAdapter<TrendType> {
  @override
  final int typeId = 14;

  @override
  TrendType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TrendType.hashtag;
      case 1:
        return TrendType.topic;
      case 2:
        return TrendType.event;
      case 3:
        return TrendType.person;
      case 4:
        return TrendType.location;
      case 5:
        return TrendType.news;
      case 6:
        return TrendType.sports;
      case 7:
        return TrendType.entertainment;
      case 8:
        return TrendType.technology;
      case 9:
        return TrendType.politics;
      default:
        return TrendType.hashtag;
    }
  }

  @override
  void write(BinaryWriter writer, TrendType obj) {
    switch (obj) {
      case TrendType.hashtag:
        writer.writeByte(0);
        break;
      case TrendType.topic:
        writer.writeByte(1);
        break;
      case TrendType.event:
        writer.writeByte(2);
        break;
      case TrendType.person:
        writer.writeByte(3);
        break;
      case TrendType.location:
        writer.writeByte(4);
        break;
      case TrendType.news:
        writer.writeByte(5);
        break;
      case TrendType.sports:
        writer.writeByte(6);
        break;
      case TrendType.entertainment:
        writer.writeByte(7);
        break;
      case TrendType.technology:
        writer.writeByte(8);
        break;
      case TrendType.politics:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
