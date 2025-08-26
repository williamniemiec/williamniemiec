import 'package:intl/intl.dart';

enum BloodPressureCategory {
  normal,
  elevated,
  hypertensionStage1,
  hypertensionStage2,
  hypertensiveCrisis,
}

extension BloodPressureCategoryExtension on BloodPressureCategory {
  String get displayName {
    switch (this) {
      case BloodPressureCategory.normal:
        return 'Normal';
      case BloodPressureCategory.elevated:
        return 'Elevated';
      case BloodPressureCategory.hypertensionStage1:
        return 'Hypertension Stage 1';
      case BloodPressureCategory.hypertensionStage2:
        return 'Hypertension Stage 2';
      case BloodPressureCategory.hypertensiveCrisis:
        return 'Hypertensive Crisis';
    }
  }

  String get description {
    switch (this) {
      case BloodPressureCategory.normal:
        return 'Less than 120/80 mmHg';
      case BloodPressureCategory.elevated:
        return '120-129 systolic and less than 80 diastolic';
      case BloodPressureCategory.hypertensionStage1:
        return '130-139 systolic or 80-89 diastolic';
      case BloodPressureCategory.hypertensionStage2:
        return '140/90 mmHg or higher';
      case BloodPressureCategory.hypertensiveCrisis:
        return 'Higher than 180/120 mmHg';
    }
  }

  String get colorHex {
    switch (this) {
      case BloodPressureCategory.normal:
        return '#4CAF50'; // Green
      case BloodPressureCategory.elevated:
        return '#FF9800'; // Orange
      case BloodPressureCategory.hypertensionStage1:
        return '#FF5722'; // Deep Orange
      case BloodPressureCategory.hypertensionStage2:
        return '#F44336'; // Red
      case BloodPressureCategory.hypertensiveCrisis:
        return '#9C27B0'; // Purple
    }
  }
}

class BloodPressureReading {
  final int? id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime dateTime;
  final List<String> tags;
  final String? notes;
  final BloodPressureCategory category;

  BloodPressureReading({
    this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.dateTime,
    this.tags = const [],
    this.notes,
    required this.category,
  });

  // Factory constructor to create reading with automatic categorization
  factory BloodPressureReading.create({
    int? id,
    required int systolic,
    required int diastolic,
    required int pulse,
    required DateTime dateTime,
    List<String> tags = const [],
    String? notes,
  }) {
    final category = _categorizeBloodPressure(systolic, diastolic);
    return BloodPressureReading(
      id: id,
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
      dateTime: dateTime,
      tags: tags,
      notes: notes,
      category: category,
    );
  }

  // Static method to categorize blood pressure
  static BloodPressureCategory _categorizeBloodPressure(int systolic, int diastolic) {
    if (systolic >= 180 || diastolic >= 120) {
      return BloodPressureCategory.hypertensiveCrisis;
    } else if (systolic >= 140 || diastolic >= 90) {
      return BloodPressureCategory.hypertensionStage2;
    } else if ((systolic >= 130 && systolic <= 139) || (diastolic >= 80 && diastolic <= 89)) {
      return BloodPressureCategory.hypertensionStage1;
    } else if (systolic >= 120 && systolic <= 129 && diastolic < 80) {
      return BloodPressureCategory.elevated;
    } else {
      return BloodPressureCategory.normal;
    }
  }

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'tags': tags.join(','),
      'notes': notes,
      'category': category.index,
    };
  }

  // Create from Map (database)
  factory BloodPressureReading.fromMap(Map<String, dynamic> map) {
    return BloodPressureReading(
      id: map['id'],
      systolic: map['systolic'],
      diastolic: map['diastolic'],
      pulse: map['pulse'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime']),
      tags: map['tags'] != null && map['tags'].isNotEmpty 
          ? map['tags'].split(',') 
          : [],
      notes: map['notes'],
      category: BloodPressureCategory.values[map['category']],
    );
  }

  // Copy with method for updates
  BloodPressureReading copyWith({
    int? id,
    int? systolic,
    int? diastolic,
    int? pulse,
    DateTime? dateTime,
    List<String>? tags,
    String? notes,
    BloodPressureCategory? category,
  }) {
    return BloodPressureReading(
      id: id ?? this.id,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      pulse: pulse ?? this.pulse,
      dateTime: dateTime ?? this.dateTime,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      category: category ?? this.category,
    );
  }

  // Formatted date string
  String get formattedDate => DateFormat('MMM dd, yyyy').format(dateTime);
  
  // Formatted time string
  String get formattedTime => DateFormat('HH:mm').format(dateTime);
  
  // Formatted date and time string
  String get formattedDateTime => DateFormat('MMM dd, yyyy HH:mm').format(dateTime);

  // Blood pressure display string
  String get bpDisplay => '$systolic/$diastolic';

  @override
  String toString() {
    return 'BloodPressureReading(id: $id, systolic: $systolic, diastolic: $diastolic, pulse: $pulse, dateTime: $dateTime, tags: $tags, notes: $notes, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BloodPressureReading &&
        other.id == id &&
        other.systolic == systolic &&
        other.diastolic == diastolic &&
        other.pulse == pulse &&
        other.dateTime == dateTime &&
        other.tags.toString() == tags.toString() &&
        other.notes == notes &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        systolic.hashCode ^
        diastolic.hashCode ^
        pulse.hashCode ^
        dateTime.hashCode ^
        tags.hashCode ^
        notes.hashCode ^
        category.hashCode;
  }
}