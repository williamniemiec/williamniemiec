import 'package:equatable/equatable.dart';
import 'location.dart';
import 'user.dart';

enum TripStatus {
  requested,
  accepted,
  driverArriving,
  inProgress,
  completed,
  cancelled,
}

enum RideType {
  uberX,
  comfort,
  uberXL,
  black,
  premier,
  green,
  pet,
}

class Trip extends Equatable {
  final String id;
  final String userId;
  final String? driverId;
  final Location pickupLocation;
  final Location destinationLocation;
  final List<Location> waypoints;
  final RideType rideType;
  final TripStatus status;
  final DateTime requestedAt;
  final DateTime? acceptedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final double? estimatedFare;
  final double? actualFare;
  final double? distance; // in kilometers
  final int? estimatedDuration; // in minutes
  final int? actualDuration; // in minutes
  final String? paymentMethodId;
  final double? tip;
  final int? rating;
  final String? feedback;
  final Driver? driver;

  const Trip({
    required this.id,
    required this.userId,
    this.driverId,
    required this.pickupLocation,
    required this.destinationLocation,
    this.waypoints = const [],
    required this.rideType,
    required this.status,
    required this.requestedAt,
    this.acceptedAt,
    this.startedAt,
    this.completedAt,
    this.estimatedFare,
    this.actualFare,
    this.distance,
    this.estimatedDuration,
    this.actualDuration,
    this.paymentMethodId,
    this.tip,
    this.rating,
    this.feedback,
    this.driver,
  });

  bool get isActive => status == TripStatus.requested ||
      status == TripStatus.accepted ||
      status == TripStatus.driverArriving ||
      status == TripStatus.inProgress;

  bool get isCompleted => status == TripStatus.completed;
  bool get isCancelled => status == TripStatus.cancelled;

