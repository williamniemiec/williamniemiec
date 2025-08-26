// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EpisodeAdapter extends TypeAdapter<Episode> {
  @override
  final int typeId = 1;

  @override
  Episode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Episode(
      id: fields[0] as String,
      dramaId: fields[1] as String,
      episodeNumber: fields[2] as int,
      title: fields[3] as String,
      description: fields[4] as String,
      videoUrl: fields[5] as String,
      thumbnailUrl: fields[6] as String,
      duration: fields[7] as int,
      isFree: fields[8] as bool,
      coinCost: fields[9] as int,
      isLocked: fields[10] as bool,
      releaseDate: fields[11] as DateTime,
      views: fields[12] as int,
      rating: fields[13] as double,
      subtitleLanguages: (fields[14] as List).cast<String>(),
      subtitleUrls: (fields[15] as Map).cast<String, String>(),
      quality: fields[16] as String,
      hasNextEpisode: fields[17] as bool,
      hasPreviousEpisode: fields[18] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Episode obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dramaId)
      ..writeByte(2)
      ..write(obj.episodeNumber)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.videoUrl)
      ..writeByte(6)
      ..write(obj.thumbnailUrl)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.isFree)
      ..writeByte(9)
      ..write(obj.coinCost)
      ..writeByte(10)
      ..write(obj.isLocked)
      ..writeByte(11)
      ..write(obj.releaseDate)
      ..writeByte(12)
      ..write(obj.views)
      ..writeByte(13)
      ..write(obj.rating)
      ..writeByte(14)
      ..write(obj.subtitleLanguages)
      ..writeByte(15)
      ..write(obj.subtitleUrls)
      ..writeByte(16)
      ..write(obj.quality)
      ..writeByte(17)
      ..write(obj.hasNextEpisode)
      ..writeByte(18)
      ..write(obj.hasPreviousEpisode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
