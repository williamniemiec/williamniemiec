// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumAdapter extends TypeAdapter<Album> {
  @override
  final int typeId = 4;

  @override
  Album read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Album(
      id: fields[0] as String,
      title: fields[1] as String,
      artistId: fields[2] as String,
      artistName: fields[3] as String,
      coverImageUrl: fields[4] as String?,
      songIds: (fields[5] as List).cast<String>(),
      releaseDate: fields[6] as DateTime,
      genres: (fields[7] as List).cast<String>(),
      description: fields[8] as String?,
      isExplicit: fields[9] as bool,
      isLiked: fields[10] as bool,
      isDownloaded: fields[11] as bool,
      albumType: fields[12] as String,
      popularity: fields[13] as double?,
      label: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Album obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.artistId)
      ..writeByte(3)
      ..write(obj.artistName)
      ..writeByte(4)
      ..write(obj.coverImageUrl)
      ..writeByte(5)
      ..write(obj.songIds)
      ..writeByte(6)
      ..write(obj.releaseDate)
      ..writeByte(7)
      ..write(obj.genres)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.isExplicit)
      ..writeByte(10)
      ..write(obj.isLiked)
      ..writeByte(11)
      ..write(obj.isDownloaded)
      ..writeByte(12)
      ..write(obj.albumType)
      ..writeByte(13)
      ..write(obj.popularity)
      ..writeByte(14)
      ..write(obj.label);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
