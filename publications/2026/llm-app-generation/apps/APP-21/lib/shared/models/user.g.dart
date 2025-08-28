// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

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
      profileImageUrl: fields[3] as String?,
      isPremium: fields[4] as bool,
      premiumExpiryDate: fields[5] as DateTime?,
      likedSongs: (fields[6] as List).cast<String>(),
      followedArtists: (fields[7] as List).cast<String>(),
      createdPlaylists: (fields[8] as List).cast<String>(),
      followedPlaylists: (fields[9] as List).cast<String>(),
      recentlyPlayed: (fields[10] as List).cast<String>(),
      preferences: (fields[11] as Map).cast<String, dynamic>(),
      createdAt: fields[12] as DateTime,
      lastLoginAt: fields[13] as DateTime,
      downloadedSongs: (fields[14] as List).cast<String>(),
      downloadedPlaylists: (fields[15] as List).cast<String>(),
      country: fields[16] as String?,
      language: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.profileImageUrl)
      ..writeByte(4)
      ..write(obj.isPremium)
      ..writeByte(5)
      ..write(obj.premiumExpiryDate)
      ..writeByte(6)
      ..write(obj.likedSongs)
      ..writeByte(7)
      ..write(obj.followedArtists)
      ..writeByte(8)
      ..write(obj.createdPlaylists)
      ..writeByte(9)
      ..write(obj.followedPlaylists)
      ..writeByte(10)
      ..write(obj.recentlyPlayed)
      ..writeByte(11)
      ..write(obj.preferences)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.lastLoginAt)
      ..writeByte(14)
      ..write(obj.downloadedSongs)
      ..writeByte(15)
      ..write(obj.downloadedPlaylists)
      ..writeByte(16)
      ..write(obj.country)
      ..writeByte(17)
      ..write(obj.language);
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
