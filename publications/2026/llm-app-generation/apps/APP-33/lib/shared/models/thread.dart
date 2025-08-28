import 'package:uuid/uuid.dart';
import 'user.dart';

enum ThreadType {
  original,
  reply,
  repost,
  quote,
}

class MediaAttachment {
  final String id;
  final String url;
  final String type; // 'image', 'video'
  final String? thumbnailUrl;
  final double? aspectRatio;
  final int? width;
  final int? height;

  const MediaAttachment({
    required this.id,
    required this.url,
    required this.type,
    this.thumbnailUrl,
    this.aspectRatio,
    this.width,
    this.height,
  });

  factory MediaAttachment.fromJson(Map<String, dynamic> json) {
    return MediaAttachment(
      id: json['id'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      aspectRatio: json['aspectRatio'] as double?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
      'thumbnailUrl': thumbnailUrl,
      'aspectRatio': aspectRatio,
      'width': width,
      'height': height,
    };
  }
}

class Thread {
  final String id;
  final String content;
  final User author;
  final ThreadType type;
  final List<MediaAttachment> attachments;
  final int likesCount;
  final int repliesCount;
  final int repostsCount;
  final int quotesCount;
  final bool isLiked;
  final bool isReposted;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // For replies and quotes
  final String? parentThreadId;
  final Thread? parentThread;
  
  // For quotes and reposts
  final String? quotedThreadId;
  final Thread? quotedThread;
  
  // Thread chain (for conversation threading)
  final List<Thread>? replies;

  const Thread({
    required this.id,
    required this.content,
    required this.author,
    this.type = ThreadType.original,
    this.attachments = const [],
    this.likesCount = 0,
    this.repliesCount = 0,
    this.repostsCount = 0,
    this.quotesCount = 0,
    this.isLiked = false,
    this.isReposted = false,
    required this.createdAt,
    this.updatedAt,
    this.parentThreadId,
    this.parentThread,
    this.quotedThreadId,
    this.quotedThread,
    this.replies,
  });

  factory Thread.create({
    required String content,
    required User author,
    List<MediaAttachment> attachments = const [],
    ThreadType type = ThreadType.original,
    String? parentThreadId,
    Thread? parentThread,
    String? quotedThreadId,
    Thread? quotedThread,
  }) {
    return Thread(
      id: const Uuid().v4(),
      content: content,
      author: author,
      type: type,
      attachments: attachments,
      createdAt: DateTime.now(),
      parentThreadId: parentThreadId,
      parentThread: parentThread,
      quotedThreadId: quotedThreadId,
      quotedThread: quotedThread,
    );
  }

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'] as String,
      content: json['content'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      type: ThreadType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ThreadType.original,
      ),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => MediaAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      likesCount: json['likesCount'] as int? ?? 0,
      repliesCount: json['repliesCount'] as int? ?? 0,
      repostsCount: json['repostsCount'] as int? ?? 0,
      quotesCount: json['quotesCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isReposted: json['isReposted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      parentThreadId: json['parentThreadId'] as String?,
      parentThread: json['parentThread'] != null
          ? Thread.fromJson(json['parentThread'] as Map<String, dynamic>)
          : null,
      quotedThreadId: json['quotedThreadId'] as String?,
      quotedThread: json['quotedThread'] != null
          ? Thread.fromJson(json['quotedThread'] as Map<String, dynamic>)
          : null,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Thread.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author.toJson(),
      'type': type.name,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'likesCount': likesCount,
      'repliesCount': repliesCount,
      'repostsCount': repostsCount,
      'quotesCount': quotesCount,
      'isLiked': isLiked,
      'isReposted': isReposted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'parentThreadId': parentThreadId,
      'parentThread': parentThread?.toJson(),
      'quotedThreadId': quotedThreadId,
      'quotedThread': quotedThread?.toJson(),
      'replies': replies?.map((e) => e.toJson()).toList(),
    };
  }

  Thread copyWith({
    String? id,
    String? content,
    User? author,
    ThreadType? type,
    List<MediaAttachment>? attachments,
    int? likesCount,
    int? repliesCount,
    int? repostsCount,
    int? quotesCount,
    bool? isLiked,
    bool? isReposted,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentThreadId,
    Thread? parentThread,
    String? quotedThreadId,
    Thread? quotedThread,
    List<Thread>? replies,
  }) {
    return Thread(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      type: type ?? this.type,
      attachments: attachments ?? this.attachments,
      likesCount: likesCount ?? this.likesCount,
      repliesCount: repliesCount ?? this.repliesCount,
      repostsCount: repostsCount ?? this.repostsCount,
      quotesCount: quotesCount ?? this.quotesCount,
      isLiked: isLiked ?? this.isLiked,
      isReposted: isReposted ?? this.isReposted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentThreadId: parentThreadId ?? this.parentThreadId,
      parentThread: parentThread ?? this.parentThread,
      quotedThreadId: quotedThreadId ?? this.quotedThreadId,
      quotedThread: quotedThread ?? this.quotedThread,
      replies: replies ?? this.replies,
    );
  }

  bool get isReply => type == ThreadType.reply;
  bool get isRepost => type == ThreadType.repost;
  bool get isQuote => type == ThreadType.quote;
  bool get hasAttachments => attachments.isNotEmpty;
  bool get hasReplies => replies != null && replies!.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Thread && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Thread(id: $id, content: ${content.length > 50 ? '${content.substring(0, 50)}...' : content}, author: ${author.username})';
  }
}