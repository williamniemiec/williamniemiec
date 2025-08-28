import 'user.dart';

enum MessageType { private, chat, mention, reply }

class RedditMessage {
  final String id;
  final MessageType type;
  final RedditUser sender;
  final RedditUser? recipient;
  final String subject;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final bool isDeleted;
  final String? parentId;
  final String? contextId;
  final Map<String, dynamic> metadata;

  const RedditMessage({
    required this.id,
    required this.type,
    required this.sender,
    this.recipient,
    required this.subject,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    this.isDeleted = false,
    this.parentId,
    this.contextId,
    this.metadata = const {},
  });

  factory RedditMessage.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    return RedditMessage(
      id: data['id'] ?? '',
      type: _parseMessageType(data['type'] ?? data['kind']),
      sender: RedditUser.fromJson({
        'name': data['author'] ?? '',
        'id': data['author_fullname'] ?? '',
      }),
      recipient: data['dest'] != null 
          ? RedditUser.fromJson({
              'name': data['dest'],
              'id': '',
            })
          : null,
      subject: data['subject'] ?? '',
      content: data['body'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['created_utc'] ?? 0) * 1000).toInt(),
      ),
      isRead: !(data['new'] ?? false),
      isDeleted: data['author'] == '[deleted]',
      parentId: data['parent_id'],
      contextId: data['context'],
      metadata: {
        'subreddit': data['subreddit'],
        'link_title': data['link_title'],
        'was_comment': data['was_comment'] ?? false,
        'score': data['score'],
        'num_comments': data['num_comments'],
      },
    );
  }

  static MessageType _parseMessageType(String? type) {
    switch (type) {
      case 't4':
      case 'private_message':
        return MessageType.private;
      case 'chat':
        return MessageType.chat;
      case 'username_mention':
        return MessageType.mention;
      case 'comment_reply':
      case 'post_reply':
        return MessageType.reply;
      default:
        return MessageType.private;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'author': sender.username,
      'author_fullname': sender.id,
      'dest': recipient?.username,
      'subject': subject,
      'body': content,
      'created_utc': createdAt.millisecondsSinceEpoch / 1000,
      'new': !isRead,
      'parent_id': parentId,
      'context': contextId,
      'metadata': metadata,
    };
  }

  RedditMessage copyWith({
    String? id,
    MessageType? type,
    RedditUser? sender,
    RedditUser? recipient,
    String? subject,
    String? content,
    DateTime? createdAt,
    bool? isRead,
    bool? isDeleted,
    String? parentId,
    String? contextId,
    Map<String, dynamic>? metadata,
  }) {
    return RedditMessage(
      id: id ?? this.id,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      recipient: recipient ?? this.recipient,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      isDeleted: isDeleted ?? this.isDeleted,
      parentId: parentId ?? this.parentId,
      contextId: contextId ?? this.contextId,
      metadata: metadata ?? this.metadata,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'now';
    }
  }

  String get displayContent {
    if (isDeleted) return '[deleted]';
    return content;
  }

  String get displaySubject {
    if (subject.isEmpty) {
      switch (type) {
        case MessageType.reply:
          return 'Reply to your comment';
        case MessageType.mention:
          return 'Username mention';
        case MessageType.chat:
          return 'Chat message';
        default:
          return 'Private message';
      }
    }
    return subject;
  }

  bool get isFromComment => metadata['was_comment'] == true;
  String? get subredditName => metadata['subreddit'];
  String? get linkTitle => metadata['link_title'];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RedditMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RedditMessage(id: $id, type: $type, sender: ${sender.username})';
  }
}

class ChatRoom {
  final String id;
  final String name;
  final List<RedditUser> participants;
  final RedditMessage? lastMessage;
  final DateTime createdAt;
  final DateTime? lastActivity;
  final int unreadCount;
  final bool isMuted;
  final String? description;
  final String? avatarUrl;

  const ChatRoom({
    required this.id,
    required this.name,
    required this.participants,
    this.lastMessage,
    required this.createdAt,
    this.lastActivity,
    this.unreadCount = 0,
    this.isMuted = false,
    this.description,
    this.avatarUrl,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      participants: (json['participants'] as List?)
              ?.map((p) => RedditUser.fromJson(p))
              .toList() ??
          [],
      lastMessage: json['last_message'] != null
          ? RedditMessage.fromJson(json['last_message'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((json['created_utc'] ?? 0) * 1000).toInt(),
      ),
      lastActivity: json['last_activity'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              ((json['last_activity']) * 1000).toInt(),
            )
          : null,
      unreadCount: (json['unread_count'] ?? 0).toInt(),
      isMuted: json['is_muted'] ?? false,
      description: json['description'],
      avatarUrl: json['avatar_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message': lastMessage?.toJson(),
      'created_utc': createdAt.millisecondsSinceEpoch / 1000,
      'last_activity': lastActivity?.millisecondsSinceEpoch,
      'unread_count': unreadCount,
      'is_muted': isMuted,
      'description': description,
      'avatar_url': avatarUrl,
    };
  }

  ChatRoom copyWith({
    String? id,
    String? name,
    List<RedditUser>? participants,
    RedditMessage? lastMessage,
    DateTime? createdAt,
    DateTime? lastActivity,
    int? unreadCount,
    bool? isMuted,
    String? description,
    String? avatarUrl,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  String get lastActivityTime {
    final activity = lastActivity ?? createdAt;
    final now = DateTime.now();
    final difference = now.difference(activity);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  bool get hasUnreadMessages => unreadCount > 0;
  bool get isDirectMessage => participants.length == 2;
  
  String get displayName {
    if (isDirectMessage && participants.isNotEmpty) {
      return participants.first.username;
    }
    return name;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatRoom && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChatRoom(id: $id, name: $name, participants: ${participants.length})';
  }
}