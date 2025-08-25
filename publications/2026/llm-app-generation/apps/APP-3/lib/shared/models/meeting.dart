import 'package:hive/hive.dart';

part 'meeting.g.dart';

@HiveType(typeId: 15)
class Meeting extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String organizerId;

  @HiveField(4)
  final List<String> participantIds;

  @HiveField(5)
  final List<String> requiredAttendeeIds;

  @HiveField(6)
  final List<String> optionalAttendeeIds;

  @HiveField(7)
  final DateTime startTime;

  @HiveField(8)
  final DateTime endTime;

  @HiveField(9)
  final String? location;

  @HiveField(10)
  final String? meetingUrl;

  @HiveField(11)
  final String? dialInNumber;

  @HiveField(12)
  final String? conferenceId;

  @HiveField(13)
  final MeetingType type;

  @HiveField(14)
  final MeetingStatus status;

  @HiveField(15)
  final bool isRecurring;

  @HiveField(16)
  final String? recurrencePattern;

  @HiveField(17)
  final bool allowRecording;

  @HiveField(18)
  final bool isRecording;

  @HiveField(19)
  final String? recordingUrl;

  @HiveField(20)
  final bool requiresPassword;

  @HiveField(21)
  final String? password;

  @HiveField(22)
  final bool allowScreenSharing;

  @HiveField(23)
  final bool allowChat;

  @HiveField(24)
  final bool muteParticipantsOnEntry;

  @HiveField(25)
  final DateTime createdAt;

  @HiveField(26)
  final DateTime updatedAt;

  @HiveField(27)
  final Map<String, dynamic>? metadata;

  Meeting({
    required this.id,
    required this.title,
    this.description,
    required this.organizerId,
    this.participantIds = const [],
    this.requiredAttendeeIds = const [],
    this.optionalAttendeeIds = const [],
    required this.startTime,
    required this.endTime,
    this.location,
    this.meetingUrl,
    this.dialInNumber,
    this.conferenceId,
    this.type = MeetingType.scheduled,
    this.status = MeetingStatus.scheduled,
    this.isRecurring = false,
    this.recurrencePattern,
    this.allowRecording = true,
    this.isRecording = false,
    this.recordingUrl,
    this.requiresPassword = false,
    this.password,
    this.allowScreenSharing = true,
    this.allowChat = true,
    this.muteParticipantsOnEntry = false,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      organizerId: json['organizerId'] as String,
      participantIds: List<String>.from(json['participantIds'] as List? ?? []),
      requiredAttendeeIds: List<String>.from(json['requiredAttendeeIds'] as List? ?? []),
      optionalAttendeeIds: List<String>.from(json['optionalAttendeeIds'] as List? ?? []),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String?,
      meetingUrl: json['meetingUrl'] as String?,
      dialInNumber: json['dialInNumber'] as String?,
      conferenceId: json['conferenceId'] as String?,
      type: MeetingType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MeetingType.scheduled,
      ),
      status: MeetingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => MeetingStatus.scheduled,
      ),
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrencePattern: json['recurrencePattern'] as String?,
      allowRecording: json['allowRecording'] as bool? ?? true,
      isRecording: json['isRecording'] as bool? ?? false,
      recordingUrl: json['recordingUrl'] as String?,
      requiresPassword: json['requiresPassword'] as bool? ?? false,
      password: json['password'] as String?,
      allowScreenSharing: json['allowScreenSharing'] as bool? ?? true,
      allowChat: json['allowChat'] as bool? ?? true,
      muteParticipantsOnEntry: json['muteParticipantsOnEntry'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'organizerId': organizerId,
      'participantIds': participantIds,
      'requiredAttendeeIds': requiredAttendeeIds,
      'optionalAttendeeIds': optionalAttendeeIds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'meetingUrl': meetingUrl,
      'dialInNumber': dialInNumber,
      'conferenceId': conferenceId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'isRecurring': isRecurring,
      'recurrencePattern': recurrencePattern,
      'allowRecording': allowRecording,
      'isRecording': isRecording,
      'recordingUrl': recordingUrl,
      'requiresPassword': requiresPassword,
      'password': password,
      'allowScreenSharing': allowScreenSharing,
      'allowChat': allowChat,
      'muteParticipantsOnEntry': muteParticipantsOnEntry,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  Meeting copyWith({
    String? id,
    String? title,
    String? description,
    String? organizerId,
    List<String>? participantIds,
    List<String>? requiredAttendeeIds,
    List<String>? optionalAttendeeIds,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? meetingUrl,
    String? dialInNumber,
    String? conferenceId,
    MeetingType? type,
    MeetingStatus? status,
    bool? isRecurring,
    String? recurrencePattern,
    bool? allowRecording,
    bool? isRecording,
    String? recordingUrl,
    bool? requiresPassword,
    String? password,
    bool? allowScreenSharing,
    bool? allowChat,
    bool? muteParticipantsOnEntry,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Meeting(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      organizerId: organizerId ?? this.organizerId,
      participantIds: participantIds ?? this.participantIds,
      requiredAttendeeIds: requiredAttendeeIds ?? this.requiredAttendeeIds,
      optionalAttendeeIds: optionalAttendeeIds ?? this.optionalAttendeeIds,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      meetingUrl: meetingUrl ?? this.meetingUrl,
      dialInNumber: dialInNumber ?? this.dialInNumber,
      conferenceId: conferenceId ?? this.conferenceId,
      type: type ?? this.type,
      status: status ?? this.status,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      allowRecording: allowRecording ?? this.allowRecording,
      isRecording: isRecording ?? this.isRecording,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      requiresPassword: requiresPassword ?? this.requiresPassword,
      password: password ?? this.password,
      allowScreenSharing: allowScreenSharing ?? this.allowScreenSharing,
      allowChat: allowChat ?? this.allowChat,
      muteParticipantsOnEntry: muteParticipantsOnEntry ?? this.muteParticipantsOnEntry,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  Duration get duration => endTime.difference(startTime);
  
  bool get isActive => status == MeetingStatus.inProgress;
  
  bool get isUpcoming => status == MeetingStatus.scheduled && 
                        startTime.isAfter(DateTime.now());
  
  bool get hasStarted => DateTime.now().isAfter(startTime);
  
  bool get hasEnded => DateTime.now().isAfter(endTime);

  int get totalAttendees => requiredAttendeeIds.length + 
                           optionalAttendeeIds.length + 
                           participantIds.length;
}

@HiveType(typeId: 16)
enum MeetingType {
  @HiveField(0)
  scheduled,
  @HiveField(1)
  instant,
  @HiveField(2)
  recurring,
  @HiveField(3)
  webinar,
}

@HiveType(typeId: 17)
enum MeetingStatus {
  @HiveField(0)
  scheduled,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  ended,
  @HiveField(3)
  cancelled,
  @HiveField(4)
  postponed,
}