import 'package:uuid/uuid.dart';
import 'user.dart';
import 'thread.dart';

enum ActivityType {
  like,
  reply,
  repost,
  quote,
  follow,
  mention,
}

class Activity {
  final String id;
  final ActivityType type;
  final User actor; // The user who performed the action
  final User? target; // The user who is the target of the action (for follows)
  final Thread? thread; // The thread involved in the action
  final String? content; // Additional content (e.g., reply text)
  final bool isRead;
  final DateTime createdAt;

  const Activity({
    required this.id,
    required this.type,
    required this.actor,
    this.target,
    this.thread,
    this.content,
    this.isRead = false,
    required this.createdAt,
  });

  factory Activity.create({
    required ActivityType type,
    required User actor,
    User? target,
    Thread? thread,
    String? content,
  }) {
    return Activity(
      id: const Uuid().v4(),
      type: type,
      actor: actor,
      target: target,
      thread: thread,
      content: content,
      createdAt: DateTime.now(),
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.like,
      ),
      actor: User.fromJson(json['actor'] as Map<String, dynamic>),
      target: json['target'] != null
          ? User.fromJson(json['target'] as Map<String, dynamic>)
          : null,
      thread: json['thread'] != null
          ? Thread.fromJson(json['thread'] as Map<String, dynamic>)
          : null,
      content: json['content'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'actor': actor.toJson(),
      'target': target?.toJson(),
      'thread': thread?.toJson(),
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Activity copyWith({
    String? id,
    ActivityType? type,
    User? actor,
    User? target,
    Thread? thread,
    String? content,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      actor: actor ?? this.actor,
      target: target ?? this.target,
      thread: thread ?? this.thread,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get actionText {
    switch (type) {
      case ActivityType.like:
        return 'liked your thread';
      case ActivityType.reply:
        return 'replied to your thread';
      case ActivityType.repost:
        return 'reposted your thread';
      case ActivityType.quote:
        return 'quoted your thread';
      case ActivityType.follow:
        return 'started following you';
      case ActivityType.mention:
        return 'mentioned you in a thread';
    }
  }

  bool get isThreadAction => [
        ActivityType.like,
        ActivityType.reply,
        ActivityType.repost,
        ActivityType.quote,
        ActivityType.mention,
      ].contains(type);

  bool get isFollowAction => type == ActivityType.follow;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Activity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Activity(id: $id, type: $type, actor: ${actor.username})';
  }
}