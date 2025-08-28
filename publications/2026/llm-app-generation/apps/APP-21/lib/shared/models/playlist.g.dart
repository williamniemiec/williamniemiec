// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlaylistAdapter extends TypeAdapter<Playlist> {
  @override
  final int typeId = 2;

  @override
  Playlist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Playlist(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      imageUrl: fields[3] as String?,
      songIds: (fields[4] as List).cast<String>(),
      creatorId: fields[5] as String,
      creatorName: fields[6] as String,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      isPublic: fields[9] as bool,
      isCollaborative: fields[10] as bool,
      isOfficial: fields[11] as bool,
      followers: fields[12] as int,
      isFollowed: fields[13] as bool,
      isDownloaded: fields[14] as bool,
      collaborators: (fields[15] as List).cast<String>(),
      category: fields[16] as String?,
      tags: (fields[17] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Playlist obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.songIds)
      ..writeByte(5)
      ..write(obj.creatorId)
      ..writeByte(6)
      ..write(obj.creatorName)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isPublic)
      ..writeByte(10)
      ..write(obj.isCollaborative)
      ..writeByte(11)
      ..write(obj.isOfficial)
      ..writeByte(12)
      ..write(obj.followers)
      ..writeByte(13)
      ..write(obj.isFollowed)
      ..writeByte(14)
      ..write(obj.isDownloaded)
      ..writeByte(15)
      ..write(obj.collaborators)
      ..writeByte(16)
      ..write(obj.category)
      ..writeByte(17)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaylistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
