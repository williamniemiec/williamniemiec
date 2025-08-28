import 'package:equatable/equatable.dart';
import 'location.dart';

enum ReportType {
  police,
  accident,
  traffic,
  hazard,
  construction,
  speedCamera,
  redLightCamera,
}

enum ReportSubType {
  // Police subtypes
  policeVisible,
  policeHidden,
  policeOtherSide,
  
  // Accident subtypes
  accidentMinor,
  accidentMajor,
  accidentVehicleOnShoulder,
  
  // Traffic subtypes
  trafficLight,
  trafficModerate,
  trafficHeavy,
  trafficStandstill,
  
  // Hazard subtypes
  hazardOnRoad,
  hazardOnShoulder,
  hazardWeather,
  hazardFlood,
  hazardFog,
  hazardIce,
  hazardRoadkill,
  hazardCarStopped,
  hazardMissingSign,
  
  // Construction subtypes
  constructionMajor,
  constructionMinor,
  constructionLaneClosure,
}

enum ReportStatus {
  active,
  expired,
  confirmed,
  notThere,
}

class Report extends Equatable {
  final String id;
  final String userId;
  final String username;
  final ReportType type;
  final ReportSubType? subType;
  final Location location;
  final String? description;
  final DateTime createdAt;
  final DateTime expiresAt;
  final ReportStatus status;
  final int confirmations;
  final int notThereReports;
  final List<String> confirmedByUsers;
  final List<String> notThereByUsers;
  final String? imageUrl;
  final double? speed; // Speed when report was made
  final String? roadName;
  final bool isOnRoute;

  const Report({
    required this.id,
    required this.userId,
    required this.username,
    required this.type,
    this.subType,
    required this.location,
    this.description,
    required this.createdAt,
    required this.expiresAt,
    this.status = ReportStatus.active,
    this.confirmations = 0,
    this.notThereReports = 0,
    this.confirmedByUsers = const [],
    this.notThereByUsers = const [],
    this.imageUrl,
    this.speed,
    this.roadName,
    this.isOnRoute = false,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      type: ReportType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      subType: json['subType'] != null
          ? ReportSubType.values.firstWhere(
              (e) => e.toString().split('.').last == json['subType'],
            )
          : null,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      status: ReportStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ReportStatus.active,
      ),
      confirmations: json['confirmations'] as int? ?? 0,
      notThereReports: json['notThereReports'] as int? ?? 0,
      confirmedByUsers: List<String>.from(json['confirmedByUsers'] ?? []),
      notThereByUsers: List<String>.from(json['notThereByUsers'] ?? []),
      imageUrl: json['imageUrl'] as String?,
      speed: (json['speed'] as num?)?.toDouble(),
      roadName: json['roadName'] as String?,
      isOnRoute: json['isOnRoute'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'type': type.toString().split('.').last,
      'subType': subType?.toString().split('.').last,
      'location': location.toJson(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'status': status.toString().split('.').last,
      'confirmations': confirmations,
      'notThereReports': notThereReports,
      'confirmedByUsers': confirmedByUsers,
      'notThereByUsers': notThereByUsers,
      'imageUrl': imageUrl,
      'speed': speed,
      'roadName': roadName,
      'isOnRoute': isOnRoute,
    };
  }

  Report copyWith({
    String? id,
    String? userId,
    String? username,
    ReportType? type,
    ReportSubType? subType,
    Location? location,
    String? description,
    DateTime? createdAt,
    DateTime? expiresAt,
    ReportStatus? status,
    int? confirmations,
    int? notThereReports,
    List<String>? confirmedByUsers,
    List<String>? notThereByUsers,
    String? imageUrl,
    double? speed,
    String? roadName,
    bool? isOnRoute,
  }) {
    return Report(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      type: type ?? this.type,
      subType: subType ?? this.subType,
      location: location ?? this.location,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
      confirmations: confirmations ?? this.confirmations,
      notThereReports: notThereReports ?? this.notThereReports,
      confirmedByUsers: confirmedByUsers ?? this.confirmedByUsers,
      notThereByUsers: notThereByUsers ?? this.notThereByUsers,
      imageUrl: imageUrl ?? this.imageUrl,
      speed: speed ?? this.speed,
      roadName: roadName ?? this.roadName,
      isOnRoute: isOnRoute ?? this.isOnRoute,
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  bool get isConfirmed => confirmations >= 2;
  
  bool get shouldBeRemoved => notThereReports >= 3 || isExpired;
  
  String get displayName {
    switch (type) {
      case ReportType.police:
        return 'Police';
      case ReportType.accident:
        return 'Accident';
      case ReportType.traffic:
        return 'Traffic';
      case ReportType.hazard:
        return 'Hazard';
      case ReportType.construction:
        return 'Construction';
      case ReportType.speedCamera:
        return 'Speed Camera';
      case ReportType.redLightCamera:
        return 'Red Light Camera';
    }
  }
  
  String get iconPath {
    switch (type) {
      case ReportType.police:
        return 'assets/icons/police.png';
      case ReportType.accident:
        return 'assets/icons/accident.png';
      case ReportType.traffic:
        return 'assets/icons/traffic.png';
      case ReportType.hazard:
        return 'assets/icons/hazard.png';
      case ReportType.construction:
        return 'assets/icons/construction.png';
      case ReportType.speedCamera:
        return 'assets/icons/speed_camera.png';
      case ReportType.redLightCamera:
        return 'assets/icons/red_light_camera.png';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        username,
        type,
        subType,
        location,
        description,
        createdAt,
        expiresAt,
        status,
        confirmations,
        notThereReports,
        confirmedByUsers,
        notThereByUsers,
        imageUrl,
        speed,
        roadName,
        isOnRoute,
      ];
}

// Helper class for creating reports
class ReportRequest {
  final ReportType type;
  final ReportSubType? subType;
  final Location location;
  final String? description;
  final String? imageUrl;
  final double? speed;
  final String? roadName;

  const ReportRequest({
    required this.type,
    this.subType,
    required this.location,
    this.description,
    this.imageUrl,
    this.speed,
    this.roadName,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'subType': subType?.toString().split('.').last,
      'location': location.toJson(),
      'description': description,
      'imageUrl': imageUrl,
      'speed': speed,
      'roadName': roadName,
    };
  }
}