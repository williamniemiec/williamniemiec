class Appointment {
  final String id;
  final String userId;
  final String type; // consulta, exame, procedimento
  final String specialty;
  final String description;
  final DateTime scheduledDate;
  final String scheduledTime;
  final String status;
  final String healthFacility;
  final String? doctor;
  final String? room;
  final String? notes;
  final String? cancellationReason;
  final bool isUrgent;
  final bool requiresFasting;
  final String? preparationInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.userId,
    required this.type,
    required this.specialty,
    required this.description,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.healthFacility,
    this.doctor,
    this.room,
    this.notes,
    this.cancellationReason,
    this.isUrgent = false,
    this.requiresFasting = false,
    this.preparationInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      specialty: json['specialty'] as String,
      description: json['description'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      scheduledTime: json['scheduledTime'] as String,
      status: json['status'] as String,
      healthFacility: json['healthFacility'] as String,
      doctor: json['doctor'] as String?,
      room: json['room'] as String?,
      notes: json['notes'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      isUrgent: json['isUrgent'] as bool? ?? false,
      requiresFasting: json['requiresFasting'] as bool? ?? false,
      preparationInstructions: json['preparationInstructions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'specialty': specialty,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'scheduledTime': scheduledTime,
      'status': status,
      'healthFacility': healthFacility,
      'doctor': doctor,
      'room': room,
      'notes': notes,
      'cancellationReason': cancellationReason,
      'isUrgent': isUrgent,
      'requiresFasting': requiresFasting,
      'preparationInstructions': preparationInstructions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isScheduled {
    return status.toLowerCase() == 'agendado' || 
           status.toLowerCase() == 'scheduled';
  }

  bool get isCompleted {
    return status.toLowerCase() == 'realizado' || 
           status.toLowerCase() == 'completed' ||
           status.toLowerCase() == 'concluído';
  }

  bool get isCancelled {
    return status.toLowerCase() == 'cancelado' || 
           status.toLowerCase() == 'cancelled';
  }

  bool get isConfirmed {
    return status.toLowerCase() == 'confirmado' || 
           status.toLowerCase() == 'confirmed';
  }

  bool get isPending {
    return status.toLowerCase() == 'pendente' || 
           status.toLowerCase() == 'pending';
  }

  String get statusDescription {
    switch (status.toLowerCase()) {
      case 'agendado':
      case 'scheduled':
        return 'Agendado';
      case 'confirmado':
      case 'confirmed':
        return 'Confirmado';
      case 'realizado':
      case 'completed':
      case 'concluído':
        return 'Realizado';
      case 'cancelado':
      case 'cancelled':
        return 'Cancelado';
      case 'pendente':
      case 'pending':
        return 'Pendente';
      case 'reagendado':
      case 'rescheduled':
        return 'Reagendado';
      default:
        return status;
    }
  }

  String get typeDescription {
    switch (type.toLowerCase()) {
      case 'consulta':
      case 'consultation':
        return 'Consulta';
      case 'exame':
      case 'exam':
        return 'Exame';
      case 'procedimento':
      case 'procedure':
        return 'Procedimento';
      case 'cirurgia':
      case 'surgery':
        return 'Cirurgia';
      case 'retorno':
      case 'follow_up':
        return 'Retorno';
      default:
        return type;
    }
  }

  String get formattedDate {
    return '${scheduledDate.day.toString().padLeft(2, '0')}/'
           '${scheduledDate.month.toString().padLeft(2, '0')}/'
           '${scheduledDate.year}';
  }

  String get formattedDateTime {
    return '$formattedDate às $scheduledTime';
  }

  String get weekDay {
    const weekDays = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo'
    ];
    return weekDays[scheduledDate.weekday - 1];
  }

  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
           scheduledDate.month == now.month &&
           scheduledDate.day == now.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return scheduledDate.year == tomorrow.year &&
           scheduledDate.month == tomorrow.month &&
           scheduledDate.day == tomorrow.day;
  }

  bool get isPast {
    return scheduledDate.isBefore(DateTime.now());
  }

  bool get isUpcoming {
    return scheduledDate.isAfter(DateTime.now());
  }

  int get daysUntilAppointment {
    final now = DateTime.now();
    final difference = scheduledDate.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  String get timeUntilAppointment {
    if (isPast) return 'Passou';
    if (isToday) return 'Hoje';
    if (isTomorrow) return 'Amanhã';
    
    final days = daysUntilAppointment;
    if (days == 1) return 'Em 1 dia';
    return 'Em $days dias';
  }

  Appointment copyWith({
    String? id,
    String? userId,
    String? type,
    String? specialty,
    String? description,
    DateTime? scheduledDate,
    String? scheduledTime,
    String? status,
    String? healthFacility,
    String? doctor,
    String? room,
    String? notes,
    String? cancellationReason,
    bool? isUrgent,
    bool? requiresFasting,
    String? preparationInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      specialty: specialty ?? this.specialty,
      description: description ?? this.description,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      status: status ?? this.status,
      healthFacility: healthFacility ?? this.healthFacility,
      doctor: doctor ?? this.doctor,
      room: room ?? this.room,
      notes: notes ?? this.notes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      isUrgent: isUrgent ?? this.isUrgent,
      requiresFasting: requiresFasting ?? this.requiresFasting,
      preparationInstructions: preparationInstructions ?? this.preparationInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Appointment(id: $id, type: $type, scheduledDate: $formattedDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Appointment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}