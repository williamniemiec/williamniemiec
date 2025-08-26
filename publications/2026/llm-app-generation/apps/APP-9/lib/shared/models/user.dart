class User {
  final String id;
  final String email;
  final String subscriptionPlan;
  final List<Profile> profiles;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    required this.subscriptionPlan,
    required this.profiles,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      subscriptionPlan: json['subscriptionPlan'] as String,
      profiles: (json['profiles'] as List<dynamic>)
          .map((profile) => Profile.fromJson(profile as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'subscriptionPlan': subscriptionPlan,
      'profiles': profiles.map((profile) => profile.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? subscriptionPlan,
    List<Profile>? profiles,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      profiles: profiles ?? this.profiles,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.email == email &&
        other.subscriptionPlan == subscriptionPlan;
  }

  @override
  int get hashCode {
    return id.hashCode ^ email.hashCode ^ subscriptionPlan.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, subscriptionPlan: $subscriptionPlan, profiles: ${profiles.length})';
  }
}

class Profile {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isKidsProfile;
  final String maturityRating;
  final List<String> myList;
  final List<String> continueWatching;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;

  const Profile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isKidsProfile,
    required this.maturityRating,
    required this.myList,
    required this.continueWatching,
    required this.preferences,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      isKidsProfile: json['isKidsProfile'] as bool,
      maturityRating: json['maturityRating'] as String,
      myList: List<String>.from(json['myList'] as List<dynamic>),
      continueWatching: List<String>.from(json['continueWatching'] as List<dynamic>),
      preferences: Map<String, dynamic>.from(json['preferences'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'isKidsProfile': isKidsProfile,
      'maturityRating': maturityRating,
      'myList': myList,
      'continueWatching': continueWatching,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool? isKidsProfile,
    String? maturityRating,
    List<String>? myList,
    List<String>? continueWatching,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isKidsProfile: isKidsProfile ?? this.isKidsProfile,
      maturityRating: maturityRating ?? this.maturityRating,
      myList: myList ?? this.myList,
      continueWatching: continueWatching ?? this.continueWatching,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Profile &&
        other.id == id &&
        other.name == name &&
        other.isKidsProfile == isKidsProfile;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ isKidsProfile.hashCode;
  }

  @override
  String toString() {
    return 'Profile(id: $id, name: $name, isKidsProfile: $isKidsProfile)';
  }
}