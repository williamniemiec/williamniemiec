class User {
  final String id;
  final String cpf;
  final String cns; // Cartão Nacional de Saúde
  final String name;
  final String email;
  final DateTime dateOfBirth;
  final String gender;
  final String phone;
  final Address address;
  final bool isOrganDonor;
  final bool isBloodDonor;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.cpf,
    required this.cns,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.gender,
    required this.phone,
    required this.address,
    this.isOrganDonor = false,
    this.isBloodDonor = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      cpf: json['cpf'] as String,
      cns: json['cns'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      phone: json['phone'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      isOrganDonor: json['isOrganDonor'] as bool? ?? false,
      isBloodDonor: json['isBloodDonor'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cpf': cpf,
      'cns': cns,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'address': address.toJson(),
      'isOrganDonor': isOrganDonor,
      'isBloodDonor': isBloodDonor,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? cpf,
    String? cns,
    String? name,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? phone,
    Address? address,
    bool? isOrganDonor,
    bool? isBloodDonor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      cpf: cpf ?? this.cpf,
      cns: cns ?? this.cns,
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      isOrganDonor: isOrganDonor ?? this.isOrganDonor,
      isBloodDonor: isBloodDonor ?? this.isBloodDonor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, cpf: $cpf, cns: $cns)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Address {
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.number,
    this.complement = '',
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country = 'Brasil',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String,
      number: json['number'] as String,
      complement: json['complement'] as String? ?? '',
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      country: json['country'] as String? ?? 'Brasil',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  String get fullAddress {
    final complementText = complement.isNotEmpty ? ', $complement' : '';
    return '$street, $number$complementText, $neighborhood, $city - $state, $zipCode';
  }

  @override
  String toString() => fullAddress;
}