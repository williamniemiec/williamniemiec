class Exam {
  final String id;
  final String userId;
  final String examType;
  final String examName;
  final DateTime requestDate;
  final DateTime? collectionDate;
  final DateTime? resultDate;
  final String status;
  final String healthFacility;
  final String requestingDoctor;
  final String? performingLab;
  final List<ExamResult> results;
  final String? observations;
  final String? clinicalIndication;
  final bool isUrgent;
  final DateTime createdAt;
  final DateTime updatedAt;

  Exam({
    required this.id,
    required this.userId,
    required this.examType,
    required this.examName,
    required this.requestDate,
    this.collectionDate,
    this.resultDate,
    required this.status,
    required this.healthFacility,
    required this.requestingDoctor,
    this.performingLab,
    required this.results,
    this.observations,
    this.clinicalIndication,
    this.isUrgent = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      userId: json['userId'] as String,
      examType: json['examType'] as String,
      examName: json['examName'] as String,
      requestDate: DateTime.parse(json['requestDate'] as String),
      collectionDate: json['collectionDate'] != null
          ? DateTime.parse(json['collectionDate'] as String)
          : null,
      resultDate: json['resultDate'] != null
          ? DateTime.parse(json['resultDate'] as String)
          : null,
      status: json['status'] as String,
      healthFacility: json['healthFacility'] as String,
      requestingDoctor: json['requestingDoctor'] as String,
      performingLab: json['performingLab'] as String?,
      results: (json['results'] as List)
          .map((r) => ExamResult.fromJson(r as Map<String, dynamic>))
          .toList(),
      observations: json['observations'] as String?,
      clinicalIndication: json['clinicalIndication'] as String?,
      isUrgent: json['isUrgent'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'examType': examType,
      'examName': examName,
      'requestDate': requestDate.toIso8601String(),
      'collectionDate': collectionDate?.toIso8601String(),
      'resultDate': resultDate?.toIso8601String(),
      'status': status,
      'healthFacility': healthFacility,
      'requestingDoctor': requestingDoctor,
      'performingLab': performingLab,
      'results': results.map((r) => r.toJson()).toList(),
      'observations': observations,
      'clinicalIndication': clinicalIndication,
      'isUrgent': isUrgent,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isCompleted {
    return status.toLowerCase() == 'concluído' || 
           status.toLowerCase() == 'completed' ||
           resultDate != null;
  }

  bool get isPending {
    return status.toLowerCase() == 'pendente' || 
           status.toLowerCase() == 'pending' ||
           status.toLowerCase() == 'aguardando';
  }

  bool get isInProgress {
    return status.toLowerCase() == 'em andamento' || 
           status.toLowerCase() == 'in progress' ||
           status.toLowerCase() == 'coletado';
  }

  String get statusDescription {
    switch (status.toLowerCase()) {
      case 'pendente':
      case 'pending':
        return 'Pendente';
      case 'coletado':
      case 'collected':
        return 'Coletado';
      case 'em andamento':
      case 'in progress':
        return 'Em andamento';
      case 'concluído':
      case 'completed':
        return 'Concluído';
      case 'cancelado':
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  String get formattedRequestDate {
    return '${requestDate.day.toString().padLeft(2, '0')}/'
           '${requestDate.month.toString().padLeft(2, '0')}/'
           '${requestDate.year}';
  }

  String? get formattedResultDate {
    if (resultDate == null) return null;
    return '${resultDate!.day.toString().padLeft(2, '0')}/'
           '${resultDate!.month.toString().padLeft(2, '0')}/'
           '${resultDate!.year}';
  }

  List<ExamResult> get abnormalResults {
    return results.where((r) => r.isAbnormal).toList();
  }

  bool get hasAbnormalResults {
    return abnormalResults.isNotEmpty;
  }

  Exam copyWith({
    String? id,
    String? userId,
    String? examType,
    String? examName,
    DateTime? requestDate,
    DateTime? collectionDate,
    DateTime? resultDate,
    String? status,
    String? healthFacility,
    String? requestingDoctor,
    String? performingLab,
    List<ExamResult>? results,
    String? observations,
    String? clinicalIndication,
    bool? isUrgent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exam(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      examType: examType ?? this.examType,
      examName: examName ?? this.examName,
      requestDate: requestDate ?? this.requestDate,
      collectionDate: collectionDate ?? this.collectionDate,
      resultDate: resultDate ?? this.resultDate,
      status: status ?? this.status,
      healthFacility: healthFacility ?? this.healthFacility,
      requestingDoctor: requestingDoctor ?? this.requestingDoctor,
      performingLab: performingLab ?? this.performingLab,
      results: results ?? this.results,
      observations: observations ?? this.observations,
      clinicalIndication: clinicalIndication ?? this.clinicalIndication,
      isUrgent: isUrgent ?? this.isUrgent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Exam(id: $id, examName: $examName, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Exam && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ExamResult {
  final String id;
  final String examId;
  final String parameterName;
  final String value;
  final String unit;
  final String? referenceRange;
  final String? interpretation;
  final bool isAbnormal;
  final String? notes;

  ExamResult({
    required this.id,
    required this.examId,
    required this.parameterName,
    required this.value,
    required this.unit,
    this.referenceRange,
    this.interpretation,
    this.isAbnormal = false,
    this.notes,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'] as String,
      examId: json['examId'] as String,
      parameterName: json['parameterName'] as String,
      value: json['value'] as String,
      unit: json['unit'] as String,
      referenceRange: json['referenceRange'] as String?,
      interpretation: json['interpretation'] as String?,
      isAbnormal: json['isAbnormal'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examId': examId,
      'parameterName': parameterName,
      'value': value,
      'unit': unit,
      'referenceRange': referenceRange,
      'interpretation': interpretation,
      'isAbnormal': isAbnormal,
      'notes': notes,
    };
  }

  String get formattedValue {
    return '$value $unit';
  }

  String get displayText {
    final valueText = formattedValue;
    final rangeText = referenceRange != null ? ' (Ref: $referenceRange)' : '';
    return '$parameterName: $valueText$rangeText';
  }

  @override
  String toString() {
    return 'ExamResult(parameterName: $parameterName, value: $value, isAbnormal: $isAbnormal)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExamResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}