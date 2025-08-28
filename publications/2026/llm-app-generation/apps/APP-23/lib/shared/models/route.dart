import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TravelMode {
  driving,
  walking,
  bicycling,
  transit,
}

enum RouteStatus {
  calculating,
  ready,
  error,
}

class MapRoute {
  final String id;
  final List<LatLng> polylinePoints;
  final String distance;
  final String duration;
  final String durationInTraffic;
  final TravelMode travelMode;
  final RouteStatus status;
  final List<RouteStep> steps;
  final LatLng startLocation;
  final LatLng endLocation;
  final String startAddress;
  final String endAddress;
  final List<LatLng> waypoints;

  MapRoute({
    required this.id,
    required this.polylinePoints,
    required this.distance,
    required this.duration,
    required this.durationInTraffic,
    required this.travelMode,
    required this.status,
    required this.steps,
    required this.startLocation,
    required this.endLocation,
    required this.startAddress,
    required this.endAddress,
    this.waypoints = const [],
  });

  factory MapRoute.fromJson(Map<String, dynamic> json) {
    final leg = json['legs'][0];
    final overview = json['overview_polyline']['points'];
    
    return MapRoute(
      id: json['summary'] ?? '',
      polylinePoints: _decodePolyline(overview),
      distance: leg['distance']['text'] ?? '',
      duration: leg['duration']['text'] ?? '',
      durationInTraffic: leg['duration_in_traffic']?['text'] ?? '',
      travelMode: TravelMode.driving, // Default, should be parsed from request
      status: RouteStatus.ready,
      steps: (leg['steps'] as List?)
          ?.map((step) => RouteStep.fromJson(step))
          .toList() ?? [],
      startLocation: LatLng(
        leg['start_location']['lat']?.toDouble() ?? 0.0,
        leg['start_location']['lng']?.toDouble() ?? 0.0,
      ),
      endLocation: LatLng(
        leg['end_location']['lat']?.toDouble() ?? 0.0,
        leg['end_location']['lng']?.toDouble() ?? 0.0,
      ),
      startAddress: leg['start_address'] ?? '',
      endAddress: leg['end_address'] ?? '',
    );
  }

  static List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'polylinePoints': polylinePoints.map((point) => {
        'lat': point.latitude,
        'lng': point.longitude,
      }).toList(),
      'distance': distance,
      'duration': duration,
      'durationInTraffic': durationInTraffic,
      'travelMode': travelMode.toString(),
      'status': status.toString(),
      'startLocation': {
        'lat': startLocation.latitude,
        'lng': startLocation.longitude,
      },
      'endLocation': {
        'lat': endLocation.latitude,
        'lng': endLocation.longitude,
      },
      'startAddress': startAddress,
      'endAddress': endAddress,
      'waypoints': waypoints.map((point) => {
        'lat': point.latitude,
        'lng': point.longitude,
      }).toList(),
    };
  }

  MapRoute copyWith({
    String? id,
    List<LatLng>? polylinePoints,
    String? distance,
    String? duration,
    String? durationInTraffic,
    TravelMode? travelMode,
    RouteStatus? status,
    List<RouteStep>? steps,
    LatLng? startLocation,
    LatLng? endLocation,
    String? startAddress,
    String? endAddress,
    List<LatLng>? waypoints,
  }) {
    return MapRoute(
      id: id ?? this.id,
      polylinePoints: polylinePoints ?? this.polylinePoints,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      durationInTraffic: durationInTraffic ?? this.durationInTraffic,
      travelMode: travelMode ?? this.travelMode,
      status: status ?? this.status,
      steps: steps ?? this.steps,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      startAddress: startAddress ?? this.startAddress,
      endAddress: endAddress ?? this.endAddress,
      waypoints: waypoints ?? this.waypoints,
    );
  }
}

class RouteStep {
  final String instruction;
  final String distance;
  final String duration;
  final LatLng startLocation;
  final LatLng endLocation;
  final String maneuver;

  RouteStep({
    required this.instruction,
    required this.distance,
    required this.duration,
    required this.startLocation,
    required this.endLocation,
    required this.maneuver,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      instruction: json['html_instructions'] ?? '',
      distance: json['distance']['text'] ?? '',
      duration: json['duration']['text'] ?? '',
      startLocation: LatLng(
        json['start_location']['lat']?.toDouble() ?? 0.0,
        json['start_location']['lng']?.toDouble() ?? 0.0,
      ),
      endLocation: LatLng(
        json['end_location']['lat']?.toDouble() ?? 0.0,
        json['end_location']['lng']?.toDouble() ?? 0.0,
      ),
      maneuver: json['maneuver'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'html_instructions': instruction,
      'distance': {'text': distance},
      'duration': {'text': duration},
      'start_location': {
        'lat': startLocation.latitude,
        'lng': startLocation.longitude,
      },
      'end_location': {
        'lat': endLocation.latitude,
        'lng': endLocation.longitude,
      },
      'maneuver': maneuver,
    };
  }
}