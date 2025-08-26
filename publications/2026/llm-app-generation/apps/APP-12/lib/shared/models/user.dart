class User {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final String phone;
  final String profileImageUrl;
  final DateTime createdAt;
  final bool isVerified;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.phone,
    this.profileImageUrl = '',
    required this.createdAt,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      phone: json['phone'] as String,
      profileImageUrl: json['profileImageUrl'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerified: json['isVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? cpf,
    String? phone,
    String? profileImageUrl,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}