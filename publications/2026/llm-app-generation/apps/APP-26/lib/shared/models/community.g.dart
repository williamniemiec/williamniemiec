// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CommunityAdapter extends TypeAdapter<Community> {
  @override
  final int typeId = 4;

  @override
  Community read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Community(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      imageUrl: fields[3] as String?,
      bannerUrl: fields[4] as String?,
      creatorId: fields[5] as String,
      creator: fields[6] as User,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime,
      membersCount: fields[9] as int,
      postsCount: fields[10] as int,
      isPrivate: fields[11] as bool,
      isMember: fields[12] as bool,
      isModerator: fields[13] as bool,
      isAdmin: fields[14] as bool,
      rules: (fields[15] as List).cast<String>(),
      topics: (fields[16] as List).cast<String>(),
      moderatorIds: (fields[17] as List).cast<String>(),
      settings: fields[18] as CommunitySettings,
    );
  }

  @override
  void write(BinaryWriter writer, Community obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.bannerUrl)
      ..writeByte(5)
      ..write(obj.creatorId)
      ..writeByte(6)
      ..write(obj.creator)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.membersCount)
      ..writeByte(10)
      ..write(obj.postsCount)
      ..writeByte(11)
      ..write(obj.isPrivate)
      ..writeByte(12)
      ..write(obj.isMember)
      ..writeByte(13)
      ..write(obj.isModerator)
      ..writeByte(14)
      ..write(obj.isAdmin)
      ..writeByte(15)
      ..write(obj.rules)
      ..writeByte(16)
      ..write(obj.topics)
      ..writeByte(17)
      ..write(obj.moderatorIds)
      ..writeByte(18)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CommunitySettingsAdapter extends TypeAdapter<CommunitySettings> {
  @override
  final int typeId = 5;

  @override
  CommunitySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CommunitySettings(
      allowImages: fields[0] as bool,
      allowVideos: fields[1] as bool,
      allowPolls: fields[2] as bool,
      requireApproval: fields[3] as bool,
      allowInvites: fields[4] as bool,
      maxPostLength: fields[5] as int,
      bannedWords: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CommunitySettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.allowImages)
      ..writeByte(1)
      ..write(obj.allowVideos)
      ..writeByte(2)
      ..write(obj.allowPolls)
      ..writeByte(3)
      ..write(obj.requireApproval)
      ..writeByte(4)
      ..write(obj.allowInvites)
      ..writeByte(5)
      ..write(obj.maxPostLength)
      ..writeByte(6)
      ..write(obj.bannedWords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommunitySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
