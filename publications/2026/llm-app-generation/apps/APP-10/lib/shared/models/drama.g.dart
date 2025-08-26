// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drama.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DramaAdapter extends TypeAdapter<Drama> {
  @override
  final int typeId = 0;

  @override
  Drama read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Drama(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      synopsis: fields[3] as String,
      coverImageUrl: fields[4] as String,
      trailerUrl: fields[5] as String,
      genres: (fields[6] as List).cast<String>(),
      episodes: (fields[7] as List).cast<Episode>(),
      totalEpisodes: fields[8] as int,
      freeEpisodes: fields[9] as int,
      rating: fields[10] as double,
      views: fields[11] as int,
      releaseDate: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      isExclusive: fields[14] as bool,
      isCompleted: fields[15] as bool,
      language: fields[16] as String,
      subtitleLanguages: (fields[17] as List).cast<String>(),
      director: fields[18] as String,
      cast: (fields[19] as List).cast<String>(),
      studio: fields[20] as String,
      duration: fields[21] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Drama obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.synopsis)
      ..writeByte(4)
      ..write(obj.coverImageUrl)
      ..writeByte(5)
      ..write(obj.trailerUrl)
      ..writeByte(6)
      ..write(obj.genres)
      ..writeByte(7)
      ..write(obj.episodes)
      ..writeByte(8)
      ..write(obj.totalEpisodes)
      ..writeByte(9)
      ..write(obj.freeEpisodes)
      ..writeByte(10)
      ..write(obj.rating)
      ..writeByte(11)
      ..write(obj.views)
      ..writeByte(12)
      ..write(obj.releaseDate)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.isExclusive)
      ..writeByte(15)
      ..write(obj.isCompleted)
      ..writeByte(16)
      ..write(obj.language)
      ..writeByte(17)
      ..write(obj.subtitleLanguages)
      ..writeByte(18)
      ..write(obj.director)
      ..writeByte(19)
      ..write(obj.cast)
      ..writeByte(20)
      ..write(obj.studio)
      ..writeByte(21)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DramaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
