// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingAdapter extends TypeAdapter<Meeting> {
  @override
  final int typeId = 15;

  @override
  Meeting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meeting(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      organizerId: fields[3] as String,
      participantIds: (fields[4] as List).cast<String>(),
      requiredAttendeeIds: (fields[5] as List).cast<String>(),
      optionalAttendeeIds: (fields[6] as List).cast<String>(),
      startTime: fields[7] as DateTime,
      endTime: fields[8] as DateTime,
      location: fields[9] as String?,
      meetingUrl: fields[10] as String?,
      dialInNumber: fields[11] as String?,
      conferenceId: fields[12] as String?,
      type: fields[13] as MeetingType,
      status: fields[14] as MeetingStatus,
      isRecurring: fields[15] as bool,
      recurrencePattern: fields[16] as String?,
      allowRecording: fields[17] as bool,
      isRecording: fields[18] as bool,
      recordingUrl: fields[19] as String?,
      requiresPassword: fields[20] as bool,
      password: fields[21] as String?,
      allowScreenSharing: fields[22] as bool,
      allowChat: fields[23] as bool,
      muteParticipantsOnEntry: fields[24] as bool,
      createdAt: fields[25] as DateTime,
      updatedAt: fields[26] as DateTime,
      metadata: (fields[27] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Meeting obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.organizerId)
      ..writeByte(4)
      ..write(obj.participantIds)
      ..writeByte(5)
      ..write(obj.requiredAttendeeIds)
      ..writeByte(6)
      ..write(obj.optionalAttendeeIds)
      ..writeByte(7)
      ..write(obj.startTime)
      ..writeByte(8)
      ..write(obj.endTime)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.meetingUrl)
      ..writeByte(11)
      ..write(obj.dialInNumber)
      ..writeByte(12)
      ..write(obj.conferenceId)
      ..writeByte(13)
      ..write(obj.type)
      ..writeByte(14)
      ..write(obj.status)
      ..writeByte(15)
      ..write(obj.isRecurring)
      ..writeByte(16)
      ..write(obj.recurrencePattern)
      ..writeByte(17)
      ..write(obj.allowRecording)
      ..writeByte(18)
      ..write(obj.isRecording)
      ..writeByte(19)
      ..write(obj.recordingUrl)
      ..writeByte(20)
      ..write(obj.requiresPassword)
      ..writeByte(21)
      ..write(obj.password)
      ..writeByte(22)
      ..write(obj.allowScreenSharing)
      ..writeByte(23)
      ..write(obj.allowChat)
      ..writeByte(24)
      ..write(obj.muteParticipantsOnEntry)
      ..writeByte(25)
      ..write(obj.createdAt)
      ..writeByte(26)
      ..write(obj.updatedAt)
      ..writeByte(27)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeetingTypeAdapter extends TypeAdapter<MeetingType> {
  @override
  final int typeId = 16;

  @override
  MeetingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MeetingType.scheduled;
      case 1:
        return MeetingType.instant;
      case 2:
        return MeetingType.recurring;
      case 3:
        return MeetingType.webinar;
      default:
        return MeetingType.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, MeetingType obj) {
    switch (obj) {
      case MeetingType.scheduled:
        writer.writeByte(0);
        break;
      case MeetingType.instant:
        writer.writeByte(1);
        break;
      case MeetingType.recurring:
        writer.writeByte(2);
        break;
      case MeetingType.webinar:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MeetingStatusAdapter extends TypeAdapter<MeetingStatus> {
  @override
  final int typeId = 17;

  @override
  MeetingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MeetingStatus.scheduled;
      case 1:
        return MeetingStatus.inProgress;
      case 2:
        return MeetingStatus.ended;
      case 3:
        return MeetingStatus.cancelled;
      case 4:
        return MeetingStatus.postponed;
      default:
        return MeetingStatus.scheduled;
    }
  }

  @override
  void write(BinaryWriter writer, MeetingStatus obj) {
    switch (obj) {
      case MeetingStatus.scheduled:
        writer.writeByte(0);
        break;
      case MeetingStatus.inProgress:
        writer.writeByte(1);
        break;
      case MeetingStatus.ended:
        writer.writeByte(2);
        break;
      case MeetingStatus.cancelled:
        writer.writeByte(3);
        break;
      case MeetingStatus.postponed:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
