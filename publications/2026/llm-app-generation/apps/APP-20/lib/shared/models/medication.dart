class Medication {
  final String id;
  final String userId;
  final String name;
  final String activeIngredient;
  final String dosage;
  final String form; // comprimido, xarope, injeção, etc.
  final String manufacturer;
  final DateTime dispensedDate;
  final int quantity;
  final String unit;
  final String pharmacy;
  final String pharmacist;
  final String prescribingDoctor;
  final String? prescription;
  final String program; // Farmácia Popular, etc.
  final double? price;
  final String? batchNumber;
  final DateTime? expirationDate;
  final String? instructions;
  final bool isControlled;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medication({
    required this.id,
    required this.userId,
    required this.name,
    required this.activeIngredient,
    required this.dosage,
    required this.form,
    required this.manufacturer,
    required this.dispensedDate,
    required this.quantity,
    required this.unit,
    required this.pharmacy,
    required this.pharmacist,
    required this.prescribingDoctor,
    this.prescription,
    required this.program,
    this.price,
    this.batchNumber,
    this.expirationDate,
    this.instructions,
    this.isControlled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      activeIngredient: json['activeIngredient'] as String,
      dosage: json['dosage'] as String,
      form: json['form'] as String,
      manufacturer: json['manufacturer'] as String,
      dispensedDate: DateTime.parse(json['dispensedDate'] as String),
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      pharmacy: json['pharmacy'] as String,
      pharmacist: json['pharmacist'] as String,
      prescribingDoctor: json['prescribingDoctor'] as String,
      prescription: json['prescription'] as String?,
      program: json['program'] as String,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      batchNumber: json['batchNumber'] as String?,
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'] as String)
          : null,
      instructions: json['instructions'] as String?,
      isControlled: json['isControlled'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'activeIngredient': activeIngredient,
      'dosage': dosage,
      'form': form,
      'manufacturer': manufacturer,
      'dispensedDate': dispensedDate.toIso8601String(),
      'quantity': quantity,
      'unit': unit,
      'pharmacy': pharmacy,
      'pharmacist': pharmacist,
      'prescribingDoctor': prescribingDoctor,
      'prescription': prescription,
      'program': program,
      'price': price,
      'batchNumber': batchNumber,
      'expirationDate': expirationDate?.toIso8601String(),
      'instructions': instructions,
      'isControlled': isControlled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get formattedDispensedDate {
    return '${dispensedDate.day.toString().padLeft(2, '0')}/'
           '${dispensedDate.month.toString().padLeft(2, '0')}/'
           '${dispensedDate.year}';
  }

  String? get formattedExpirationDate {
    if (expirationDate == null) return null;
    return '${expirationDate!.day.toString().padLeft(2, '0')}/'
           '${expirationDate!.month.toString().padLeft(2, '0')}/'
           '${expirationDate!.year}';
  }

  String get quantityDescription {
    return '$quantity $unit';
  }

  String get fullDescription {
    return '$name $dosage - $form';
  }

  String? get formattedPrice {
    if (price == null) return null;
    return 'R\$ ${price!.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  bool get isExpired {
    if (expirationDate == null) return false;
    return DateTime.now().isAfter(expirationDate!);
  }

  bool get isExpiringSoon {
    if (expirationDate == null) return false;
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));
    return expirationDate!.isBefore(thirtyDaysFromNow) && expirationDate!.isAfter(now);
  }

  Medication copyWith({
    String? id,
    String? userId,
    String? name,
    String? activeIngredient,
    String? dosage,
    String? form,
    String? manufacturer,
    DateTime? dispensedDate,
    int? quantity,
    String? unit,
    String? pharmacy,
    String? pharmacist,
    String? prescribingDoctor,
    String? prescription,
    String? program,
    double? price,
    String? batchNumber,
    DateTime? expirationDate,
    String? instructions,
    bool? isControlled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      dosage: dosage ?? this.dosage,
      form: form ?? this.form,
      manufacturer: manufacturer ?? this.manufacturer,
      dispensedDate: dispensedDate ?? this.dispensedDate,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      pharmacy: pharmacy ?? this.pharmacy,
      pharmacist: pharmacist ?? this.pharmacist,
      prescribingDoctor: prescribingDoctor ?? this.prescribingDoctor,
      prescription: prescription ?? this.prescription,
      program: program ?? this.program,
      price: price ?? this.price,
      batchNumber: batchNumber ?? this.batchNumber,
      expirationDate: expirationDate ?? this.expirationDate,
      instructions: instructions ?? this.instructions,
      isControlled: isControlled ?? this.isControlled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Medication(id: $id, name: $name, dosage: $dosage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Medication && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}