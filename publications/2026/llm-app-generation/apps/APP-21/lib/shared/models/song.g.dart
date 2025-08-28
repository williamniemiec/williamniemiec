// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 0;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      id: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      album: fields[3] as String,
      albumArt: fields[4] as String?,
      videoUrl: fields[5] as String?,
      audioUrl: fields[6] as String?,
      duration: fields[7] as Duration,
      genres: (fields[8] as List).cast<String>(),
      releaseDate: fields[9] as DateTime,
      isExplicit: fields[10] as bool,
      isDownloaded: fields[11] as bool,
      isPremiumOnly: fields[12] as bool,
      lyrics: fields[13] as String?,
      playCount: fields[14] as int,
      isLiked: fields[15] as bool,
      artistId: fields[16] as String?,
      albumId: fields[17] as String?,
      popularity: fields[18] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.album)
      ..writeByte(4)
      ..write(obj.albumArt)
      ..writeByte(5)
      ..write(obj.videoUrl)
      ..writeByte(6)
      ..write(obj.audioUrl)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.genres)
      ..writeByte(9)
      ..write(obj.releaseDate)
      ..writeByte(10)
      ..write(obj.isExplicit)
      ..writeByte(11)
      ..write(obj.isDownloaded)
      ..writeByte(12)
      ..write(obj.isPremiumOnly)
      ..writeByte(13)
      ..write(obj.lyrics)
      ..writeByte(14)
      ..write(obj.playCount)
      ..writeByte(15)
      ..write(obj.isLiked)
      ..writeByte(16)
      ..write(obj.artistId)
      ..writeByte(17)
      ..write(obj.albumId)
      ..writeByte(18)
      ..write(obj.popularity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
