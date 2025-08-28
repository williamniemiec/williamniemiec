// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 1;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      id: fields[0] as String,
      authorId: fields[1] as String,
      author: fields[2] as User,
      content: fields[3] as String,
      mediaUrls: (fields[4] as List).cast<String>(),
      type: fields[5] as String,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime,
      likesCount: fields[8] as int,
      repostsCount: fields[9] as int,
      repliesCount: fields[10] as int,
      viewsCount: fields[11] as int,
      bookmarksCount: fields[12] as int,
      isLiked: fields[13] as bool,
      isReposted: fields[14] as bool,
      isBookmarked: fields[15] as bool,
      replyToId: fields[16] as String?,
      replyTo: fields[17] as Post?,
      repostOfId: fields[18] as String?,
      repostOf: fields[19] as Post?,
      quoteOfId: fields[20] as String?,
      quoteOf: fields[21] as Post?,
      hashtags: (fields[22] as List).cast<String>(),
      mentions: (fields[23] as List).cast<String>(),
      urls: (fields[24] as List).cast<String>(),
      poll: fields[25] as Poll?,
      isEdited: fields[26] as bool,
      editedAt: fields[27] as DateTime?,
      isPinned: fields[28] as bool,
      location: fields[29] as String?,
      metadata: (fields[30] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.authorId)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.mediaUrls)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.likesCount)
      ..writeByte(9)
      ..write(obj.repostsCount)
      ..writeByte(10)
      ..write(obj.repliesCount)
      ..writeByte(11)
      ..write(obj.viewsCount)
      ..writeByte(12)
      ..write(obj.bookmarksCount)
      ..writeByte(13)
      ..write(obj.isLiked)
      ..writeByte(14)
      ..write(obj.isReposted)
      ..writeByte(15)
      ..write(obj.isBookmarked)
      ..writeByte(16)
      ..write(obj.replyToId)
      ..writeByte(17)
      ..write(obj.replyTo)
      ..writeByte(18)
      ..write(obj.repostOfId)
      ..writeByte(19)
      ..write(obj.repostOf)
      ..writeByte(20)
      ..write(obj.quoteOfId)
      ..writeByte(21)
      ..write(obj.quoteOf)
      ..writeByte(22)
      ..write(obj.hashtags)
      ..writeByte(23)
      ..write(obj.mentions)
      ..writeByte(24)
      ..write(obj.urls)
      ..writeByte(25)
      ..write(obj.poll)
      ..writeByte(26)
      ..write(obj.isEdited)
      ..writeByte(27)
      ..write(obj.editedAt)
      ..writeByte(28)
      ..write(obj.isPinned)
      ..writeByte(29)
      ..write(obj.location)
      ..writeByte(30)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PollAdapter extends TypeAdapter<Poll> {
  @override
  final int typeId = 2;

  @override
  Poll read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Poll(
      id: fields[0] as String,
      options: (fields[1] as List).cast<PollOption>(),
      endsAt: fields[2] as DateTime,
      totalVotes: fields[3] as int,
      hasVoted: fields[4] as bool,
      votedOptionId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Poll obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.options)
      ..writeByte(2)
      ..write(obj.endsAt)
      ..writeByte(3)
      ..write(obj.totalVotes)
      ..writeByte(4)
      ..write(obj.hasVoted)
      ..writeByte(5)
      ..write(obj.votedOptionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PollOptionAdapter extends TypeAdapter<PollOption> {
  @override
  final int typeId = 3;

  @override
  PollOption read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PollOption(
      id: fields[0] as String,
      text: fields[1] as String,
      votes: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PollOption obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.votes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PollOptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
