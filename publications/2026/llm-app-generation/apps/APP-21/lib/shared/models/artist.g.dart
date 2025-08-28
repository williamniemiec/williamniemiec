// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtistAdapter extends TypeAdapter<Artist> {
  @override
  final int typeId = 1;

  @override
  Artist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artist(
      id: fields[0] as String,
      name: fields[1] as String,
      bio: fields[2] as String?,
      imageUrl: fields[3] as String?,
      genres: (fields[4] as List).cast<String>(),
      followers: fields[5] as int,
      isVerified: fields[6] as bool,
      isFollowed: fields[7] as bool,
      topSongs: (fields[8] as List).cast<String>(),
      albums: (fields[9] as List).cast<String>(),
      popularity: fields[10] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Artist obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.bio)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.genres)
      ..writeByte(5)
      ..write(obj.followers)
      ..writeByte(6)
      ..write(obj.isVerified)
      ..writeByte(7)
      ..write(obj.isFollowed)
      ..writeByte(8)
      ..write(obj.topSongs)
      ..writeByte(9)
      ..write(obj.albums)
      ..writeByte(10)
      ..write(obj.popularity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
