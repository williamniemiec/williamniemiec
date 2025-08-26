class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final List<Address> addresses;
  final List<PaymentMethod> paymentMethods;
  final bool isClubeMember;
  final DateTime? clubeExpiryDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.addresses = const [],
    this.paymentMethods = const [],
    this.isClubeMember = false,
    this.clubeExpiryDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e))
          .toList() ?? [],
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
          ?.map((e) => PaymentMethod.fromJson(e))
          .toList() ?? [],
      isClubeMember: json['isClubeMember'] ?? false,
      clubeExpiryDate: json['clubeExpiryDate'] != null
          ? DateTime.parse(json['clubeExpiryDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'addresses': addresses.map((e) => e.toJson()).toList(),
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
      'isClubeMember': isClubeMember,
      'clubeExpiryDate': clubeExpiryDate?.toIso8601String(),
    };
  }
}

class Address {
  final String id;
  final String label;
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      label: json['label'],
      street: json['street'],
      number: json['number'],
      complement: json['complement'],
      neighborhood: json['neighborhood'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
    };
  }

  String get fullAddress {
    final complementText = complement?.isNotEmpty == true ? ', $complement' : '';
    return '$street, $number$complementText, $neighborhood, $city - $state, $zipCode';
  }
}

class PaymentMethod {
  final String id;
  final PaymentType type;
  final String label;
  final String? cardNumber; // Last 4 digits for cards
  final String? cardBrand;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    this.cardNumber,
    this.cardBrand,
    this.isDefault = false,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      type: PaymentType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      label: json['label'],
      cardNumber: json['cardNumber'],
      cardBrand: json['cardBrand'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'label': label,
      'cardNumber': cardNumber,
      'cardBrand': cardBrand,
      'isDefault': isDefault,
    };
  }
}

enum PaymentType {
  creditCard,
  debitCard,
  pix,
  mealVoucher,
  cash,
}