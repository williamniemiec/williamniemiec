import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  bool _isLocationServiceEnabled = false;

  Position? get currentPosition => _currentPosition;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;

  /// Initialize location service and check permissions
  Future<bool> initialize() async {
    try {
      // Check if location services are enabled
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_isLocationServiceEnabled) {
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      // Get current position
      await getCurrentLocation();
      return true;
    } catch (e) {
      print('Error initializing location service: $e');
      return false;
    }
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      if (!_isLocationServiceEnabled) {
        await initialize();
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return _currentPosition;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Get current location as LatLng
  Future<LatLng?> getCurrentLatLng() async {
    final position = await getCurrentLocation();
    if (position != null) {
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  /// Watch position changes
  Stream<Position> watchPosition() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  /// Calculate distance between two points
  double calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Calculate bearing between two points
  double calculateBearing(LatLng start, LatLng end) {
    return Geolocator.bearingBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    final permission = await Permission.location.status;
    return permission.isGranted;
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final permission = await Permission.location.request();
    return permission.isGranted;
  }

  /// Open app settings for location permission
  Future<void> openLocationSettings() async {
    await openAppSettings();
  }

  /// Format distance for display
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()} m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  /// Format duration for display
  String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '${hours}h ${minutes}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  /// Check if a location is within a certain radius
  bool isWithinRadius(LatLng center, LatLng point, double radiusInMeters) {
    final distance = calculateDistance(center, point);
    return distance <= radiusInMeters;
  }

  /// Get location settings for different accuracy levels
  LocationSettings getLocationSettings({LocationAccuracy accuracy = LocationAccuracy.high}) {
    return LocationSettings(
      accuracy: accuracy,
      distanceFilter: accuracy == LocationAccuracy.high ? 5 : 10,
    );
  }
}