// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      email: fields[1] as String,
      firstName: fields[2] as String,
      lastName: fields[3] as String,
      phoneNumber: fields[4] as String?,
      membershipId: fields[5] as String,
      membershipType: fields[6] as MembershipType,
      memberSince: fields[7] as DateTime,
      profileImageUrl: fields[8] as String?,
      isActive: fields[9] as bool,
      fitnessGoals: (fields[10] as List).cast<String>(),
      emergencyContact: fields[11] as String?,
      emergencyContactPhone: fields[12] as String?,
      lastCheckIn: fields[13] as DateTime?,
      guestPassesRemaining: fields[14] as int,
      hasHealthKitAccess: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.membershipId)
      ..writeByte(6)
      ..write(obj.membershipType)
      ..writeByte(7)
      ..write(obj.memberSince)
      ..writeByte(8)
      ..write(obj.profileImageUrl)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.fitnessGoals)
      ..writeByte(11)
      ..write(obj.emergencyContact)
      ..writeByte(12)
      ..write(obj.emergencyContactPhone)
      ..writeByte(13)
      ..write(obj.lastCheckIn)
      ..writeByte(14)
      ..write(obj.guestPassesRemaining)
      ..writeByte(15)
      ..write(obj.hasHealthKitAccess);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MembershipTypeAdapter extends TypeAdapter<MembershipType> {
  @override
  final int typeId = 1;

  @override
  MembershipType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MembershipType.basic;
      case 1:
        return MembershipType.premium;
      case 2:
        return MembershipType.vip;
      default:
        return MembershipType.basic;
    }
  }

  @override
  void write(BinaryWriter writer, MembershipType obj) {
    switch (obj) {
      case MembershipType.basic:
        writer.writeByte(0);
        break;
      case MembershipType.premium:
        writer.writeByte(1);
        break;
      case MembershipType.vip:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MembershipTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
