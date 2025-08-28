import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:permission_handler/permission_handler.dart';
import '../models/location.dart' as app_models;

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamController<app_models.Location>? _locationController;
  StreamSubscription<Position>? _positionSubscription;

  Stream<app_models.Location> get locationStream {
    _locationController ??= StreamController<app_models.Location>.broadcast();
    return _locationController!.stream;
  }

  /// Check if location permissions are granted
  Future<bool> hasLocationPermission() async {
    final permission = await Permission.location.status;
    return permission == PermissionStatus.granted;
  }

  /// Request location permissions
  Future<bool> requestLocationPermission() async {
    final permission = await Permission.location.request();
    return permission == PermissionStatus.granted;
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Get current location
  Future<app_models.Location?> getCurrentLocation() async {
    try {
      // Check permissions
      if (!await hasLocationPermission()) {
        final granted = await requestLocationPermission();
        if (!granted) {
          throw LocationPermissionException('Location permission denied');
        }
      }

      // Check if location services are enabled
      if (!await isLocationServiceEnabled()) {
        throw LocationServiceException('Location services are disabled');
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Convert to app location model
      final location = app_models.Location(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Get address for the location
      return await _addAddressToLocation(location);
    } catch (e) {
      throw LocationException('Failed to get current location: $e');
    }
  }

  /// Start listening to location updates
  Future<void> startLocationUpdates() async {
    try {
      if (!await hasLocationPermission()) {
        final granted = await requestLocationPermission();
        if (!granted) {
          throw LocationPermissionException('Location permission denied');
        }
      }

      if (!await isLocationServiceEnabled()) {
        throw LocationServiceException('Location services are disabled');
      }

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) async {
          final location = app_models.Location(
            latitude: position.latitude,
            longitude: position.longitude,
          );

          final locationWithAddress = await _addAddressToLocation(location);
          _locationController?.add(locationWithAddress);
        },
        onError: (error) {
          _locationController?.addError(LocationException('Location update failed: $error'));
        },
      );
    } catch (e) {
      throw LocationException('Failed to start location updates: $e');
    }
  }

  /// Stop listening to location updates
  void stopLocationUpdates() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  /// Get address from coordinates
  Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return _formatAddress(placemark);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get coordinates from address
  Future<app_models.Location?> getLocationFromAddress(String address) async {
    try {
      final locations = await geocoding.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return app_models.Location(
          latitude: location.latitude,
          longitude: location.longitude,
          address: address,
        );
      }
      return null;
    } catch (e) {
      throw LocationException('Failed to get location from address: $e');
    }
  }

  /// Calculate distance between two locations in kilometers
  double calculateDistance(app_models.Location from, app_models.Location to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    ) / 1000; // Convert to kilometers
  }

  /// Calculate bearing between two locations
  double calculateBearing(app_models.Location from, app_models.Location to) {
    return Geolocator.bearingBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Add address information to a location
  Future<app_models.Location> _addAddressToLocation(app_models.Location location) async {
    final address = await getAddressFromCoordinates(location.latitude, location.longitude);
    return location.copyWith(address: address);
  }

  /// Format address from placemark
  String _formatAddress(geocoding.Placemark placemark) {
    final components = <String>[];
    
    if (placemark.street?.isNotEmpty == true) {
      components.add(placemark.street!);
    }
    
    if (placemark.subLocality?.isNotEmpty == true) {
      components.add(placemark.subLocality!);
    }
    
    if (placemark.locality?.isNotEmpty == true) {
      components.add(placemark.locality!);
    }
    
    if (placemark.administrativeArea?.isNotEmpty == true) {
      components.add(placemark.administrativeArea!);
    }
    
    if (placemark.country?.isNotEmpty == true) {
      components.add(placemark.country!);
    }

    return components.join(', ');
  }

  /// Dispose resources
  void dispose() {
    stopLocationUpdates();
    _locationController?.close();
    _locationController = null;
  }
}

// Custom exceptions
class LocationException implements Exception {
  final String message;
  LocationException(this.message);
  
  @override
  String toString() => 'LocationException: $message';
}

class LocationPermissionException extends LocationException {
  LocationPermissionException(String message) : super(message);
}

class LocationServiceException extends LocationException {
  LocationServiceException(String message) : super(message);
}