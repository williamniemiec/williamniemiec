// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuestAdapter extends TypeAdapter<Guest> {
  @override
  final int typeId = 13;

  @override
  Guest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Guest(
      id: fields[0] as String,
      memberId: fields[1] as String,
      firstName: fields[2] as String,
      lastName: fields[3] as String,
      email: fields[4] as String?,
      phoneNumber: fields[5] as String?,
      visitDate: fields[6] as DateTime,
      locationId: fields[7] as String,
      status: fields[8] as GuestStatus,
      createdAt: fields[9] as DateTime,
      checkedInAt: fields[10] as DateTime?,
      checkedOutAt: fields[11] as DateTime?,
      hasWaiver: fields[12] as bool,
      emergencyContact: fields[13] as String?,
      emergencyContactPhone: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Guest obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.memberId)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phoneNumber)
      ..writeByte(6)
      ..write(obj.visitDate)
      ..writeByte(7)
      ..write(obj.locationId)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.checkedInAt)
      ..writeByte(11)
      ..write(obj.checkedOutAt)
      ..writeByte(12)
      ..write(obj.hasWaiver)
      ..writeByte(13)
      ..write(obj.emergencyContact)
      ..writeByte(14)
      ..write(obj.emergencyContactPhone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GuestStatusAdapter extends TypeAdapter<GuestStatus> {
  @override
  final int typeId = 14;

  @override
  GuestStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GuestStatus.pending;
      case 1:
        return GuestStatus.approved;
      case 2:
        return GuestStatus.checkedIn;
      case 3:
        return GuestStatus.checkedOut;
      case 4:
        return GuestStatus.expired;
      case 5:
        return GuestStatus.cancelled;
      default:
        return GuestStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, GuestStatus obj) {
    switch (obj) {
      case GuestStatus.pending:
        writer.writeByte(0);
        break;
      case GuestStatus.approved:
        writer.writeByte(1);
        break;
      case GuestStatus.checkedIn:
        writer.writeByte(2);
        break;
      case GuestStatus.checkedOut:
        writer.writeByte(3);
        break;
      case GuestStatus.expired:
        writer.writeByte(4);
        break;
      case GuestStatus.cancelled:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
