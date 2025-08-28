enum ActivityType {
  deviceStateChange,
  routineTriggered,
  securityEvent,
  mediaPlayback,
  userAction,
  systemNotification,
}

enum ActivityPriority {
  low,
  medium,
  high,
  critical,
}

class Activity {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final ActivityPriority priority;
  final String? deviceId;
  final String? routineId;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;
  final bool isRead;

  const Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.priority,
    this.deviceId,
    this.routineId,
    required this.metadata,
    required this.timestamp,
    this.isRead = false,
  });

  Activity copyWith({
    String? id,
    ActivityType? type,
    String? title,
    String? description,
    ActivityPriority? priority,
    String? deviceId,
    String? routineId,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      deviceId: deviceId ?? this.deviceId,
      routineId: routineId ?? this.routineId,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'description': description,
      'priority': priority.name,
      'deviceId': deviceId,
      'routineId': routineId,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.systemNotification,
      ),
      title: json['title'] as String,
      description: json['description'] as String,
      priority: ActivityPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => ActivityPriority.low,
      ),
      deviceId: json['deviceId'] as String?,
      routineId: json['routineId'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  String get typeDisplayName {
    switch (type) {
      case ActivityType.deviceStateChange:
        return 'Device Update';
      case ActivityType.routineTriggered:
        return 'Routine';
      case ActivityType.securityEvent:
        return 'Security';
      case ActivityType.mediaPlayback:
        return 'Media';
      case ActivityType.userAction:
        return 'User Action';
      case ActivityType.systemNotification:
        return 'System';
    }
  }

  String get priorityDisplayName {
    switch (priority) {
      case ActivityPriority.low:
        return 'Low';
      case ActivityPriority.medium:
        return 'Medium';
      case ActivityPriority.high:
        return 'High';
      case ActivityPriority.critical:
        return 'Critical';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Activity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Activity(id: $id, type: $type, title: $title, priority: $priority)';
  }
}