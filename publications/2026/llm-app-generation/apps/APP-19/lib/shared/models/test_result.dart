enum TestResultStatus {
  pending,
  normal,
  abnormal,
  critical,
}

class TestResultValue {
  final String name;
  final String value;
  final String unit;
  final String? referenceRange;
  final TestResultStatus status;
  final String? notes;

  TestResultValue({
    required this.name,
    required this.value,
    required this.unit,
    this.referenceRange,
    this.status = TestResultStatus.normal,
    this.notes,
  });

  factory TestResultValue.fromJson(Map<String, dynamic> json) {
    return TestResultValue(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
      unit: json['unit'] ?? '',
      referenceRange: json['referenceRange'],
      status: TestResultStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TestResultStatus.normal,
      ),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'unit': unit,
      'referenceRange': referenceRange,
      'status': status.name,
      'notes': notes,
    };
  }
}

class TestResult {
  final String id;
  final String patientId;
  final String testName;
  final String category;
  final DateTime orderedDate;
  final DateTime? collectedDate;
  final DateTime? resultDate;
  final String orderingProvider;
  final TestResultStatus overallStatus;
  final List<TestResultValue> values;
  final String? comments;
  final String? attachmentUrl;
  final bool isNew;

  TestResult({
    required this.id,
    required this.patientId,
    required this.testName,
    required this.category,
    required this.orderedDate,
    this.collectedDate,
    this.resultDate,
    required this.orderingProvider,
    this.overallStatus = TestResultStatus.pending,
    this.values = const [],
    this.comments,
    this.attachmentUrl,
    this.isNew = false,
  });

  bool get isPending => overallStatus == TestResultStatus.pending;
  bool get isAbnormal => overallStatus == TestResultStatus.abnormal || 
                        overallStatus == TestResultStatus.critical;
  bool get isCritical => overallStatus == TestResultStatus.critical;
  bool get hasAttachment => attachmentUrl != null;

  String get statusDisplayName {
    switch (overallStatus) {
      case TestResultStatus.pending:
        return 'Pending';
      case TestResultStatus.normal:
        return 'Normal';
      case TestResultStatus.abnormal:
        return 'Abnormal';
      case TestResultStatus.critical:
        return 'Critical';
    }
  }

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      testName: json['testName'] ?? '',
      category: json['category'] ?? '',
      orderedDate: DateTime.parse(json['orderedDate']),
      collectedDate: json['collectedDate'] != null
          ? DateTime.parse(json['collectedDate'])
          : null,
      resultDate: json['resultDate'] != null
          ? DateTime.parse(json['resultDate'])
          : null,
      orderingProvider: json['orderingProvider'] ?? '',
      overallStatus: TestResultStatus.values.firstWhere(
        (e) => e.name == json['overallStatus'],
        orElse: () => TestResultStatus.pending,
      ),
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => TestResultValue.fromJson(e))
          .toList() ?? [],
      comments: json['comments'],
      attachmentUrl: json['attachmentUrl'],
      isNew: json['isNew'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'testName': testName,
      'category': category,
      'orderedDate': orderedDate.toIso8601String(),
      'collectedDate': collectedDate?.toIso8601String(),
      'resultDate': resultDate?.toIso8601String(),
      'orderingProvider': orderingProvider,
      'overallStatus': overallStatus.name,
      'values': values.map((e) => e.toJson()).toList(),
      'comments': comments,
      'attachmentUrl': attachmentUrl,
      'isNew': isNew,
    };
  }
}