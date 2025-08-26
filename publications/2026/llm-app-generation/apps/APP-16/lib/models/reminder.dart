enum ReminderFrequency {
  daily,
  weekly,
  custom,
}

extension ReminderFrequencyExtension on ReminderFrequency {
  String get displayName {
    switch (this) {
      case ReminderFrequency.daily:
        return 'Daily';
      case ReminderFrequency.weekly:
        return 'Weekly';
      case ReminderFrequency.custom:
        return 'Custom';
    }
  }
}

class Reminder {
  final int? id;
  final String title;
  final String? description;
  final DateTime time;
  final ReminderFrequency frequency;
  final bool isActive;
  final List<int> daysOfWeek; // 1-7, Monday to Sunday
  final DateTime createdAt;
  final DateTime updatedAt;

  Reminder({
    this.id,
    required this.title,
    this.description,
    required this.time,
    required this.frequency,
    this.isActive = true,
    this.daysOfWeek = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time.millisecondsSinceEpoch,
      'frequency': frequency.index,
      'isActive': isActive ? 1 : 0,
      'daysOfWeek': daysOfWeek.join(','),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Create from Map (database)
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
      frequency: ReminderFrequency.values[map['frequency']],
      isActive: map['isActive'] == 1,
      daysOfWeek: map['daysOfWeek'] != null && map['daysOfWeek'].isNotEmpty
          ? map['daysOfWeek'].split(',').map<int>((e) => int.parse(e)).toList()
          : [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  // Copy with method for updates
  Reminder copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? time,
    ReminderFrequency? frequency,
    bool? isActive,
    List<int>? daysOfWeek,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      frequency: frequency ?? this.frequency,
      isActive: isActive ?? this.isActive,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Reminder(id: $id, title: $title, description: $description, time: $time, frequency: $frequency, isActive: $isActive, daysOfWeek: $daysOfWeek, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reminder &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.time == time &&
        other.frequency == frequency &&
        other.isActive == isActive &&
        other.daysOfWeek.toString() == daysOfWeek.toString() &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        time.hashCode ^
        frequency.hashCode ^
        isActive.hashCode ^
        daysOfWeek.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}