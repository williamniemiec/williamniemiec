import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/location_service.dart';
import '../../../shared/services/places_service.dart';
import '../../../core/constants/app_constants.dart';

class ExploreProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final PlacesService _placesService = PlacesService();

  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<Place> _searchResults = [];
  List<String> _searchSuggestions = [];
  Place? _selectedPlace;
  bool _isLoading = false;
  String _searchQuery = '';
  MapType _mapType = MapType.normal;
  double _currentZoom = AppConstants.defaultZoom;

  // Getters
  GoogleMapController? get mapController => _mapController;
  LatLng? get currentLocation => _currentLocation;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  List<Place> get searchResults => _searchResults;
  List<String> get searchSuggestions => _searchSuggestions;
  Place? get selectedPlace => _selectedPlace;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  MapType get mapType => _mapType;
  double get currentZoom => _currentZoom;

  /// Initialize the explore provider
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      // Initialize location service
      final locationInitialized = await _locationService.initialize();
      if (locationInitialized) {
        _currentLocation = await _locationService.getCurrentLatLng();
        if (_currentLocation != null) {
          await _addCurrentLocationMarker();
        }
      } else {
        // Use default location if location service fails
        _currentLocation = const LatLng(
          AppConstants.defaultLatitude,
          AppConstants.defaultLongitude,
        );
      }
    } catch (e) {
      print('Error initializing explore provider: $e');
      _currentLocation = const LatLng(
        AppConstants.defaultLatitude,
        AppConstants.defaultLongitude,
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Set map controller
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  /// Move camera to location
  Future<void> moveCameraToLocation(LatLng location, {double? zoom}) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          location,
          zoom ?? _currentZoom,
        ),
      );
    }
  }

  /// Move camera to current location
  Future<void> moveCameraToCurrentLocation() async {
    if (_currentLocation != null) {
      await moveCameraToLocation(_currentLocation!);
    } else {
      final location = await _locationService.getCurrentLatLng();
      if (location != null) {
        _currentLocation = location;
        await _addCurrentLocationMarker();
        await moveCameraToLocation(location);
      }
    }
  }

  /// Search for places
  Future<void> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _searchQuery = '';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _searchQuery = query;

    try {
      _searchResults = await _placesService.searchPlaces(
        query,
        location: _currentLocation,
      );
      await _addSearchResultMarkers();
    } catch (e) {
      print('Error searching places: $e');
      _searchResults = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Search nearby places by category
  Future<void> searchNearbyPlaces(String type) async {
    if (_currentLocation == null) return;

    _setLoading(true);

    try {
      _searchResults = await _placesService.searchNearbyPlaces(
        _currentLocation!,
        type,
      );
      await _addSearchResultMarkers();
    } catch (e) {
      print('Error searching nearby places: $e');
      _searchResults = [];
    } finally {
      _setLoading(false);
    }
  }

  /// Get autocomplete suggestions
  Future<void> getAutocompleteSuggestions(String input) async {
    if (input.trim().isEmpty) {
      _searchSuggestions = [];
      notifyListeners();
      return;
    }

    try {
      _searchSuggestions = await _placesService.getAutocompleteSuggestions(
        input,
        location: _currentLocation,
      );
    } catch (e) {
      print('Error getting autocomplete suggestions: $e');
      _searchSuggestions = [];
    }
    notifyListeners();
  }

  /// Select a place
  Future<void> selectPlace(Place place) async {
    _selectedPlace = place;
    
    // Move camera to selected place
    await moveCameraToLocation(place.location);
    
    // Highlight selected place marker
    await _addSelectedPlaceMarker(place);
    
    notifyListeners();
  }

  /// Clear selected place
  void clearSelectedPlace() {
    _selectedPlace = null;
    _removeSelectedPlaceMarker();
    notifyListeners();
  }

  /// Change map type
  void changeMapType(MapType type) {
    _mapType = type;
    notifyListeners();
  }

  /// Update current zoom level
  void updateZoom(double zoom) {
    _currentZoom = zoom;
    notifyListeners();
  }

  /// Clear search results
  void clearSearchResults() {
    _searchResults = [];
    _searchQuery = '';
    _searchSuggestions = [];
    _clearSearchMarkers();
    notifyListeners();
  }

  /// Add current location marker
  Future<void> _addCurrentLocationMarker() async {
    if (_currentLocation == null) return;

    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: _currentLocation!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: 'Your Location'),
    );

    _markers.add(marker);
    notifyListeners();
  }

  /// Add search result markers
  Future<void> _addSearchResultMarkers() async {
    // Clear existing search markers
    _clearSearchMarkers();

    for (int i = 0; i < _searchResults.length; i++) {
      final place = _searchResults[i];
      final marker = Marker(
        markerId: MarkerId('search_result_$i'),
        position: place.location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.address,
        ),
        onTap: () => selectPlace(place),
      );
      _markers.add(marker);
    }
    notifyListeners();
  }

  /// Add selected place marker
  Future<void> _addSelectedPlaceMarker(Place place) async {
    final marker = Marker(
      markerId: const MarkerId('selected_place'),
      position: place.location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(
        title: place.name,
        snippet: place.address,
      ),
    );

    _markers.removeWhere((m) => m.markerId.value == 'selected_place');
    _markers.add(marker);
    notifyListeners();
  }

  /// Remove selected place marker
  void _removeSelectedPlaceMarker() {
    _markers.removeWhere((m) => m.markerId.value == 'selected_place');
    notifyListeners();
  }

  /// Clear search markers
  void _clearSearchMarkers() {
    _markers.removeWhere((m) => m.markerId.value.startsWith('search_result_'));
    notifyListeners();
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}