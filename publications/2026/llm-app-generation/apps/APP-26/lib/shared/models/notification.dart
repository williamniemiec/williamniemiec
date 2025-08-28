import 'package:hive/hive.dart';
import 'user.dart';
import 'post.dart';

part 'notification.g.dart';

@HiveType(typeId: 9)
class XNotification extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final NotificationType type;

  @HiveField(3)
  final String title;

  @HiveField(4)
  final String message;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final bool isRead;

  @HiveField(7)
  final String? actorId;

  @HiveField(8)
  final User? actor;

  @HiveField(9)
  final String? postId;

  @HiveField(10)
  final Post? post;

  @HiveField(11)
  final Map<String, dynamic>? metadata;

  XNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.isRead = false,
    this.actorId,
    this.actor,
    this.postId,
    this.post,
    this.metadata,
  });

  XNotification copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
    String? actorId,
    User? actor,
    String? postId,
    Post? post,
    Map<String, dynamic>? metadata,
  }) {
    return XNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actorId: actorId ?? this.actorId,
      actor: actor ?? this.actor,
      postId: postId ?? this.postId,
      post: post ?? this.post,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'actorId': actorId,
      'actor': actor?.toJson(),
      'postId': postId,
      'post': post?.toJson(),
      'metadata': metadata,
    };
  }

  factory XNotification.fromJson(Map<String, dynamic> json) {
    return XNotification(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.like,
      ),
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      actorId: json['actorId'] as String?,
      actor: json['actor'] != null 
          ? User.fromJson(json['actor'] as Map<String, dynamic>)
          : null,
      postId: json['postId'] as String?,
      post: json['post'] != null 
          ? Post.fromJson(json['post'] as Map<String, dynamic>)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is XNotification && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'XNotification(id: $id, type: $type, isRead: $isRead)';
  }
}

@HiveType(typeId: 10)
enum NotificationType {
  @HiveField(0)
  like,
  @HiveField(1)
  repost,
  @HiveField(2)
  reply,
  @HiveField(3)
  follow,
  @HiveField(4)
  mention,
  @HiveField(5)
  quote,
  @HiveField(6)
  message,
  @HiveField(7)
  communityInvite,
  @HiveField(8)
  spaceInvite,
  @HiveField(9)
  premium,
  @HiveField(10)
  system,
}