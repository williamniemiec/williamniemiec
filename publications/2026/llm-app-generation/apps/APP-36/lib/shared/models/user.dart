class User {
  final String id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String cpf;
  final String phone;
  final DateTime dateOfBirth;
  final String? profileImageUrl;
  final double balance;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserPreferences preferences;
  final ResponsibleGamingLimits responsibleGamingLimits;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.cpf,
    required this.phone,
    required this.dateOfBirth,
    this.profileImageUrl,
    required this.balance,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
    required this.preferences,
    required this.responsibleGamingLimits,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      cpf: json['cpf'] as String,
      phone: json['phone'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      profileImageUrl: json['profile_image_url'] as String?,
      balance: (json['balance'] as num).toDouble(),
      isVerified: json['is_verified'] as bool,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      preferences: UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>),
      responsibleGamingLimits: ResponsibleGamingLimits.fromJson(
        json['responsible_gaming_limits'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'cpf': cpf,
      'phone': phone,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'profile_image_url': profileImageUrl,
      'balance': balance,
      'is_verified': isVerified,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
      'preferences': preferences.toJson(),
      'responsible_gaming_limits': responsibleGamingLimits.toJson(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? cpf,
    String? phone,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    double? balance,
    bool? isVerified,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
    ResponsibleGamingLimits? responsibleGamingLimits,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      balance: balance ?? this.balance,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      responsibleGamingLimits: responsibleGamingLimits ?? this.responsibleGamingLimits,
    );
  }

  String get fullName => '$firstName $lastName';

  String get formattedBalance => 'R\$ ${balance.toStringAsFixed(2)}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, balance: $balance)';
  }
}

class UserPreferences {
  final bool notificationsEnabled;
  final bool biometricLoginEnabled;
  final bool darkModeEnabled;
  final List<String> favoriteSports;
  final String preferredLanguage;
  final String preferredCurrency;
  final bool liveStreamingEnabled;
  final String streamingQuality;

  const UserPreferences({
    required this.notificationsEnabled,
    required this.biometricLoginEnabled,
    required this.darkModeEnabled,
    required this.favoriteSports,
    required this.preferredLanguage,
    required this.preferredCurrency,
    required this.liveStreamingEnabled,
    required this.streamingQuality,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notifications_enabled'] as bool,
      biometricLoginEnabled: json['biometric_login_enabled'] as bool,
      darkModeEnabled: json['dark_mode_enabled'] as bool,
      favoriteSports: List<String>.from(json['favorite_sports'] as List),
      preferredLanguage: json['preferred_language'] as String,
      preferredCurrency: json['preferred_currency'] as String,
      liveStreamingEnabled: json['live_streaming_enabled'] as bool,
      streamingQuality: json['streaming_quality'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'biometric_login_enabled': biometricLoginEnabled,
      'dark_mode_enabled': darkModeEnabled,
      'favorite_sports': favoriteSports,
      'preferred_language': preferredLanguage,
      'preferred_currency': preferredCurrency,
      'live_streaming_enabled': liveStreamingEnabled,
      'streaming_quality': streamingQuality,
    };
  }

  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? biometricLoginEnabled,
    bool? darkModeEnabled,
    List<String>? favoriteSports,
    String? preferredLanguage,
    String? preferredCurrency,
    bool? liveStreamingEnabled,
    String? streamingQuality,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricLoginEnabled: biometricLoginEnabled ?? this.biometricLoginEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      favoriteSports: favoriteSports ?? this.favoriteSports,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      liveStreamingEnabled: liveStreamingEnabled ?? this.liveStreamingEnabled,
      streamingQuality: streamingQuality ?? this.streamingQuality,
    );
  }
}

class ResponsibleGamingLimits {
  final double? dailyDepositLimit;
  final double? weeklyDepositLimit;
  final double? monthlyDepositLimit;
  final double? dailyLossLimit;
  final double? weeklyLossLimit;
  final double? monthlyLossLimit;
  final int? sessionTimeLimit; // in minutes
  final DateTime? selfExclusionUntil;
  final bool isActive;

  const ResponsibleGamingLimits({
    this.dailyDepositLimit,
    this.weeklyDepositLimit,
    this.monthlyDepositLimit,
    this.dailyLossLimit,
    this.weeklyLossLimit,
    this.monthlyLossLimit,
    this.sessionTimeLimit,
    this.selfExclusionUntil,
    required this.isActive,
  });

  factory ResponsibleGamingLimits.fromJson(Map<String, dynamic> json) {
    return ResponsibleGamingLimits(
      dailyDepositLimit: json['daily_deposit_limit'] != null
          ? (json['daily_deposit_limit'] as num).toDouble()
          : null,
      weeklyDepositLimit: json['weekly_deposit_limit'] != null
          ? (json['weekly_deposit_limit'] as num).toDouble()
          : null,
      monthlyDepositLimit: json['monthly_deposit_limit'] != null
          ? (json['monthly_deposit_limit'] as num).toDouble()
          : null,
      dailyLossLimit: json['daily_loss_limit'] != null
          ? (json['daily_loss_limit'] as num).toDouble()
          : null,
      weeklyLossLimit: json['weekly_loss_limit'] != null
          ? (json['weekly_loss_limit'] as num).toDouble()
          : null,
      monthlyLossLimit: json['monthly_loss_limit'] != null
          ? (json['monthly_loss_limit'] as num).toDouble()
          : null,
      sessionTimeLimit: json['session_time_limit'] as int?,
      selfExclusionUntil: json['self_exclusion_until'] != null
          ? DateTime.parse(json['self_exclusion_until'] as String)
          : null,
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_deposit_limit': dailyDepositLimit,
      'weekly_deposit_limit': weeklyDepositLimit,
      'monthly_deposit_limit': monthlyDepositLimit,
      'daily_loss_limit': dailyLossLimit,
      'weekly_loss_limit': weeklyLossLimit,
      'monthly_loss_limit': monthlyLossLimit,
      'session_time_limit': sessionTimeLimit,
      'self_exclusion_until': selfExclusionUntil?.toIso8601String(),
      'is_active': isActive,
    };
  }

  ResponsibleGamingLimits copyWith({
    double? dailyDepositLimit,
    double? weeklyDepositLimit,
    double? monthlyDepositLimit,
    double? dailyLossLimit,
    double? weeklyLossLimit,
    double? monthlyLossLimit,
    int? sessionTimeLimit,
    DateTime? selfExclusionUntil,
    bool? isActive,
  }) {
    return ResponsibleGamingLimits(
      dailyDepositLimit: dailyDepositLimit ?? this.dailyDepositLimit,
      weeklyDepositLimit: weeklyDepositLimit ?? this.weeklyDepositLimit,
      monthlyDepositLimit: monthlyDepositLimit ?? this.monthlyDepositLimit,
      dailyLossLimit: dailyLossLimit ?? this.dailyLossLimit,
      weeklyLossLimit: weeklyLossLimit ?? this.weeklyLossLimit,
      monthlyLossLimit: monthlyLossLimit ?? this.monthlyLossLimit,
      sessionTimeLimit: sessionTimeLimit ?? this.sessionTimeLimit,
      selfExclusionUntil: selfExclusionUntil ?? this.selfExclusionUntil,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isSelfExcluded {
    return selfExclusionUntil != null && DateTime.now().isBefore(selfExclusionUntil!);
  }
}