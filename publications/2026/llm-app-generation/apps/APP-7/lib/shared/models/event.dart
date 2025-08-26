class Event {
  final String id;
  final String title;
  final String description;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;
  final bool isAllDay;
  final EventType type;
  final EventCategory category;
  final String organizerId;
  final String organizerName;
  final String? organizerImageUrl;
  final List<String> targetAudience;
  final bool requiresRsvp;
  final int? maxAttendees;
  final List<EventAttendee> attendees;
  final List<EventAttachment> attachments;
  final EventRecurrence? recurrence;
  final String? meetingLink;
  final EventStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.location,
    required this.startDate,
    required this.endDate,
    this.isAllDay = false,
    required this.type,
    required this.category,
    required this.organizerId,
    required this.organizerName,
    this.organizerImageUrl,
    this.targetAudience = const [],
    this.requiresRsvp = false,
    this.maxAttendees,
    this.attendees = const [],
    this.attachments = const [],
    this.recurrence,
    this.meetingLink,
    this.status = EventStatus.active,
    required this.createdAt,
    required this.updatedAt,
  });

  int get attendeeCount => attendees.length;
  int get goingCount => attendees.where((a) => a.response == RsvpResponse.going).length;
  int get maybeCount => attendees.where((a) => a.response == RsvpResponse.maybe).length;
  int get notGoingCount => attendees.where((a) => a.response == RsvpResponse.notGoing).length;

  bool get isFull => maxAttendees != null && goingCount >= maxAttendees!;
  bool get isUpcoming => startDate.isAfter(DateTime.now());
  bool get isOngoing => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  bool get isPast => endDate.isBefore(DateTime.now());

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isAllDay: json['isAllDay'] ?? false,
      type: EventType.values.firstWhere((e) => e.name == json['type']),
      category: EventCategory.values.firstWhere((e) => e.name == json['category']),
      organizerId: json['organizerId'],
      organizerName: json['organizerName'],
      organizerImageUrl: json['organizerImageUrl'],
      targetAudience: List<String>.from(json['targetAudience'] ?? []),
      requiresRsvp: json['requiresRsvp'] ?? false,
      maxAttendees: json['maxAttendees'],
      attendees: (json['attendees'] as List<dynamic>?)
          ?.map((e) => EventAttendee.fromJson(e))
          .toList() ?? [],
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => EventAttachment.fromJson(e))
          .toList() ?? [],
      recurrence: json['recurrence'] != null 
          ? EventRecurrence.fromJson(json['recurrence']) 
          : null,
      meetingLink: json['meetingLink'],
      status: EventStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => EventStatus.active,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isAllDay': isAllDay,
      'type': type.name,
      'category': category.name,
      'organizerId': organizerId,
      'organizerName': organizerName,
      'organizerImageUrl': organizerImageUrl,
      'targetAudience': targetAudience,
      'requiresRsvp': requiresRsvp,
      'maxAttendees': maxAttendees,
      'attendees': attendees.map((e) => e.toJson()).toList(),
      'attachments': attachments.map((e) => e.toJson()).toList(),
      'recurrence': recurrence?.toJson(),
      'meetingLink': meetingLink,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class EventAttendee {
  final String userId;
  final String name;
  final String? imageUrl;
  final RsvpResponse response;
  final String? note;
  final DateTime respondedAt;

  EventAttendee({
    required this.userId,
    required this.name,
    this.imageUrl,
    required this.response,
    this.note,
    required this.respondedAt,
  });

  factory EventAttendee.fromJson(Map<String, dynamic> json) {
    return EventAttendee(
      userId: json['userId'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      response: RsvpResponse.values.firstWhere((e) => e.name == json['response']),
      note: json['note'],
      respondedAt: DateTime.parse(json['respondedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'response': response.name,
      'note': note,
      'respondedAt': respondedAt.toIso8601String(),
    };
  }
}

class EventAttachment {
  final String id;
  final String name;
  final String url;
  final AttachmentType type;
  final int? size;

  EventAttachment({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
    this.size,
  });

  factory EventAttachment.fromJson(Map<String, dynamic> json) {
    return EventAttachment(
      id: json['id'],
      name: json['name'],
      url: json['url'],
      type: AttachmentType.values.firstWhere((e) => e.name == json['type']),
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'type': type.name,
      'size': size,
    };
  }
}

class EventRecurrence {
  final RecurrenceType type;
  final int interval;
  final List<int>? daysOfWeek;
  final int? dayOfMonth;
  final DateTime? endDate;
  final int? occurrences;

  EventRecurrence({
    required this.type,
    this.interval = 1,
    this.daysOfWeek,
    this.dayOfMonth,
    this.endDate,
    this.occurrences,
  });

  factory EventRecurrence.fromJson(Map<String, dynamic> json) {
    return EventRecurrence(
      type: RecurrenceType.values.firstWhere((e) => e.name == json['type']),
      interval: json['interval'] ?? 1,
      daysOfWeek: json['daysOfWeek'] != null 
          ? List<int>.from(json['daysOfWeek']) 
          : null,
      dayOfMonth: json['dayOfMonth'],
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      occurrences: json['occurrences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'interval': interval,
      'daysOfWeek': daysOfWeek,
      'dayOfMonth': dayOfMonth,
      'endDate': endDate?.toIso8601String(),
      'occurrences': occurrences,
    };
  }
}

enum EventType {
  meeting,
  conference,
  workshop,
  social,
  sports,
  academic,
  fundraiser,
  volunteer,
}

enum EventCategory {
  school,
  district,
  classroom,
  extracurricular,
  parent,
  community,
}

enum EventStatus {
  active,
  cancelled,
  postponed,
  completed,
}

enum RsvpResponse {
  going,
  maybe,
  notGoing,
  pending,
}

enum RecurrenceType {
  daily,
  weekly,
  monthly,
  yearly,
}

enum AttachmentType {
  document,
  image,
  link,
}