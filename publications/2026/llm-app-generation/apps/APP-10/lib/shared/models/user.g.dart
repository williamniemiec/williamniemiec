// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      email: fields[1] as String,
      username: fields[2] as String,
      displayName: fields[3] as String?,
      profileImageUrl: fields[4] as String?,
      coinBalance: fields[5] as int,
      isPremiumSubscriber: fields[6] as bool,
      subscriptionExpiryDate: fields[7] as DateTime?,
      subscriptionType: fields[8] as String,
      createdAt: fields[9] as DateTime,
      lastLoginAt: fields[10] as DateTime,
      watchedEpisodes: (fields[11] as List).cast<String>(),
      favoritesDramas: (fields[12] as List).cast<String>(),
      watchLaterDramas: (fields[13] as List).cast<String>(),
      dramaProgress: (fields[14] as Map).cast<String, int>(),
      preferredLanguage: fields[15] as String,
      preferredGenres: (fields[16] as List).cast<String>(),
      notificationsEnabled: fields[17] as bool,
      autoPlayEnabled: fields[18] as bool,
      videoQuality: fields[19] as String,
      dailyCheckInStreak: fields[20] as int,
      lastCheckInDate: fields[21] as DateTime?,
      totalWatchTime: fields[22] as int,
      totalEpisodesWatched: fields[23] as int,
      settings: (fields[24] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.displayName)
      ..writeByte(4)
      ..write(obj.profileImageUrl)
      ..writeByte(5)
      ..write(obj.coinBalance)
      ..writeByte(6)
      ..write(obj.isPremiumSubscriber)
      ..writeByte(7)
      ..write(obj.subscriptionExpiryDate)
      ..writeByte(8)
      ..write(obj.subscriptionType)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.lastLoginAt)
      ..writeByte(11)
      ..write(obj.watchedEpisodes)
      ..writeByte(12)
      ..write(obj.favoritesDramas)
      ..writeByte(13)
      ..write(obj.watchLaterDramas)
      ..writeByte(14)
      ..write(obj.dramaProgress)
      ..writeByte(15)
      ..write(obj.preferredLanguage)
      ..writeByte(16)
      ..write(obj.preferredGenres)
      ..writeByte(17)
      ..write(obj.notificationsEnabled)
      ..writeByte(18)
      ..write(obj.autoPlayEnabled)
      ..writeByte(19)
      ..write(obj.videoQuality)
      ..writeByte(20)
      ..write(obj.dailyCheckInStreak)
      ..writeByte(21)
      ..write(obj.lastCheckInDate)
      ..writeByte(22)
      ..write(obj.totalWatchTime)
      ..writeByte(23)
      ..write(obj.totalEpisodesWatched)
      ..writeByte(24)
      ..write(obj.settings);
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
