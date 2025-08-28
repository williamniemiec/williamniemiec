import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/models.dart';
import '../../core/constants/app_constants.dart';

class PlacesService {
  static final PlacesService _instance = PlacesService._internal();
  factory PlacesService() => _instance;
  PlacesService._internal();

  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  final String _directionsUrl = 'https://maps.googleapis.com/maps/api/directions';

  /// Search for places using text query
  Future<List<Place>> searchPlaces(String query, {LatLng? location}) async {
    try {
      final String url = location != null
          ? '$_baseUrl/textsearch/json?query=$query&location=${location.latitude},${location.longitude}&radius=50000&key=${AppConstants.placesApiKey}'
          : '$_baseUrl/textsearch/json?query=$query&key=${AppConstants.placesApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        
        return results
            .take(AppConstants.maxSearchResults)
            .map((result) => Place.fromJson(result))
            .toList();
      } else {
        throw Exception('Failed to search places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  /// Search for nearby places by type
  Future<List<Place>> searchNearbyPlaces(
    LatLng location,
    String type, {
    int radius = 5000,
  }) async {
    try {
      final String url = '$_baseUrl/nearbysearch/json?'
          'location=${location.latitude},${location.longitude}&'
          'radius=$radius&'
          'type=$type&'
          'key=${AppConstants.placesApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        
        return results
            .take(AppConstants.maxSearchResults)
            .map((result) => Place.fromJson(result))
            .toList();
      } else {
        throw Exception('Failed to search nearby places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching nearby places: $e');
      return [];
    }
  }

  /// Get place details by place ID
  Future<Place?> getPlaceDetails(String placeId) async {
    try {
      final String url = '$_baseUrl/details/json?'
          'place_id=$placeId&'
          'fields=place_id,name,formatted_address,geometry,formatted_phone_number,website,rating,user_ratings_total,photos,opening_hours,price_level,types&'
          'key=${AppConstants.placesApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];
        
        if (result != null) {
          return Place.fromJson(result);
        }
      } else {
        throw Exception('Failed to get place details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
    return null;
  }

  /// Get autocomplete suggestions
  Future<List<String>> getAutocompleteSuggestions(
    String input, {
    LatLng? location,
  }) async {
    try {
      final String url = location != null
          ? '$_baseUrl/autocomplete/json?input=$input&location=${location.latitude},${location.longitude}&radius=50000&key=${AppConstants.placesApiKey}'
          : '$_baseUrl/autocomplete/json?input=$input&key=${AppConstants.placesApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> predictions = data['predictions'] ?? [];
        
        return predictions
            .map((prediction) => prediction['description'] as String)
            .toList();
      } else {
        throw Exception('Failed to get autocomplete suggestions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting autocomplete suggestions: $e');
      return [];
    }
  }

  /// Get directions between two points
  Future<MapRoute?> getDirections(
    LatLng origin,
    LatLng destination, {
    TravelMode mode = TravelMode.driving,
    List<LatLng> waypoints = const [],
  }) async {
    try {
      String modeString = _getTravelModeString(mode);
      String waypointsString = '';
      
      if (waypoints.isNotEmpty) {
        waypointsString = '&waypoints=' + 
            waypoints.map((wp) => '${wp.latitude},${wp.longitude}').join('|');
      }

      final String url = '$_directionsUrl/json?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'mode=$modeString$waypointsString&'
          'key=${AppConstants.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> routes = data['routes'] ?? [];
        
        if (routes.isNotEmpty) {
          final route = MapRoute.fromJson(routes[0]);
          return route.copyWith(travelMode: mode);
        }
      } else {
        throw Exception('Failed to get directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting directions: $e');
    }
    return null;
  }

  /// Get photo URL for a place
  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$_baseUrl/photo?'
        'maxwidth=$maxWidth&'
        'photo_reference=$photoReference&'
        'key=${AppConstants.placesApiKey}';
  }

  /// Geocode an address to get coordinates
  Future<LatLng?> geocodeAddress(String address) async {
    try {
      final String url = 'https://maps.googleapis.com/maps/api/geocode/json?'
          'address=${Uri.encodeComponent(address)}&'
          'key=${AppConstants.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        
        if (results.isNotEmpty) {
          final location = results[0]['geometry']['location'];
          return LatLng(
            location['lat']?.toDouble() ?? 0.0,
            location['lng']?.toDouble() ?? 0.0,
          );
        }
      } else {
        throw Exception('Failed to geocode address: ${response.statusCode}');
      }
    } catch (e) {
      print('Error geocoding address: $e');
    }
    return null;
  }

  /// Reverse geocode coordinates to get address
  Future<String?> reverseGeocode(LatLng location) async {
    try {
      final String url = 'https://maps.googleapis.com/maps/api/geocode/json?'
          'latlng=${location.latitude},${location.longitude}&'
          'key=${AppConstants.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        
        if (results.isNotEmpty) {
          return results[0]['formatted_address'] as String?;
        }
      } else {
        throw Exception('Failed to reverse geocode: ${response.statusCode}');
      }
    } catch (e) {
      print('Error reverse geocoding: $e');
    }
    return null;
  }

  String _getTravelModeString(TravelMode mode) {
    switch (mode) {
      case TravelMode.driving:
        return 'driving';
      case TravelMode.walking:
        return 'walking';
      case TravelMode.bicycling:
        return 'bicycling';
      case TravelMode.transit:
        return 'transit';
    }
  }
}