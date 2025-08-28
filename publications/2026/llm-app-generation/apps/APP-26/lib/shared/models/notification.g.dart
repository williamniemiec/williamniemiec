// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class XNotificationAdapter extends TypeAdapter<XNotification> {
  @override
  final int typeId = 9;

  @override
  XNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return XNotification(
      id: fields[0] as String,
      userId: fields[1] as String,
      type: fields[2] as NotificationType,
      title: fields[3] as String,
      message: fields[4] as String,
      createdAt: fields[5] as DateTime,
      isRead: fields[6] as bool,
      actorId: fields[7] as String?,
      actor: fields[8] as User?,
      postId: fields[9] as String?,
      post: fields[10] as Post?,
      metadata: (fields[11] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, XNotification obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.isRead)
      ..writeByte(7)
      ..write(obj.actorId)
      ..writeByte(8)
      ..write(obj.actor)
      ..writeByte(9)
      ..write(obj.postId)
      ..writeByte(10)
      ..write(obj.post)
      ..writeByte(11)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is XNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 10;

  @override
  NotificationType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationType.like;
      case 1:
        return NotificationType.repost;
      case 2:
        return NotificationType.reply;
      case 3:
        return NotificationType.follow;
      case 4:
        return NotificationType.mention;
      case 5:
        return NotificationType.quote;
      case 6:
        return NotificationType.message;
      case 7:
        return NotificationType.communityInvite;
      case 8:
        return NotificationType.spaceInvite;
      case 9:
        return NotificationType.premium;
      case 10:
        return NotificationType.system;
      default:
        return NotificationType.like;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    switch (obj) {
      case NotificationType.like:
        writer.writeByte(0);
        break;
      case NotificationType.repost:
        writer.writeByte(1);
        break;
      case NotificationType.reply:
        writer.writeByte(2);
        break;
      case NotificationType.follow:
        writer.writeByte(3);
        break;
      case NotificationType.mention:
        writer.writeByte(4);
        break;
      case NotificationType.quote:
        writer.writeByte(5);
        break;
      case NotificationType.message:
        writer.writeByte(6);
        break;
      case NotificationType.communityInvite:
        writer.writeByte(7);
        break;
      case NotificationType.spaceInvite:
        writer.writeByte(8);
        break;
      case NotificationType.premium:
        writer.writeByte(9);
        break;
      case NotificationType.system:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
