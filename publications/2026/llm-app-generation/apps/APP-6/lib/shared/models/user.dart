import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserSubscription subscription;
  final UserPreferences preferences;
  final UserUsage usage;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.subscription,
    required this.preferences,
    required this.usage,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserSubscription? subscription,
    UserPreferences? preferences,
    UserUsage? usage,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscription: subscription ?? this.subscription,
      preferences: preferences ?? this.preferences,
      usage: usage ?? this.usage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        createdAt,
        updatedAt,
        subscription,
        preferences,
        usage,
      ];
}

@JsonSerializable()
class UserSubscription extends Equatable {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isActive;
  final List<String> features;

  const UserSubscription({
    required this.tier,
    this.expiresAt,
    required this.isActive,
    required this.features,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);
  Map<String, dynamic> toJson() => _$UserSubscriptionToJson(this);

  UserSubscription copyWith({
    SubscriptionTier? tier,
    DateTime? expiresAt,
    bool? isActive,
    List<String>? features,
  }) {
    return UserSubscription(
      tier: tier ?? this.tier,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      features: features ?? this.features,
    );
  }

  @override
  List<Object?> get props => [tier, expiresAt, isActive, features];
}

@JsonSerializable()
class UserPreferences extends Equatable {
  final bool autoSave;
  final bool gridEnabled;
  final bool snapToGrid;
  final bool showRulers;
  final String defaultExportFormat;
  final int defaultExportQuality;
  final String language;
  final bool darkMode;
  final bool notifications;

  const UserPreferences({
    this.autoSave = true,
    this.gridEnabled = false,
    this.snapToGrid = true,
    this.showRulers = false,
    this.defaultExportFormat = 'PNG',
    this.defaultExportQuality = 100,
    this.language = 'en',
    this.darkMode = false,
    this.notifications = true,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    bool? autoSave,
    bool? gridEnabled,
    bool? snapToGrid,
    bool? showRulers,
    String? defaultExportFormat,
    int? defaultExportQuality,
    String? language,
    bool? darkMode,
    bool? notifications,
  }) {
    return UserPreferences(
      autoSave: autoSave ?? this.autoSave,
      gridEnabled: gridEnabled ?? this.gridEnabled,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      showRulers: showRulers ?? this.showRulers,
      defaultExportFormat: defaultExportFormat ?? this.defaultExportFormat,
      defaultExportQuality: defaultExportQuality ?? this.defaultExportQuality,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [
        autoSave,
        gridEnabled,
        snapToGrid,
        showRulers,
        defaultExportFormat,
        defaultExportQuality,
        language,
        darkMode,
        notifications,
      ];
}

@JsonSerializable()
class UserUsage extends Equatable {
  final int designsCreated;
  final int templatesUsed;
  final int exportsThisMonth;
  final int storageUsedMB;
  final int aiGenerationsUsed;
  final DateTime lastActive;

  const UserUsage({
    this.designsCreated = 0,
    this.templatesUsed = 0,
    this.exportsThisMonth = 0,
    this.storageUsedMB = 0,
    this.aiGenerationsUsed = 0,
    required this.lastActive,
  });

  factory UserUsage.fromJson(Map<String, dynamic> json) =>
      _$UserUsageFromJson(json);
  Map<String, dynamic> toJson() => _$UserUsageToJson(this);

  UserUsage copyWith({
    int? designsCreated,
    int? templatesUsed,
    int? exportsThisMonth,
    int? storageUsedMB,
    int? aiGenerationsUsed,
    DateTime? lastActive,
  }) {
    return UserUsage(
      designsCreated: designsCreated ?? this.designsCreated,
      templatesUsed: templatesUsed ?? this.templatesUsed,
      exportsThisMonth: exportsThisMonth ?? this.exportsThisMonth,
      storageUsedMB: storageUsedMB ?? this.storageUsedMB,
      aiGenerationsUsed: aiGenerationsUsed ?? this.aiGenerationsUsed,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  @override
  List<Object?> get props => [
        designsCreated,
        templatesUsed,
        exportsThisMonth,
        storageUsedMB,
        aiGenerationsUsed,
        lastActive,
      ];
}

enum SubscriptionTier {
  @JsonValue('free')
  free,
  @JsonValue('pro')
  pro,
  @JsonValue('teams')
  teams,
}

extension SubscriptionTierExtension on SubscriptionTier {
  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.pro:
        return 'Canva Pro';
      case SubscriptionTier.teams:
        return 'Canva for Teams';
    }
  }

  List<String> get features {
    switch (this) {
      case SubscriptionTier.free:
        return [
          '250,000+ free templates',
          '100+ design types',
          '5GB cloud storage',
          'Basic photo editing',
        ];
      case SubscriptionTier.pro:
        return [
          'Everything in Free',
          'Premium templates',
          '100GB cloud storage',
          'Background remover',
          'Magic resize',
          'Brand kit',
          'Team collaboration',
        ];
      case SubscriptionTier.teams:
        return [
          'Everything in Pro',
          'Unlimited storage',
          'Advanced team features',
          'Brand controls',
          'Priority support',
        ];
    }
  }

  bool get isPremium => this != SubscriptionTier.free;
}