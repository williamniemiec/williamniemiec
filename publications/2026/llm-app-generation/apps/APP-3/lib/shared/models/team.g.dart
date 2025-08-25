// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamAdapter extends TypeAdapter<Team> {
  @override
  final int typeId = 8;

  @override
  Team read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Team(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      imageUrl: fields[3] as String?,
      ownerId: fields[4] as String,
      memberIds: (fields[5] as List).cast<String>(),
      adminIds: (fields[6] as List).cast<String>(),
      channels: (fields[7] as List).cast<Channel>(),
      type: fields[8] as TeamType,
      visibility: fields[9] as TeamVisibility,
      isArchived: fields[10] as bool,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      settings: (fields[13] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Team obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.ownerId)
      ..writeByte(5)
      ..write(obj.memberIds)
      ..writeByte(6)
      ..write(obj.adminIds)
      ..writeByte(7)
      ..write(obj.channels)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.visibility)
      ..writeByte(10)
      ..write(obj.isArchived)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChannelAdapter extends TypeAdapter<Channel> {
  @override
  final int typeId = 11;

  @override
  Channel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Channel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      teamId: fields[3] as String,
      type: fields[4] as ChannelType,
      isPrivate: fields[5] as bool,
      memberIds: (fields[6] as List).cast<String>(),
      lastMessageId: fields[7] as String?,
      lastMessageAt: fields[8] as DateTime?,
      unreadCount: fields[9] as int,
      isMuted: fields[10] as bool,
      isPinned: fields[11] as bool,
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
      settings: (fields[14] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Channel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.teamId)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.isPrivate)
      ..writeByte(6)
      ..write(obj.memberIds)
      ..writeByte(7)
      ..write(obj.lastMessageId)
      ..writeByte(8)
      ..write(obj.lastMessageAt)
      ..writeByte(9)
      ..write(obj.unreadCount)
      ..writeByte(10)
      ..write(obj.isMuted)
      ..writeByte(11)
      ..write(obj.isPinned)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamTypeAdapter extends TypeAdapter<TeamType> {
  @override
  final int typeId = 9;

  @override
  TeamType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TeamType.standard;
      case 1:
        return TeamType.community;
      case 2:
        return TeamType.educational;
      case 3:
        return TeamType.project;
      default:
        return TeamType.standard;
    }
  }

  @override
  void write(BinaryWriter writer, TeamType obj) {
    switch (obj) {
      case TeamType.standard:
        writer.writeByte(0);
        break;
      case TeamType.community:
        writer.writeByte(1);
        break;
      case TeamType.educational:
        writer.writeByte(2);
        break;
      case TeamType.project:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamVisibilityAdapter extends TypeAdapter<TeamVisibility> {
  @override
  final int typeId = 10;

  @override
  TeamVisibility read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TeamVisibility.private;
      case 1:
        return TeamVisibility.public;
      case 2:
        return TeamVisibility.orgWide;
      default:
        return TeamVisibility.private;
    }
  }

  @override
  void write(BinaryWriter writer, TeamVisibility obj) {
    switch (obj) {
      case TeamVisibility.private:
        writer.writeByte(0);
        break;
      case TeamVisibility.public:
        writer.writeByte(1);
        break;
      case TeamVisibility.orgWide:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamVisibilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChannelTypeAdapter extends TypeAdapter<ChannelType> {
  @override
  final int typeId = 12;

  @override
  ChannelType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ChannelType.standard;
      case 1:
        return ChannelType.announcement;
      case 2:
        return ChannelType.general;
      case 3:
        return ChannelType.files;
      case 4:
        return ChannelType.wiki;
      default:
        return ChannelType.standard;
    }
  }

  @override
  void write(BinaryWriter writer, ChannelType obj) {
    switch (obj) {
      case ChannelType.standard:
        writer.writeByte(0);
        break;
      case ChannelType.announcement:
        writer.writeByte(1);
        break;
      case ChannelType.general:
        writer.writeByte(2);
        break;
      case ChannelType.files:
        writer.writeByte(3);
        break;
      case ChannelType.wiki:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChannelTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
