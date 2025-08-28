enum AppointmentStatus {
  scheduled,
  confirmed,
  cancelled,
  completed,
  noShow,
}

enum AppointmentType {
  inPerson,
  video,
  phone,
}

class Appointment {
  final String id;
  final String patientId;
  final String providerId;
  final String providerName;
  final String department;
  final String reason;
  final DateTime dateTime;
  final int durationMinutes;
  final AppointmentType type;
  final AppointmentStatus status;
  final String? location;
  final String? notes;
  final bool canCancel;
  final bool canReschedule;
  final bool eCheckInAvailable;
  final DateTime? eCheckInDeadline;

  Appointment({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.providerName,
    required this.department,
    required this.reason,
    required this.dateTime,
    this.durationMinutes = 30,
    this.type = AppointmentType.inPerson,
    this.status = AppointmentStatus.scheduled,
    this.location,
    this.notes,
    this.canCancel = true,
    this.canReschedule = true,
    this.eCheckInAvailable = true,
    this.eCheckInDeadline,
  });

  bool get isUpcoming => dateTime.isAfter(DateTime.now());
  bool get isPast => dateTime.isBefore(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }

  bool get canCheckIn {
    if (!eCheckInAvailable || status != AppointmentStatus.scheduled) {
      return false;
    }
    
    final now = DateTime.now();
    final checkInWindow = dateTime.subtract(const Duration(hours: 24));
    final deadline = eCheckInDeadline ?? dateTime.subtract(const Duration(hours: 1));
    
    return now.isAfter(checkInWindow) && now.isBefore(deadline);
  }

  String get statusDisplayName {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.noShow:
        return 'No Show';
    }
  }

  String get typeDisplayName {
    switch (type) {
      case AppointmentType.inPerson:
        return 'In-Person';
      case AppointmentType.video:
        return 'Video Visit';
      case AppointmentType.phone:
        return 'Phone Call';
    }
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? '',
      department: json['department'] ?? '',
      reason: json['reason'] ?? '',
      dateTime: DateTime.parse(json['dateTime']),
      durationMinutes: json['durationMinutes'] ?? 30,
      type: AppointmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AppointmentType.inPerson,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.scheduled,
      ),
      location: json['location'],
      notes: json['notes'],
      canCancel: json['canCancel'] ?? true,
      canReschedule: json['canReschedule'] ?? true,
      eCheckInAvailable: json['eCheckInAvailable'] ?? true,
      eCheckInDeadline: json['eCheckInDeadline'] != null
          ? DateTime.parse(json['eCheckInDeadline'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'providerName': providerName,
      'department': department,
      'reason': reason,
      'dateTime': dateTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'type': type.name,
      'status': status.name,
      'location': location,
      'notes': notes,
      'canCancel': canCancel,
      'canReschedule': canReschedule,
      'eCheckInAvailable': eCheckInAvailable,
      'eCheckInDeadline': eCheckInDeadline?.toIso8601String(),
    };
  }
}