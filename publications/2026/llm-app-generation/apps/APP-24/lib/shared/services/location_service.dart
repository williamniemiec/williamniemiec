import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/models.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamController<Location>? _locationController;
  StreamSubscription<Position>? _positionSubscription;
  Location? _currentLocation;
  bool _isListening = false;

  Stream<Location> get locationStream {
    _locationController ??= StreamController<Location>.broadcast();
    return _locationController!.stream;
  }

  Location? get currentLocation => _currentLocation;
  bool get isListening => _isListening;

  Future<bool> requestPermissions() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return false;
      }

      // Request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error requesting location permissions: $e');
      return false;
    }
  }

  Future<Location?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestPermissions();
      if (!hasPermission) return null;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      _currentLocation = Location(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: position.accuracy,
        bearing: position.heading,
        speed: position.speed,
        timestamp: position.timestamp,
      );

      return _currentLocation;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  Future<bool> startLocationUpdates() async {
    if (_isListening) return true;

    try {
      bool hasPermission = await requestPermissions();
      if (!hasPermission) return false;

      _locationController ??= StreamController<Location>.broadcast();

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _currentLocation = Location(
            latitude: position.latitude,
            longitude: position.longitude,
            altitude: position.altitude,
            accuracy: position.accuracy,
            bearing: position.heading,
            speed: position.speed,
            timestamp: position.timestamp,
          );

          _locationController?.add(_currentLocation!);
        },
        onError: (error) {
          debugPrint('Location stream error: $error');
        },
      );

      _isListening = true;
      return true;
    } catch (e) {
      debugPrint('Error starting location updates: $e');
      return false;
    }
  }

  void stopLocationUpdates() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _isListening = false;
  }

  Future<double> distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  Future<double> bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) async {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Check if user is moving based on speed
  bool isUserMoving() {
    if (_currentLocation?.speed == null) return false;
    return (_currentLocation!.speed! * 3.6) > 5; // 5 km/h threshold
  }

  // Get formatted speed in km/h
  String getFormattedSpeed() {
    if (_currentLocation?.speed == null) return '0 km/h';
    double speedKmh = _currentLocation!.speed! * 3.6;
    return '${speedKmh.round()} km/h';
  }

  // Check if location accuracy is good enough for navigation
  bool hasGoodAccuracy() {
    if (_currentLocation?.accuracy == null) return false;
    return _currentLocation!.accuracy! <= 20; // 20 meters or better
  }

  void dispose() {
    stopLocationUpdates();
    _locationController?.close();
    _locationController = null;
  }
}

// Location utility functions
class LocationUtils {
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    }
  }

  static String formatBearing(double bearing) {
    const List<String> directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];
    
    int index = ((bearing + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  static bool isLocationInBounds(Location location, LocationBounds bounds) {
    return location.latitude >= bounds.southwest.latitude &&
           location.latitude <= bounds.northeast.latitude &&
           location.longitude >= bounds.southwest.longitude &&
           location.longitude <= bounds.northeast.longitude;
  }

  static LocationBounds createBoundsFromLocations(List<Location> locations) {
    if (locations.isEmpty) {
      throw ArgumentError('Cannot create bounds from empty location list');
    }

    double minLat = locations.first.latitude;
    double maxLat = locations.first.latitude;
    double minLng = locations.first.longitude;
    double maxLng = locations.first.longitude;

    for (Location location in locations) {
      minLat = minLat < location.latitude ? minLat : location.latitude;
      maxLat = maxLat > location.latitude ? maxLat : location.latitude;
      minLng = minLng < location.longitude ? minLng : location.longitude;
      maxLng = maxLng > location.longitude ? maxLng : location.longitude;
    }

    return LocationBounds(
      southwest: Location(latitude: minLat, longitude: minLng),
      northeast: Location(latitude: maxLat, longitude: maxLng),
    );
  }

  static Location interpolateLocation(
    Location start,
    Location end,
    double fraction,
  ) {
    double lat = start.latitude + (end.latitude - start.latitude) * fraction;
    double lng = start.longitude + (end.longitude - start.longitude) * fraction;
    
    return Location(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    );
  }
}