// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 6;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      id: fields[0] as String,
      conversationId: fields[1] as String,
      senderId: fields[2] as String,
      sender: fields[3] as User,
      content: fields[4] as String,
      type: fields[5] as MessageType,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      isRead: fields[8] as bool,
      isDelivered: fields[9] as bool,
      isEdited: fields[10] as bool,
      editedAt: fields[11] as DateTime?,
      replyToId: fields[12] as String?,
      replyTo: fields[13] as Message?,
      mediaUrls: (fields[14] as List).cast<String>(),
      metadata: (fields[15] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.conversationId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.sender)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.isRead)
      ..writeByte(9)
      ..write(obj.isDelivered)
      ..writeByte(10)
      ..write(obj.isEdited)
      ..writeByte(11)
      ..write(obj.editedAt)
      ..writeByte(12)
      ..write(obj.replyToId)
      ..writeByte(13)
      ..write(obj.replyTo)
      ..writeByte(14)
      ..write(obj.mediaUrls)
      ..writeByte(15)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConversationAdapter extends TypeAdapter<Conversation> {
  @override
  final int typeId = 8;

  @override
  Conversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Conversation(
      id: fields[0] as String,
      participantIds: (fields[1] as List).cast<String>(),
      participants: (fields[2] as List).cast<User>(),
      name: fields[3] as String?,
      imageUrl: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
      lastMessage: fields[7] as Message?,
      unreadCount: fields[8] as int,
      isGroup: fields[9] as bool,
      isMuted: fields[10] as bool,
      isArchived: fields[11] as bool,
      creatorId: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Conversation obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.participantIds)
      ..writeByte(2)
      ..write(obj.participants)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.lastMessage)
      ..writeByte(8)
      ..write(obj.unreadCount)
      ..writeByte(9)
      ..write(obj.isGroup)
      ..writeByte(10)
      ..write(obj.isMuted)
      ..writeByte(11)
      ..write(obj.isArchived)
      ..writeByte(12)
      ..write(obj.creatorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 7;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.text;
      case 1:
        return MessageType.image;
      case 2:
        return MessageType.video;
      case 3:
        return MessageType.audio;
      case 4:
        return MessageType.file;
      case 5:
        return MessageType.location;
      case 6:
        return MessageType.contact;
      case 7:
        return MessageType.sticker;
      case 8:
        return MessageType.gif;
      default:
        return MessageType.text;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.text:
        writer.writeByte(0);
        break;
      case MessageType.image:
        writer.writeByte(1);
        break;
      case MessageType.video:
        writer.writeByte(2);
        break;
      case MessageType.audio:
        writer.writeByte(3);
        break;
      case MessageType.file:
        writer.writeByte(4);
        break;
      case MessageType.location:
        writer.writeByte(5);
        break;
      case MessageType.contact:
        writer.writeByte(6);
        break;
      case MessageType.sticker:
        writer.writeByte(7);
        break;
      case MessageType.gif:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
