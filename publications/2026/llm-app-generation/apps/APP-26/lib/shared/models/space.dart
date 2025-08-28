import 'package:hive/hive.dart';
import 'user.dart';

part 'space.g.dart';

@HiveType(typeId: 11)
class Space extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String hostId;

  @HiveField(4)
  final User host;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime? scheduledFor;

  @HiveField(7)
  final DateTime? startedAt;

  @HiveField(8)
  final DateTime? endedAt;

  @HiveField(9)
  final SpaceState state;

  @HiveField(10)
  final List<String> speakerIds;

  @HiveField(11)
  final List<User> speakers;

  @HiveField(12)
  final List<String> listenerIds;

  @HiveField(13)
  final int listenersCount;

  @HiveField(14)
  final bool isRecorded;

  @HiveField(15)
  final bool isPublic;

  @HiveField(16)
  final List<String> topics;

  @HiveField(17)
  final String? recordingUrl;

  @HiveField(18)
  final Map<String, dynamic>? metadata;

  Space({
    required this.id,
    required this.title,
    this.description,
    required this.hostId,
    required this.host,
    required this.createdAt,
    this.scheduledFor,
    this.startedAt,
    this.endedAt,
    required this.state,
    this.speakerIds = const [],
    this.speakers = const [],
    this.listenerIds = const [],
    this.listenersCount = 0,
    this.isRecorded = false,
    this.isPublic = true,
    this.topics = const [],
    this.recordingUrl,
    this.metadata,
  });

  Space copyWith({
    String? id,
    String? title,
    String? description,
    String? hostId,
    User? host,
    DateTime? createdAt,
    DateTime? scheduledFor,
    DateTime? startedAt,
    DateTime? endedAt,
    SpaceState? state,
    List<String>? speakerIds,
    List<User>? speakers,
    List<String>? listenerIds,
    int? listenersCount,
    bool? isRecorded,
    bool? isPublic,
    List<String>? topics,
    String? recordingUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Space(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      hostId: hostId ?? this.hostId,
      host: host ?? this.host,
      createdAt: createdAt ?? this.createdAt,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      state: state ?? this.state,
      speakerIds: speakerIds ?? this.speakerIds,
      speakers: speakers ?? this.speakers,
      listenerIds: listenerIds ?? this.listenerIds,
      listenersCount: listenersCount ?? this.listenersCount,
      isRecorded: isRecorded ?? this.isRecorded,
      isPublic: isPublic ?? this.isPublic,
      topics: topics ?? this.topics,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'hostId': hostId,
      'host': host.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'scheduledFor': scheduledFor?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'state': state.name,
      'speakerIds': speakerIds,
      'speakers': speakers.map((s) => s.toJson()).toList(),
      'listenerIds': listenerIds,
      'listenersCount': listenersCount,
      'isRecorded': isRecorded,
      'isPublic': isPublic,
      'topics': topics,
      'recordingUrl': recordingUrl,
      'metadata': metadata,
    };
  }

  factory Space.fromJson(Map<String, dynamic> json) {
    return Space(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      hostId: json['hostId'] as String,
      host: User.fromJson(json['host'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledFor: json['scheduledFor'] != null 
          ? DateTime.parse(json['scheduledFor'] as String)
          : null,
      startedAt: json['startedAt'] != null 
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      endedAt: json['endedAt'] != null 
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      state: SpaceState.values.firstWhere(
        (e) => e.name == json['state'],
        orElse: () => SpaceState.scheduled,
      ),
      speakerIds: List<String>.from(json['speakerIds'] as List? ?? []),
      speakers: (json['speakers'] as List? ?? [])
          .map((s) => User.fromJson(s as Map<String, dynamic>))
          .toList(),
      listenerIds: List<String>.from(json['listenerIds'] as List? ?? []),
      listenersCount: json['listenersCount'] as int? ?? 0,
      isRecorded: json['isRecorded'] as bool? ?? false,
      isPublic: json['isPublic'] as bool? ?? true,
      topics: List<String>.from(json['topics'] as List? ?? []),
      recordingUrl: json['recordingUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  bool get isLive => state == SpaceState.live;
  bool get isScheduled => state == SpaceState.scheduled;
  bool get isEnded => state == SpaceState.ended;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Space && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Space(id: $id, title: $title, state: $state)';
  }
}

@HiveType(typeId: 12)
enum SpaceState {
  @HiveField(0)
  scheduled,
  @HiveField(1)
  live,
  @HiveField(2)
  ended,
  @HiveField(3)
  cancelled,
}