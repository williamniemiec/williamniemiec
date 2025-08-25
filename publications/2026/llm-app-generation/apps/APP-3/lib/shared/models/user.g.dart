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
      displayName: fields[2] as String,
      firstName: fields[3] as String?,
      lastName: fields[4] as String?,
      profilePictureUrl: fields[5] as String?,
      jobTitle: fields[6] as String?,
      department: fields[7] as String?,
      phoneNumber: fields[8] as String?,
      status: fields[9] as UserStatus,
      statusMessage: fields[10] as String?,
      lastSeen: fields[11] as DateTime?,
      isOnline: fields[12] as bool,
      teamIds: (fields[13] as List).cast<String>(),
      role: fields[14] as UserRole,
      createdAt: fields[15] as DateTime,
      updatedAt: fields[16] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.profilePictureUrl)
      ..writeByte(6)
      ..write(obj.jobTitle)
      ..writeByte(7)
      ..write(obj.department)
      ..writeByte(8)
      ..write(obj.phoneNumber)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.statusMessage)
      ..writeByte(11)
      ..write(obj.lastSeen)
      ..writeByte(12)
      ..write(obj.isOnline)
      ..writeByte(13)
      ..write(obj.teamIds)
      ..writeByte(14)
      ..write(obj.role)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt);
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

class UserStatusAdapter extends TypeAdapter<UserStatus> {
  @override
  final int typeId = 1;

  @override
  UserStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserStatus.available;
      case 1:
        return UserStatus.busy;
      case 2:
        return UserStatus.doNotDisturb;
      case 3:
        return UserStatus.away;
      case 4:
        return UserStatus.offline;
      default:
        return UserStatus.available;
    }
  }

  @override
  void write(BinaryWriter writer, UserStatus obj) {
    switch (obj) {
      case UserStatus.available:
        writer.writeByte(0);
        break;
      case UserStatus.busy:
        writer.writeByte(1);
        break;
      case UserStatus.doNotDisturb:
        writer.writeByte(2);
        break;
      case UserStatus.away:
        writer.writeByte(3);
        break;
      case UserStatus.offline:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 2;

  @override
  UserRole read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserRole.member;
      case 1:
        return UserRole.admin;
      case 2:
        return UserRole.owner;
      case 3:
        return UserRole.guest;
      default:
        return UserRole.member;
    }
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    switch (obj) {
      case UserRole.member:
        writer.writeByte(0);
        break;
      case UserRole.admin:
        writer.writeByte(1);
        break;
      case UserRole.owner:
        writer.writeByte(2);
        break;
      case UserRole.guest:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
