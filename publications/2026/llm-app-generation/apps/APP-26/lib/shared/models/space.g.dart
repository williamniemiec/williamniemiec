// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpaceAdapter extends TypeAdapter<Space> {
  @override
  final int typeId = 11;

  @override
  Space read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Space(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      hostId: fields[3] as String,
      host: fields[4] as User,
      createdAt: fields[5] as DateTime,
      scheduledFor: fields[6] as DateTime?,
      startedAt: fields[7] as DateTime?,
      endedAt: fields[8] as DateTime?,
      state: fields[9] as SpaceState,
      speakerIds: (fields[10] as List).cast<String>(),
      speakers: (fields[11] as List).cast<User>(),
      listenerIds: (fields[12] as List).cast<String>(),
      listenersCount: fields[13] as int,
      isRecorded: fields[14] as bool,
      isPublic: fields[15] as bool,
      topics: (fields[16] as List).cast<String>(),
      recordingUrl: fields[17] as String?,
      metadata: (fields[18] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Space obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.hostId)
      ..writeByte(4)
      ..write(obj.host)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.scheduledFor)
      ..writeByte(7)
      ..write(obj.startedAt)
      ..writeByte(8)
      ..write(obj.endedAt)
      ..writeByte(9)
      ..write(obj.state)
      ..writeByte(10)
      ..write(obj.speakerIds)
      ..writeByte(11)
      ..write(obj.speakers)
      ..writeByte(12)
      ..write(obj.listenerIds)
      ..writeByte(13)
      ..write(obj.listenersCount)
      ..writeByte(14)
      ..write(obj.isRecorded)
      ..writeByte(15)
      ..write(obj.isPublic)
      ..writeByte(16)
      ..write(obj.topics)
      ..writeByte(17)
      ..write(obj.recordingUrl)
      ..writeByte(18)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SpaceStateAdapter extends TypeAdapter<SpaceState> {
  @override
  final int typeId = 12;

  @override
  SpaceState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SpaceState.scheduled;
      case 1:
        return SpaceState.live;
      case 2:
        return SpaceState.ended;
      case 3:
        return SpaceState.cancelled;
      default:
        return SpaceState.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, SpaceState obj) {
    switch (obj) {
      case SpaceState.scheduled:
        writer.writeByte(0);
        break;
      case SpaceState.live:
        writer.writeByte(1);
        break;
      case SpaceState.ended:
        writer.writeByte(2);
        break;
      case SpaceState.cancelled:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
