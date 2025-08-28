class Vaccination {
  final String id;
  final String userId;
  final String vaccineName;
  final String vaccineType;
  final String manufacturer;
  final String batchNumber;
  final DateTime administrationDate;
  final String healthFacility;
  final String healthProfessional;
  final int doseNumber;
  final int totalDoses;
  final String lotNumber;
  final DateTime expirationDate;
  final String administrationSite;
  final String notes;
  final bool isValid;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vaccination({
    required this.id,
    required this.userId,
    required this.vaccineName,
    required this.vaccineType,
    required this.manufacturer,
    required this.batchNumber,
    required this.administrationDate,
    required this.healthFacility,
    required this.healthProfessional,
    required this.doseNumber,
    required this.totalDoses,
    required this.lotNumber,
    required this.expirationDate,
    required this.administrationSite,
    this.notes = '',
    this.isValid = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vaccineName: json['vaccineName'] as String,
      vaccineType: json['vaccineType'] as String,
      manufacturer: json['manufacturer'] as String,
      batchNumber: json['batchNumber'] as String,
      administrationDate: DateTime.parse(json['administrationDate'] as String),
      healthFacility: json['healthFacility'] as String,
      healthProfessional: json['healthProfessional'] as String,
      doseNumber: json['doseNumber'] as int,
      totalDoses: json['totalDoses'] as int,
      lotNumber: json['lotNumber'] as String,
      expirationDate: DateTime.parse(json['expirationDate'] as String),
      administrationSite: json['administrationSite'] as String,
      notes: json['notes'] as String? ?? '',
      isValid: json['isValid'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vaccineName': vaccineName,
      'vaccineType': vaccineType,
      'manufacturer': manufacturer,
      'batchNumber': batchNumber,
      'administrationDate': administrationDate.toIso8601String(),
      'healthFacility': healthFacility,
      'healthProfessional': healthProfessional,
      'doseNumber': doseNumber,
      'totalDoses': totalDoses,
      'lotNumber': lotNumber,
      'expirationDate': expirationDate.toIso8601String(),
      'administrationSite': administrationSite,
      'notes': notes,
      'isValid': isValid,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool get isCovidVaccine {
    return vaccineType.toLowerCase().contains('covid') ||
           vaccineName.toLowerCase().contains('covid') ||
           vaccineName.toLowerCase().contains('coronavac') ||
           vaccineName.toLowerCase().contains('astrazeneca') ||
           vaccineName.toLowerCase().contains('pfizer') ||
           vaccineName.toLowerCase().contains('janssen');
  }

  bool get isComplete {
    return doseNumber >= totalDoses;
  }

  String get doseDescription {
    if (totalDoses == 1) {
      return 'Dose única';
    }
    return '$doseNumber° dose de $totalDoses';
  }

  String get formattedDate {
    return '${administrationDate.day.toString().padLeft(2, '0')}/'
           '${administrationDate.month.toString().padLeft(2, '0')}/'
           '${administrationDate.year}';
  }

  Vaccination copyWith({
    String? id,
    String? userId,
    String? vaccineName,
    String? vaccineType,
    String? manufacturer,
    String? batchNumber,
    DateTime? administrationDate,
    String? healthFacility,
    String? healthProfessional,
    int? doseNumber,
    int? totalDoses,
    String? lotNumber,
    DateTime? expirationDate,
    String? administrationSite,
    String? notes,
    bool? isValid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vaccination(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vaccineName: vaccineName ?? this.vaccineName,
      vaccineType: vaccineType ?? this.vaccineType,
      manufacturer: manufacturer ?? this.manufacturer,
      batchNumber: batchNumber ?? this.batchNumber,
      administrationDate: administrationDate ?? this.administrationDate,
      healthFacility: healthFacility ?? this.healthFacility,
      healthProfessional: healthProfessional ?? this.healthProfessional,
      doseNumber: doseNumber ?? this.doseNumber,
      totalDoses: totalDoses ?? this.totalDoses,
      lotNumber: lotNumber ?? this.lotNumber,
      expirationDate: expirationDate ?? this.expirationDate,
      administrationSite: administrationSite ?? this.administrationSite,
      notes: notes ?? this.notes,
      isValid: isValid ?? this.isValid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Vaccination(id: $id, vaccineName: $vaccineName, doseNumber: $doseNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vaccination && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class VaccinationCertificate {
  final String id;
  final String userId;
  final List<Vaccination> vaccinations;
  final String language;
  final DateTime generatedAt;
  final String qrCodeData;
  final bool isValid;

  VaccinationCertificate({
    required this.id,
    required this.userId,
    required this.vaccinations,
    required this.language,
    required this.generatedAt,
    required this.qrCodeData,
    this.isValid = true,
  });

  factory VaccinationCertificate.fromJson(Map<String, dynamic> json) {
    return VaccinationCertificate(
      id: json['id'] as String,
      userId: json['userId'] as String,
      vaccinations: (json['vaccinations'] as List)
          .map((v) => Vaccination.fromJson(v as Map<String, dynamic>))
          .toList(),
      language: json['language'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      qrCodeData: json['qrCodeData'] as String,
      isValid: json['isValid'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vaccinations': vaccinations.map((v) => v.toJson()).toList(),
      'language': language,
      'generatedAt': generatedAt.toIso8601String(),
      'qrCodeData': qrCodeData,
      'isValid': isValid,
    };
  }

  List<Vaccination> get covidVaccinations {
    return vaccinations.where((v) => v.isCovidVaccine).toList();
  }

  bool get hasCompleteCovidVaccination {
    final covidVaccines = covidVaccinations;
    if (covidVaccines.isEmpty) return false;
    
    // Group by vaccine type and check if any series is complete
    final vaccineGroups = <String, List<Vaccination>>{};
    for (final vaccine in covidVaccines) {
      final key = '${vaccine.vaccineName}_${vaccine.manufacturer}';
      vaccineGroups[key] = (vaccineGroups[key] ?? [])..add(vaccine);
    }
    
    return vaccineGroups.values.any((group) {
      group.sort((a, b) => a.administrationDate.compareTo(b.administrationDate));
      return group.last.isComplete;
    });
  }

  String get certificateTitle {
    switch (language) {
      case 'en':
        return 'COVID-19 Vaccination Certificate';
      case 'es':
        return 'Certificado de Vacunación COVID-19';
      default:
        return 'Certificado Nacional de Vacinação COVID-19';
    }
  }

  @override
  String toString() {
    return 'VaccinationCertificate(id: $id, language: $language, vaccinations: ${vaccinations.length})';
  }
}