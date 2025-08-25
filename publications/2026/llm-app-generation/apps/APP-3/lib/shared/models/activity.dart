import 'package:hive/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 18)
class Activity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ActivityType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String? actorId;

  @HiveField(5)
  final String? actorName;

  @HiveField(6)
  final String? actorAvatarUrl;

  @HiveField(7)
  final String? targetId;

  @HiveField(8)
  final String? targetType;

  @HiveField(9)
  final String? targetName;

  @HiveField(10)
  final DateTime timestamp;

  @HiveField(11)
  final bool isRead;

  @HiveField(12)
  final ActivityPriority priority;

  @HiveField(13)
  final Map<String, dynamic>? metadata;

  Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.actorId,
    this.actorName,
    this.actorAvatarUrl,
    this.targetId,
    this.targetType,
    this.targetName,
    required this.timestamp,
    this.isRead = false,
    this.priority = ActivityPriority.normal,
    this.metadata,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => ActivityType.message,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      actorId: json['actorId'] as String?,
      actorName: json['actorName'] as String?,
      actorAvatarUrl: json['actorAvatarUrl'] as String?,
      targetId: json['targetId'] as String?,
      targetType: json['targetType'] as String?,
      targetName: json['targetName'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      priority: ActivityPriority.values.firstWhere(
        (e) => e.toString().split('.').last == json['priority'],
        orElse: () => ActivityPriority.normal,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'actorId': actorId,
      'actorName': actorName,
      'actorAvatarUrl': actorAvatarUrl,
      'targetId': targetId,
      'targetType': targetType,
      'targetName': targetName,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'priority': priority.toString().split('.').last,
      'metadata': metadata,
    };
  }

  Activity copyWith({
    String? id,
    ActivityType? type,
    String? title,
    String? description,
    String? actorId,
    String? actorName,
    String? actorAvatarUrl,
    String? targetId,
    String? targetType,
    String? targetName,
    DateTime? timestamp,
    bool? isRead,
    ActivityPriority? priority,
    Map<String, dynamic>? metadata,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      actorId: actorId ?? this.actorId,
      actorName: actorName ?? this.actorName,
      actorAvatarUrl: actorAvatarUrl ?? this.actorAvatarUrl,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      targetName: targetName ?? this.targetName,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
    );
  }
}

@HiveType(typeId: 19)
enum ActivityType {
  @HiveField(0)
  message,
  @HiveField(1)
  mention,
  @HiveField(2)
  reply,
  @HiveField(3)
  reaction,
  @HiveField(4)
  meeting,
  @HiveField(5)
  call,
  @HiveField(6)
  file,
  @HiveField(7)
  teamUpdate,
  @HiveField(8)
  channelUpdate,
  @HiveField(9)
  memberJoined,
  @HiveField(10)
  memberLeft,
  @HiveField(11)
  assignment,
  @HiveField(12)
  announcement,
}

@HiveType(typeId: 20)
enum ActivityPriority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high,
  @HiveField(3)
  urgent,
}