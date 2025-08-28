class Message {
  final String id;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? replyToId;
  final List<MessageAttachment> attachments;
  final Map<String, dynamic> metadata;
  final bool isEdited;
  final bool isDeleted;
  final List<MessageReaction> reactions;

  const Message({
    required this.id,
    required this.senderId,
    this.senderName,
    this.senderAvatar,
    required this.content,
    required this.type,
    required this.createdAt,
    this.updatedAt,
    this.replyToId,
    this.attachments = const [],
    this.metadata = const {},
    this.isEdited = false,
    this.isDeleted = false,
    this.reactions = const [],
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String?,
      senderAvatar: json['sender_avatar'] as String?,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      replyToId: json['reply_to_id'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((a) => MessageAttachment.fromJson(a as Map<String, dynamic>))
          .toList() ?? [],
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      isEdited: json['is_edited'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      reactions: (json['reactions'] as List<dynamic>?)
          ?.map((r) => MessageReaction.fromJson(r as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_avatar': senderAvatar,
      'content': content,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'reply_to_id': replyToId,
      'attachments': attachments.map((a) => a.toJson()).toList(),
      'metadata': metadata,
      'is_edited': isEdited,
      'is_deleted': isDeleted,
      'reactions': reactions.map((r) => r.toJson()).toList(),
    };
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? content,
    MessageType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? replyToId,
    List<MessageAttachment>? attachments,
    Map<String, dynamic>? metadata,
    bool? isEdited,
    bool? isDeleted,
    List<MessageReaction>? reactions,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replyToId: replyToId ?? this.replyToId,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      reactions: reactions ?? this.reactions,
    );
  }

  bool get hasAttachments => attachments.isNotEmpty;
  bool get isReply => replyToId != null;
  bool get hasReactions => reactions.isNotEmpty;
}

enum MessageType {
  text,
  image,
  gif,
  poll,
  trade,
  transaction,
  system,
  announcement,
  draft_pick,
  waiver_claim,
  score_update,
}

class MessageAttachment {
  final String id;
  final AttachmentType type;
  final String url;
  final String? thumbnailUrl;
  final String? fileName;
  final int? fileSize;
  final Map<String, dynamic> metadata;

  const MessageAttachment({
    required this.id,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.fileName,
    this.fileSize,
    this.metadata = const {},
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      type: AttachmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AttachmentType.image,
      ),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] as int?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'metadata': metadata,
    };
  }
}

enum AttachmentType {
  image,
  gif,
  video,
  file,
}

class MessageReaction {
  final String emoji;
  final List<String> userIds;
  final int count;

  const MessageReaction({
    required this.emoji,
    required this.userIds,
    required this.count,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      emoji: json['emoji'] as String,
      userIds: List<String>.from(json['user_ids'] ?? []),
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'user_ids': userIds,
      'count': count,
    };
  }
}

class ChatChannel {
  final String id;
  final String name;
  final ChannelType type;
  final List<String> memberIds;
  final String? leagueId;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final Message? lastMessage;
  final Map<String, dynamic> settings;
  final bool isActive;

  const ChatChannel({
    required this.id,
    required this.name,
    required this.type,
    required this.memberIds,
    this.leagueId,
    required this.createdAt,
    this.lastMessageAt,
    this.lastMessage,
    this.settings = const {},
    this.isActive = true,
  });

  factory ChatChannel.fromJson(Map<String, dynamic> json) {
    return ChatChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: ChannelType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChannelType.direct,
      ),
      memberIds: List<String>.from(json['member_ids'] ?? []),
      leagueId: json['league_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessageAt: json['last_message_at'] != null 
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessage: json['last_message'] != null 
          ? Message.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
      settings: json['settings'] as Map<String, dynamic>? ?? {},
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'member_ids': memberIds,
      'league_id': leagueId,
      'created_at': createdAt.toIso8601String(),
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message': lastMessage?.toJson(),
      'settings': settings,
      'is_active': isActive,
    };
  }

  bool get isLeagueChannel => type == ChannelType.league;
  bool get isDirectMessage => type == ChannelType.direct;
  bool get isGroupChat => type == ChannelType.group;
}

enum ChannelType {
  direct,
  group,
  league,
  announcement,
}

class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  final String creatorId;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final bool allowMultipleVotes;
  final bool isAnonymous;
  final Map<String, dynamic> metadata;

  const Poll({
    required this.id,
    required this.question,
    required this.options,
    required this.creatorId,
    required this.createdAt,
    this.expiresAt,
    this.allowMultipleVotes = false,
    this.isAnonymous = false,
    this.metadata = const {},
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>)
          .map((o) => PollOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      creatorId: json['creator_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: json['expires_at'] != null 
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      allowMultipleVotes: json['allow_multiple_votes'] as bool? ?? false,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((o) => o.toJson()).toList(),
      'creator_id': creatorId,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'allow_multiple_votes': allowMultipleVotes,
      'is_anonymous': isAnonymous,
      'metadata': metadata,
    };
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  int get totalVotes => options.fold(0, (sum, option) => sum + option.votes.length);
}

class PollOption {
  final String id;
  final String text;
  final List<String> votes;
  final Map<String, dynamic> metadata;

  const PollOption({
    required this.id,
    required this.text,
    this.votes = const [],
    this.metadata = const {},
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] as String,
      text: json['text'] as String,
      votes: List<String>.from(json['votes'] ?? []),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'votes': votes,
      'metadata': metadata,
    };
  }

  int get voteCount => votes.length;
}