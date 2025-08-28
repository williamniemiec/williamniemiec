import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';
import '../../core/constants/app_constants.dart';

class LocationService {
  static const String _savedLocationsKey = AppConstants.savedLocationsKey;
  static const String _currentLocationKey = AppConstants.currentLocationKey;

  // Get current device location
  Future<Location> getCurrentLocation() async {
    try {
      final position = await _getCurrentPosition();
      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final placemark = placemarks.first;
      
      return Location(
        name: placemark.locality ?? placemark.subAdministrativeArea ?? 'Unknown',
        state: placemark.administrativeArea ?? '',
        country: placemark.country ?? '',
        latitude: position.latitude,
        longitude: position.longitude,
        timezone: 'UTC', // Would need additional service for timezone
        timezoneOffset: 0,
      );
    } catch (e) {
      throw Exception('Error getting current location: $e');
    }
  }

  // Get current position with permission handling
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, we cannot request permissions.'
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Save a location to favorites
  Future<void> saveLocation(Location location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocations = await getSavedLocations();
      
      // Check if location already exists
      final existingIndex = savedLocations.indexWhere(
        (saved) => saved.location.latitude == location.latitude && 
                  saved.location.longitude == location.longitude,
      );
      
      if (existingIndex == -1) {
        final savedLocation = SavedLocation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          location: location,
          isDefault: savedLocations.isEmpty,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        savedLocations.add(savedLocation);
        
        final locationsJson = savedLocations.map((loc) => loc.toJson()).toList();
        await prefs.setString(_savedLocationsKey, json.encode(locationsJson));
      }
    } catch (e) {
      throw Exception('Error saving location: $e');
    }
  }

  // Get all saved locations
  Future<List<SavedLocation>> getSavedLocations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsString = prefs.getString(_savedLocationsKey);
      
      if (locationsString == null) {
        return [];
      }
      
      final locationsList = json.decode(locationsString) as List<dynamic>;
      return locationsList
          .map((json) => SavedLocation.fromJson(json))
          .toList();
    } catch (e) {
      print('Error getting saved locations: $e');
      return [];
    }
  }

  // Remove a saved location
  Future<void> removeSavedLocation(String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocations = await getSavedLocations();
      
      savedLocations.removeWhere((location) => location.id == locationId);
      
      final locationsJson = savedLocations.map((loc) => loc.toJson()).toList();
      await prefs.setString(_savedLocationsKey, json.encode(locationsJson));
    } catch (e) {
      throw Exception('Error removing saved location: $e');
    }
  }

  // Set default location
  Future<void> setDefaultLocation(String locationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocations = await getSavedLocations();
      
      // Update all locations to not be default
      for (int i = 0; i < savedLocations.length; i++) {
        savedLocations[i] = SavedLocation(
          id: savedLocations[i].id,
          location: savedLocations[i].location,
          isDefault: savedLocations[i].id == locationId,
          createdAt: savedLocations[i].createdAt,
          updatedAt: DateTime.now(),
        );
      }
      
      final locationsJson = savedLocations.map((loc) => loc.toJson()).toList();
      await prefs.setString(_savedLocationsKey, json.encode(locationsJson));
    } catch (e) {
      throw Exception('Error setting default location: $e');
    }
  }

  // Get default location
  Future<SavedLocation?> getDefaultLocation() async {
    try {
      final savedLocations = await getSavedLocations();
      return savedLocations.firstWhere(
        (location) => location.isDefault,
        orElse: () => savedLocations.isNotEmpty ? savedLocations.first : throw StateError('No default location found'),
      );
    } catch (e) {
      return null;
    }
  }

  // Search for locations by name
  Future<List<Location>> searchLocations(String query) async {
    try {
      final locations = await geocoding.locationFromAddress(query);
      
      List<Location> results = [];
      
      for (final location in locations.take(5)) {
        try {
          final placemarks = await geocoding.placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );
          
          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            results.add(Location(
              name: placemark.locality ?? placemark.subAdministrativeArea ?? query,
              state: placemark.administrativeArea ?? '',
              country: placemark.country ?? '',
              latitude: location.latitude,
              longitude: location.longitude,
              timezone: 'UTC',
              timezoneOffset: 0,
            ));
          }
        } catch (e) {
          // Skip locations that can't be reverse geocoded
          continue;
        }
      }
      
      return results;
    } catch (e) {
      throw Exception('Error searching locations: $e');
    }
  }

  // Get location from coordinates
  Future<Location> getLocationFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isEmpty) {
        throw Exception('No location found for coordinates');
      }
      
      final placemark = placemarks.first;
      
      return Location(
        name: placemark.locality ?? placemark.subAdministrativeArea ?? 'Unknown',
        state: placemark.administrativeArea ?? '',
        country: placemark.country ?? '',
        latitude: latitude,
        longitude: longitude,
        timezone: 'UTC',
        timezoneOffset: 0,
      );
    } catch (e) {
      throw Exception('Error getting location from coordinates: $e');
    }
  }

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  // Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  // Calculate distance between two locations
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Get location settings
  Future<Map<String, dynamic>> getLocationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString('location_settings');
      
      if (settingsString == null) {
        return {
          'auto_location': true,
          'location_accuracy': 'high',
          'background_location': false,
        };
      }
      
      return json.decode(settingsString);
    } catch (e) {
      return {
        'auto_location': true,
        'location_accuracy': 'high',
        'background_location': false,
      };
    }
  }

  // Save location settings
  Future<void> saveLocationSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('location_settings', json.encode(settings));
    } catch (e) {
      throw Exception('Error saving location settings: $e');
    }
  }
}