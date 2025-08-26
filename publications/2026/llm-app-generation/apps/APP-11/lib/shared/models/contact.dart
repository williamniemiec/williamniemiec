class Contact {
  final String id;
  final String? paypalId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final bool isPaypalUser;
  final bool isFrequentContact;
  final DateTime? lastTransactionAt;
  final int transactionCount;
  final DateTime createdAt;

  Contact({
    required this.id,
    this.paypalId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.isPaypalUser,
    required this.isFrequentContact,
    this.lastTransactionAt,
    required this.transactionCount,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}'.toUpperCase();
  
  String get displayIdentifier {
    if (email != null && email!.isNotEmpty) return email!;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) return phoneNumber!;
    return fullName;
  }

  String get contactMethod {
    if (email != null && email!.isNotEmpty) return 'Email';
    if (phoneNumber != null && phoneNumber!.isNotEmpty) return 'Phone';
    return 'Name';
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      paypalId: json['paypalId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      profileImageUrl: json['profileImageUrl'],
      isPaypalUser: json['isPaypalUser'],
      isFrequentContact: json['isFrequentContact'],
      lastTransactionAt: json['lastTransactionAt'] != null 
          ? DateTime.parse(json['lastTransactionAt']) 
          : null,
      transactionCount: json['transactionCount'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paypalId': paypalId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'profileImageUrl': profileImageUrl,
      'isPaypalUser': isPaypalUser,
      'isFrequentContact': isFrequentContact,
      'lastTransactionAt': lastTransactionAt?.toIso8601String(),
      'transactionCount': transactionCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Contact copyWith({
    String? id,
    String? paypalId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    bool? isPaypalUser,
    bool? isFrequentContact,
    DateTime? lastTransactionAt,
    int? transactionCount,
    DateTime? createdAt,
  }) {
    return Contact(
      id: id ?? this.id,
      paypalId: paypalId ?? this.paypalId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isPaypalUser: isPaypalUser ?? this.isPaypalUser,
      isFrequentContact: isFrequentContact ?? this.isFrequentContact,
      lastTransactionAt: lastTransactionAt ?? this.lastTransactionAt,
      transactionCount: transactionCount ?? this.transactionCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}