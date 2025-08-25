// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 18;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      id: fields[0] as String,
      type: fields[1] as ActivityType,
      title: fields[2] as String,
      description: fields[3] as String,
      actorId: fields[4] as String?,
      actorName: fields[5] as String?,
      actorAvatarUrl: fields[6] as String?,
      targetId: fields[7] as String?,
      targetType: fields[8] as String?,
      targetName: fields[9] as String?,
      timestamp: fields[10] as DateTime,
      isRead: fields[11] as bool,
      priority: fields[12] as ActivityPriority,
      metadata: (fields[13] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.actorId)
      ..writeByte(5)
      ..write(obj.actorName)
      ..writeByte(6)
      ..write(obj.actorAvatarUrl)
      ..writeByte(7)
      ..write(obj.targetId)
      ..writeByte(8)
      ..write(obj.targetType)
      ..writeByte(9)
      ..write(obj.targetName)
      ..writeByte(10)
      ..write(obj.timestamp)
      ..writeByte(11)
      ..write(obj.isRead)
      ..writeByte(12)
      ..write(obj.priority)
      ..writeByte(13)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityTypeAdapter extends TypeAdapter<ActivityType> {
  @override
  final int typeId = 19;

  @override
  ActivityType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityType.message;
      case 1:
        return ActivityType.mention;
      case 2:
        return ActivityType.reply;
      case 3:
        return ActivityType.reaction;
      case 4:
        return ActivityType.meeting;
      case 5:
        return ActivityType.call;
      case 6:
        return ActivityType.file;
      case 7:
        return ActivityType.teamUpdate;
      case 8:
        return ActivityType.channelUpdate;
      case 9:
        return ActivityType.memberJoined;
      case 10:
        return ActivityType.memberLeft;
      case 11:
        return ActivityType.assignment;
      case 12:
        return ActivityType.announcement;
      default:
        return ActivityType.message;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityType obj) {
    switch (obj) {
      case ActivityType.message:
        writer.writeByte(0);
        break;
      case ActivityType.mention:
        writer.writeByte(1);
        break;
      case ActivityType.reply:
        writer.writeByte(2);
        break;
      case ActivityType.reaction:
        writer.writeByte(3);
        break;
      case ActivityType.meeting:
        writer.writeByte(4);
        break;
      case ActivityType.call:
        writer.writeByte(5);
        break;
      case ActivityType.file:
        writer.writeByte(6);
        break;
      case ActivityType.teamUpdate:
        writer.writeByte(7);
        break;
      case ActivityType.channelUpdate:
        writer.writeByte(8);
        break;
      case ActivityType.memberJoined:
        writer.writeByte(9);
        break;
      case ActivityType.memberLeft:
        writer.writeByte(10);
        break;
      case ActivityType.assignment:
        writer.writeByte(11);
        break;
      case ActivityType.announcement:
        writer.writeByte(12);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityPriorityAdapter extends TypeAdapter<ActivityPriority> {
  @override
  final int typeId = 20;

  @override
  ActivityPriority read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActivityPriority.low;
      case 1:
        return ActivityPriority.normal;
      case 2:
        return ActivityPriority.high;
      case 3:
        return ActivityPriority.urgent;
      default:
        return ActivityPriority.low;
    }
  }

  @override
  void write(BinaryWriter writer, ActivityPriority obj) {
    switch (obj) {
      case ActivityPriority.low:
        writer.writeByte(0);
        break;
      case ActivityPriority.normal:
        writer.writeByte(1);
        break;
      case ActivityPriority.high:
        writer.writeByte(2);
        break;
      case ActivityPriority.urgent:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityPriorityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
