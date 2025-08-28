import 'package:equatable/equatable.dart';
import 'location.dart';

enum RouteType {
  fastest,
  shortest,
  eco,
  avoidTolls,
  avoidHighways,
}

enum TurnType {
  straight,
  slightLeft,
  left,
  sharpLeft,
  slightRight,
  right,
  sharpRight,
  uTurn,
  exitLeft,
  exitRight,
  merge,
  roundaboutLeft,
  roundaboutRight,
  ferry,
}

class RouteStep extends Equatable {
  final String instruction;
  final String htmlInstruction;
  final double distance; // in meters
  final int duration; // in seconds
  final Location startLocation;
  final Location endLocation;
  final TurnType turnType;
  final String? roadName;
  final List<Location> polylinePoints;
  final String? maneuver;

  const RouteStep({
    required this.instruction,
    required this.htmlInstruction,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    required this.turnType,
    this.roadName,
    this.polylinePoints = const [],
    this.maneuver,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      instruction: json['instruction'] as String,
      htmlInstruction: json['htmlInstruction'] as String,
      distance: (json['distance'] as num).toDouble(),
      duration: json['duration'] as int,
      startLocation: Location.fromJson(json['startLocation'] as Map<String, dynamic>),
      endLocation: Location.fromJson(json['endLocation'] as Map<String, dynamic>),
      turnType: TurnType.values.firstWhere(
        (e) => e.toString().split('.').last == json['turnType'],
        orElse: () => TurnType.straight,
      ),
      roadName: json['roadName'] as String?,
      polylinePoints: (json['polylinePoints'] as List?)
          ?.map((point) => Location.fromJson(point as Map<String, dynamic>))
          .toList() ?? [],
      maneuver: json['maneuver'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'instruction': instruction,
      'htmlInstruction': htmlInstruction,
      'distance': distance,
      'duration': duration,
      'startLocation': startLocation.toJson(),
      'endLocation': endLocation.toJson(),
      'turnType': turnType.toString().split('.').last,
      'roadName': roadName,
      'polylinePoints': polylinePoints.map((point) => point.toJson()).toList(),
      'maneuver': maneuver,
    };
  }

  @override
  List<Object?> get props => [
        instruction,
        htmlInstruction,
        distance,
        duration,
        startLocation,
        endLocation,
        turnType,
        roadName,
        polylinePoints,
        maneuver,
      ];
}

class RouteLeg extends Equatable {
  final double distance; // in meters
  final int duration; // in seconds
  final int durationInTraffic; // in seconds
  final Location startLocation;
  final Location endLocation;
  final String startAddress;
  final String endAddress;
  final List<RouteStep> steps;

  const RouteLeg({
    required this.distance,
    required this.duration,
    required this.durationInTraffic,
    required this.startLocation,
    required this.endLocation,
    required this.startAddress,
    required this.endAddress,
    required this.steps,
  });

