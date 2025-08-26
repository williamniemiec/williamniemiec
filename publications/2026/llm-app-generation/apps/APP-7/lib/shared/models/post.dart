class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String authorRole;
  final String? authorImageUrl;
  final String title;
  final String content;
  final List<PostAttachment> attachments;
  final PostType type;
  final PostAudience audience;
  final List<String> targetGroups;
  final bool isUrgent;
  final bool allowComments;
  final bool requiresTranslation;
  final List<PostInteraction> interactions;
  final int appreciationCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? scheduledAt;
  final PostStatus status;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorRole,
    this.authorImageUrl,
    required this.title,
    required this.content,
    this.attachments = const [],
    required this.type,
    required this.audience,
    this.targetGroups = const [],
    this.isUrgent = false,
    this.allowComments = true,
    this.requiresTranslation = true,
    this.interactions = const [],
    this.appreciationCount = 0,
    this.commentCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledAt,
    this.status = PostStatus.published,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorRole: json['authorRole'],
      authorImageUrl: json['authorImageUrl'],
      title: json['title'],
      content: json['content'],
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => PostAttachment.fromJson(e))
          .toList() ?? [],
      type: PostType.values.firstWhere((e) => e.name == json['type']),
      audience: PostAudience.values.firstWhere((e) => e.name == json['audience']),
      targetGroups: List<String>.from(json['targetGroups'] ?? []),
      isUrgent: json['isUrgent'] ?? false,
      allowComments: json['allowComments'] ?? true,
      requiresTranslation: json['requiresTranslation'] ?? true,
      interactions: (json['interactions'] as List<dynamic>?)
          ?.map((e) => PostInteraction.fromJson(e))
          .toList() ?? [],
      appreciationCount: json['appreciationCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      scheduledAt: json['scheduledAt'] != null ? DateTime.parse(json['scheduledAt']) : null,
      status: PostStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PostStatus.published,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'authorImageUrl': authorImageUrl,
      'title': title,
      'content': content,
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'type': type.name,
      'audience': audience.name,
      'targetGroups': targetGroups,
      'isUrgent': isUrgent,
      'allowComments': allowComments,
      'requiresTranslation': requiresTranslation,
      'interactions': interactions.map((e) => e.toJson()).toList(),
      'appreciationCount': appreciationCount,
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'scheduledAt': scheduledAt?.toIso8601String(),
      'status': status.name,
    };
  }
}

class PostAttachment {
  final String id;
  final String name;
  final String url;
  final AttachmentType type;
  final int? size;
  final String? mimeType;

  PostAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    this.size,
    this.mimeType,
  });

  factory PostAttachment.fromJson(Map<String, dynamic> json) {
    return PostAttachment(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: AttachmentType.values.firstWhere((e) => e.name == json['type']),
      size: json['size'],
      mimeType: json['mimeType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type.name,
      'size': size,
      'mimeType': mimeType,
    };
  }
}

class PostInteraction {
  final String id;
  final String userId;
  final String userName;
  final InteractionType type;
  final String? content;
  final DateTime createdAt;

  PostInteraction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.type,
    this.content,
    required this.createdAt,
  });

  factory PostInteraction.fromJson(Map<String, dynamic> json) {
    return PostInteraction(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      type: InteractionType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'type': type.name,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum PostType {
  announcement,
  alert,
  event,
  form,
  signUp,
  poll,
  media,
}

enum PostAudience {
  district,
  school,
  grade,
  classroom,
  group,
}

enum PostStatus {
  draft,
  scheduled,
  published,
  archived,
}

enum AttachmentType {
  image,
  video,
  document,
  audio,
  link,
}

enum InteractionType {
  appreciation,
  comment,
  rsvp,
  signUp,
  pollResponse,
}