  String get statusDisplayName {
    switch (status) {
      case TripStatus.requested:
        return 'Finding driver...';
      case TripStatus.accepted:
        return 'Driver assigned';
      case TripStatus.driverArriving:
        return 'Driver arriving';
      case TripStatus.inProgress:
        return 'In progress';
      case TripStatus.completed:
        return 'Completed';
      case TripStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get rideTypeDisplayName {
    switch (rideType) {
      case RideType.uberX:
        return 'UberX';
      case RideType.comfort:
        return 'Comfort';
      case RideType.uberXL:
        return 'UberXL';
      case RideType.black:
        return 'Black';
      case RideType.premier:
        return 'Premier';
      case RideType.green:
        return 'Green';
      case RideType.pet:
        return 'Pet';
    }
  }

  Trip copyWith({
    String? id,
    String? userId,
    String? driverId,
    Location? pickupLocation,
    Location? destinationLocation,
    List<Location>? waypoints,
    RideType? rideType,
    TripStatus? status,
    DateTime? requestedAt,
    DateTime? acceptedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    double? estimatedFare,
    double? actualFare,
    double? distance,
    int? estimatedDuration,
    int? actualDuration,
    String? paymentMethodId,
    double? tip,
    int? rating,
    String? feedback,
    Driver? driver,
  }) {
    return Trip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      driverId: driverId ?? this.driverId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      waypoints: waypoints ?? this.waypoints,
      rideType: rideType ?? this.rideType,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      actualFare: actualFare ?? this.actualFare,
      distance: distance ?? this.distance,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      tip: tip ?? this.tip,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
      driver: driver ?? this.driver,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'driverId': driverId,
      'pickupLocation': pickupLocation.toJson(),
      'destinationLocation': destinationLocation.toJson(),
      'waypoints': waypoints.map((w) => w.toJson()).toList(),
      'rideType': rideType.name,
      'status': status.name,
      'requestedAt': requestedAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'estimatedFare': estimatedFare,
      'actualFare': actualFare,
      'distance': distance,
      'estimatedDuration': estimatedDuration,
      'actualDuration': actualDuration,
      'paymentMethodId': paymentMethodId,
      'tip': tip,
      'rating': rating,
      'feedback': feedback,
      'driver': driver?.toJson(),
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      userId: json['userId'] as String,
      driverId: json['driverId'] as String?,
      pickupLocation: Location.fromJson(json['pickupLocation'] as Map<String, dynamic>),
      destinationLocation: Location.fromJson(json['destinationLocation'] as Map<String, dynamic>),
      waypoints: (json['waypoints'] as List<dynamic>?)
          ?.map((w) => Location.fromJson(w as Map<String, dynamic>))
          .toList() ?? [],
      rideType: RideType.values.firstWhere((e) => e.name == json['rideType']),
      status: TripStatus.values.firstWhere((e) => e.name == json['status']),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt'] as String) : null,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      estimatedFare: (json['estimatedFare'] as num?)?.toDouble(),
      actualFare: (json['actualFare'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      estimatedDuration: json['estimatedDuration'] as int?,
      actualDuration: json['actualDuration'] as int?,
      paymentMethodId: json['paymentMethodId'] as String?,
      tip: (json['tip'] as num?)?.toDouble(),
      rating: json['rating'] as int?,
      feedback: json['feedback'] as String?,
      driver: json['driver'] != null ? Driver.fromJson(json['driver'] as Map<String, dynamic>) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        driverId,
        pickupLocation,
        destinationLocation,
        waypoints,
        rideType,
        status,
        requestedAt,
        acceptedAt,
        startedAt,
        completedAt,
        estimatedFare,
        actualFare,
        distance,
        estimatedDuration,
        actualDuration,
        paymentMethodId,
        tip,
        rating,
        feedback,
        driver,
      ];
}

class Driver extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
  final double rating;
  final int totalTrips;
  final String phoneNumber;
  final Vehicle vehicle;
  final Location? currentLocation;

  const Driver({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
    required this.rating,
    required this.totalTrips,
    required this.phoneNumber,
    required this.vehicle,
    this.currentLocation,
  });

  String get fullName => '$firstName $lastName';

  Driver copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? profileImageUrl,
    double? rating,
    int? totalTrips,
    String? phoneNumber,
    Vehicle? vehicle,
    Location? currentLocation,
  }) {
    return Driver(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      vehicle: vehicle ?? this.vehicle,
      currentLocation: currentLocation ?? this.currentLocation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
      'rating': rating,
      'totalTrips': totalTrips,
      'phoneNumber': phoneNumber,
      'vehicle': vehicle.toJson(),
      'currentLocation': currentLocation?.toJson(),
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      totalTrips: json['totalTrips'] as int,
      phoneNumber: json['phoneNumber'] as String,
      vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
      currentLocation: json['currentLocation'] != null
          ? Location.fromJson(json['currentLocation'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        profileImageUrl,
        rating,
        totalTrips,
        phoneNumber,
        vehicle,
        currentLocation,
      ];
}

class Vehicle extends Equatable {
  final String make;
  final String model;
  final String year;
  final String color;
  final String licensePlate;

  const Vehicle({
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlate,
  });

  String get displayName => '$year $make $model';

  Vehicle copyWith({
    String? make,
    String? model,
    String? year,
    String? color,
    String? licensePlate,
  }) {
    return Vehicle(
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      licensePlate: licensePlate ?? this.licensePlate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'licensePlate': licensePlate,
    };
  }

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      color: json['color'] as String,
      licensePlate: json['licensePlate'] as String,
    );
  }

  @override
  List<Object?> get props => [make, model, year, color, licensePlate];
}

class RideOption extends Equatable {
  final RideType type;
  final String name;
  final String description;
  final double estimatedFare;
  final int estimatedTime; // in minutes
  final int capacity;
  final String iconPath;
  final bool isAvailable;

  const RideOption({
    required this.type,
    required this.name,
    required this.description,
    required this.estimatedFare,
    required this.estimatedTime,
    required this.capacity,
    required this.iconPath,
    this.isAvailable = true,
  });

  RideOption copyWith({
    RideType? type,
    String? name,
    String? description,
    double? estimatedFare,
    int? estimatedTime,
    int? capacity,
    String? iconPath,
    bool? isAvailable,
  }) {
    return RideOption(
      type: type ?? this.type,
      name: name ?? this.name,
      description: description ?? this.description,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      capacity: capacity ?? this.capacity,
      iconPath: iconPath ?? this.iconPath,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  List<Object?> get props => [
        type,
        name,
        description,
        estimatedFare,
        estimatedTime,
        capacity,
        iconPath,
        isAvailable,
      ];
}