  factory RouteLeg.fromJson(Map<String, dynamic> json) {
    return RouteLeg(
      distance: (json['distance'] as num).toDouble(),
      duration: json['duration'] as int,
      durationInTraffic: json['durationInTraffic'] as int,
      startLocation: Location.fromJson(json['startLocation'] as Map<String, dynamic>),
      endLocation: Location.fromJson(json['endLocation'] as Map<String, dynamic>),
      startAddress: json['startAddress'] as String,
      endAddress: json['endAddress'] as String,
      steps: (json['steps'] as List)
          .map((step) => RouteStep.fromJson(step as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distance': distance,
      'duration': duration,
      'durationInTraffic': durationInTraffic,
      'startLocation': startLocation.toJson(),
      'endLocation': endLocation.toJson(),
      'startAddress': startAddress,
      'endAddress': endAddress,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        distance,
        duration,
        durationInTraffic,
        startLocation,
        endLocation,
        startAddress,
        endAddress,
        steps,
      ];
}

class WazeRoute extends Equatable {
  final String id;
  final String summary;
  final double distance; // in meters
  final int duration; // in seconds
  final int durationInTraffic; // in seconds
  final RouteType routeType;
  final List<RouteLeg> legs;
  final List<Location> overviewPolyline;
  final LocationBounds bounds;
  final List<String> warnings;
  final List<String> copyrights;
  final double? tollCost;
  final String? tollCurrency;
  final DateTime createdAt;
  final bool isActive;

  const WazeRoute({
    required this.id,
    required this.summary,
    required this.distance,
    required this.duration,
    required this.durationInTraffic,
    required this.routeType,
    required this.legs,
    required this.overviewPolyline,
    required this.bounds,
    this.warnings = const [],
    this.copyrights = const [],
    this.tollCost,
    this.tollCurrency,
    required this.createdAt,
    this.isActive = false,
  });

  factory WazeRoute.fromJson(Map<String, dynamic> json) {
    return WazeRoute(
      id: json['id'] as String,
      summary: json['summary'] as String,
      distance: (json['distance'] as num).toDouble(),
      duration: json['duration'] as int,
      durationInTraffic: json['durationInTraffic'] as int,
      routeType: RouteType.values.firstWhere(
        (e) => e.toString().split('.').last == json['routeType'],
        orElse: () => RouteType.fastest,
      ),
      legs: (json['legs'] as List)
          .map((leg) => RouteLeg.fromJson(leg as Map<String, dynamic>))
          .toList(),
      overviewPolyline: (json['overviewPolyline'] as List)
          .map((point) => Location.fromJson(point as Map<String, dynamic>))
          .toList(),
      bounds: LocationBounds.fromJson(json['bounds'] as Map<String, dynamic>),
      warnings: List<String>.from(json['warnings'] ?? []),
      copyrights: List<String>.from(json['copyrights'] ?? []),
      tollCost: (json['tollCost'] as num?)?.toDouble(),
      tollCurrency: json['tollCurrency'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summary': summary,
      'distance': distance,
      'duration': duration,
      'durationInTraffic': durationInTraffic,
      'routeType': routeType.toString().split('.').last,
      'legs': legs.map((leg) => leg.toJson()).toList(),
      'overviewPolyline': overviewPolyline.map((point) => point.toJson()).toList(),
      'bounds': bounds.toJson(),
      'warnings': warnings,
      'copyrights': copyrights,
      'tollCost': tollCost,
      'tollCurrency': tollCurrency,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  WazeRoute copyWith({
    String? id,
    String? summary,
    double? distance,
    int? duration,
    int? durationInTraffic,
    RouteType? routeType,
    List<RouteLeg>? legs,
    List<Location>? overviewPolyline,
    LocationBounds? bounds,
    List<String>? warnings,
    List<String>? copyrights,
    double? tollCost,
    String? tollCurrency,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return WazeRoute(
      id: id ?? this.id,
      summary: summary ?? this.summary,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      durationInTraffic: durationInTraffic ?? this.durationInTraffic,
      routeType: routeType ?? this.routeType,
      legs: legs ?? this.legs,
      overviewPolyline: overviewPolyline ?? this.overviewPolyline,
      bounds: bounds ?? this.bounds,
      warnings: warnings ?? this.warnings,
      copyrights: copyrights ?? this.copyrights,
      tollCost: tollCost ?? this.tollCost,
      tollCurrency: tollCurrency ?? this.tollCurrency,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // Helper getters
  String get formattedDistance {
    if (distance < 1000) {
      return '${distance.round()} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
  }

  String get formattedDuration {
    final hours = duration ~/ 3600;
    final minutes = (duration % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get formattedDurationInTraffic {
    final hours = durationInTraffic ~/ 3600;
    final minutes = (durationInTraffic % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  DateTime get estimatedArrival {
    return DateTime.now().add(Duration(seconds: durationInTraffic));
  }

  int get trafficDelay {
    return durationInTraffic - duration;
  }

  String get trafficLevel {
    final delay = trafficDelay;
    if (delay <= 60) return 'Light';
    if (delay <= 300) return 'Moderate';
    if (delay <= 900) return 'Heavy';
    return 'Standstill';
  }

  @override
  List<Object?> get props => [
        id,
        summary,
        distance,
        duration,
        durationInTraffic,
        routeType,
        legs,
        overviewPolyline,
        bounds,
        warnings,
        copyrights,
        tollCost,
        tollCurrency,
        createdAt,
        isActive,
      ];
}

class NavigationState extends Equatable {
  final WazeRoute? currentRoute;
  final int currentStepIndex;
  final Location? currentLocation;
  final double? currentSpeed;
  final double? currentBearing;
  final double distanceToNextStep;
  final int timeToNextStep;
  final bool isNavigating;
  final bool isRerouting;
  final DateTime? navigationStartTime;
  final double totalDistanceTraveled;

  const NavigationState({
    this.currentRoute,
    this.currentStepIndex = 0,
    this.currentLocation,
    this.currentSpeed,
    this.currentBearing,
    this.distanceToNextStep = 0,
    this.timeToNextStep = 0,
    this.isNavigating = false,
    this.isRerouting = false,
    this.navigationStartTime,
    this.totalDistanceTraveled = 0,
  });

  factory NavigationState.fromJson(Map<String, dynamic> json) {
    return NavigationState(
      currentRoute: json['currentRoute'] != null
          ? WazeRoute.fromJson(json['currentRoute'] as Map<String, dynamic>)
          : null,
      currentStepIndex: json['currentStepIndex'] as int? ?? 0,
      currentLocation: json['currentLocation'] != null
          ? Location.fromJson(json['currentLocation'] as Map<String, dynamic>)
          : null,
      currentSpeed: (json['currentSpeed'] as num?)?.toDouble(),
      currentBearing: (json['currentBearing'] as num?)?.toDouble(),
      distanceToNextStep: (json['distanceToNextStep'] as num?)?.toDouble() ?? 0,
      timeToNextStep: json['timeToNextStep'] as int? ?? 0,
      isNavigating: json['isNavigating'] as bool? ?? false,
      isRerouting: json['isRerouting'] as bool? ?? false,
      navigationStartTime: json['navigationStartTime'] != null
          ? DateTime.parse(json['navigationStartTime'] as String)
          : null,
      totalDistanceTraveled: (json['totalDistanceTraveled'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentRoute': currentRoute?.toJson(),
      'currentStepIndex': currentStepIndex,
      'currentLocation': currentLocation?.toJson(),
      'currentSpeed': currentSpeed,
      'currentBearing': currentBearing,
      'distanceToNextStep': distanceToNextStep,
      'timeToNextStep': timeToNextStep,
      'isNavigating': isNavigating,
      'isRerouting': isRerouting,
      'navigationStartTime': navigationStartTime?.toIso8601String(),
      'totalDistanceTraveled': totalDistanceTraveled,
    };
  }

  NavigationState copyWith({
    WazeRoute? currentRoute,
    int? currentStepIndex,
    Location? currentLocation,
    double? currentSpeed,
    double? currentBearing,
    double? distanceToNextStep,
    int? timeToNextStep,
    bool? isNavigating,
    bool? isRerouting,
    DateTime? navigationStartTime,
    double? totalDistanceTraveled,
  }) {
    return NavigationState(
      currentRoute: currentRoute ?? this.currentRoute,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      currentLocation: currentLocation ?? this.currentLocation,
      currentSpeed: currentSpeed ?? this.currentSpeed,
      currentBearing: currentBearing ?? this.currentBearing,
      distanceToNextStep: distanceToNextStep ?? this.distanceToNextStep,
      timeToNextStep: timeToNextStep ?? this.timeToNextStep,
      isNavigating: isNavigating ?? this.isNavigating,
      isRerouting: isRerouting ?? this.isRerouting,
      navigationStartTime: navigationStartTime ?? this.navigationStartTime,
      totalDistanceTraveled: totalDistanceTraveled ?? this.totalDistanceTraveled,
    );
  }

  RouteStep? get currentStep {
    if (currentRoute == null || 
        currentRoute!.legs.isEmpty || 
        currentStepIndex >= currentRoute!.legs.first.steps.length) {
      return null;
    }
    return currentRoute!.legs.first.steps[currentStepIndex];
  }

  RouteStep? get nextStep {
    if (currentRoute == null || 
        currentRoute!.legs.isEmpty || 
        currentStepIndex + 1 >= currentRoute!.legs.first.steps.length) {
      return null;
    }
    return currentRoute!.legs.first.steps[currentStepIndex + 1];
  }

  bool get hasArrived {
    return currentRoute != null && 
           currentStepIndex >= currentRoute!.legs.first.steps.length - 1 &&
           distanceToNextStep < 20; // Within 20 meters of destination
  }

  @override
  List<Object?> get props => [
        currentRoute,
        currentStepIndex,
        currentLocation,
        currentSpeed,
        currentBearing,
        distanceToNextStep,
        timeToNextStep,
        isNavigating,
        isRerouting,
        navigationStartTime,
        totalDistanceTraveled,
      ];
}