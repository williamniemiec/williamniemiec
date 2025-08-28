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
      username: fields[1] as String,
      displayName: fields[2] as String,
      email: fields[3] as String,
      bio: fields[4] as String?,
      location: fields[5] as String?,
      website: fields[6] as String?,
      profileImageUrl: fields[7] as String?,
      bannerImageUrl: fields[8] as String?,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      followersCount: fields[11] as int,
      followingCount: fields[12] as int,
      postsCount: fields[13] as int,
      isVerified: fields[14] as bool,
      isPremium: fields[15] as bool,
      isPrivate: fields[16] as bool,
      isFollowing: fields[17] as bool,
      isFollowedBy: fields[18] as bool,
      isBlocked: fields[19] as bool,
      isMuted: fields[20] as bool,
      interests: (fields[21] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.bio)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.website)
      ..writeByte(7)
      ..write(obj.profileImageUrl)
      ..writeByte(8)
      ..write(obj.bannerImageUrl)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.followersCount)
      ..writeByte(12)
      ..write(obj.followingCount)
      ..writeByte(13)
      ..write(obj.postsCount)
      ..writeByte(14)
      ..write(obj.isVerified)
      ..writeByte(15)
      ..write(obj.isPremium)
      ..writeByte(16)
      ..write(obj.isPrivate)
      ..writeByte(17)
      ..write(obj.isFollowing)
      ..writeByte(18)
      ..write(obj.isFollowedBy)
      ..writeByte(19)
      ..write(obj.isBlocked)
      ..writeByte(20)
      ..write(obj.isMuted)
      ..writeByte(21)
      ..write(obj.interests);
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
