import 'package:json_annotation/json_annotation.dart';

part 'dating_profile.g.dart';

@JsonSerializable()
class DatingProfile {
  final String id;
  final String bio;
  final List<String> photoUrls;
  final int? age;
  final String? location;
  final List<String>? interests;
  final DateTime createdAt;
  final DateTime? lastRoastedAt;
  final double? roastScore;
  final List<String>? roastFeedback;

  const DatingProfile({
    required this.id,
    required this.bio,
    required this.photoUrls,
    this.age,
    this.location,
    this.interests,
    required this.createdAt,
    this.lastRoastedAt,
    this.roastScore,
    this.roastFeedback,
  });

  factory DatingProfile.fromJson(Map<String, dynamic> json) => _$DatingProfileFromJson(json);
  Map<String, dynamic> toJson() => _$DatingProfileToJson(this);

  DatingProfile copyWith({
    String? id,
    String? bio,
    List<String>? photoUrls,
    int? age,
    String? location,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? lastRoastedAt,
    double? roastScore,
    List<String>? roastFeedback,
  }) {
    return DatingProfile(
      id: id ?? this.id,
      bio: bio ?? this.bio,
      photoUrls: photoUrls ?? this.photoUrls,
      age: age ?? this.age,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      lastRoastedAt: lastRoastedAt ?? this.lastRoastedAt,
      roastScore: roastScore ?? this.roastScore,
      roastFeedback: roastFeedback ?? this.roastFeedback,
    );
  }

  bool get hasPhotos => photoUrls.isNotEmpty;
  bool get hasBio => bio.trim().isNotEmpty;
  bool get isComplete => hasPhotos && hasBio;
  
  String get roastScoreText {
    if (roastScore == null) return 'Not rated';
    if (roastScore! >= 8.0) return 'Excellent';
    if (roastScore! >= 6.0) return 'Good';
    if (roastScore! >= 4.0) return 'Needs work';
    return 'Major improvements needed';
  }

  static DatingProfile create({
    required String bio,
    required List<String> photoUrls,
    int? age,
    String? location,
    List<String>? interests,
  }) {
    return DatingProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bio: bio,
      photoUrls: photoUrls,
      age: age,
      location: location,
      interests: interests,
      createdAt: DateTime.now(),
    );
  }
}