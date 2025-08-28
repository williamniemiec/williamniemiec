import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/location_service.dart';
import '../../../shared/services/places_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class NavigationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final PlacesService _placesService = PlacesService();

  MapRoute? _currentRoute;
  LatLng? _currentLocation;
  LatLng? _destination;
  TravelMode _selectedTravelMode = TravelMode.driving;
  bool _isNavigating = false;
  bool _isCalculatingRoute = false;
  List<RouteStep> _currentSteps = [];
  int _currentStepIndex = 0;
  String _nextInstruction = '';
  String _remainingDistance = '';
  String _remainingTime = '';
  Set<Polyline> _routePolylines = {};
  Set<Marker> _navigationMarkers = {};

  // Getters
  MapRoute? get currentRoute => _currentRoute;
  LatLng? get currentLocation => _currentLocation;
  LatLng? get destination => _destination;
  TravelMode get selectedTravelMode => _selectedTravelMode;
  bool get isNavigating => _isNavigating;
  bool get isCalculatingRoute => _isCalculatingRoute;
  List<RouteStep> get currentSteps => _currentSteps;
  int get currentStepIndex => _currentStepIndex;
  String get nextInstruction => _nextInstruction;
  String get remainingDistance => _remainingDistance;
  String get remainingTime => _remainingTime;
  Set<Polyline> get routePolylines => _routePolylines;
  Set<Marker> get navigationMarkers => _navigationMarkers;

  /// Initialize navigation provider
  Future<void> initialize() async {
    try {
      await _locationService.initialize();
      _currentLocation = await _locationService.getCurrentLatLng();
      if (_currentLocation != null) {
        await _addCurrentLocationMarker();
      }
    } catch (e) {
      print('Error initializing navigation provider: $e');
    }
  }

  /// Calculate route to destination
  Future<bool> calculateRoute(LatLng destination, {List<LatLng> waypoints = const []}) async {
    if (_currentLocation == null) {
      final location = await _locationService.getCurrentLatLng();
      if (location == null) return false;
      _currentLocation = location;
    }

    _isCalculatingRoute = true;
    _destination = destination;
    notifyListeners();

    try {
      final route = await _placesService.getDirections(
        _currentLocation!,
        destination,
        mode: _selectedTravelMode,
        waypoints: waypoints,
      );

      if (route != null) {
        _currentRoute = route;
        _currentSteps = route.steps;
        _currentStepIndex = 0;
        _remainingDistance = route.distance;
        _remainingTime = route.duration;
        
        await _updateRouteDisplay();
        await _updateNextInstruction();
        
        _isCalculatingRoute = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error calculating route: $e');
    }

    _isCalculatingRoute = false;
    notifyListeners();
    return false;
  }

  /// Start navigation
  void startNavigation() {
    if (_currentRoute == null) return;
    
    _isNavigating = true;
    _startLocationTracking();
    notifyListeners();
  }

  /// Stop navigation
  void stopNavigation() {
    _isNavigating = false;
    _currentRoute = null;
    _destination = null;
    _currentSteps = [];
    _currentStepIndex = 0;
    _nextInstruction = '';
    _remainingDistance = '';
    _remainingTime = '';
    _routePolylines.clear();
    _navigationMarkers.clear();
    notifyListeners();
  }

  /// Change travel mode
  Future<void> changeTravelMode(TravelMode mode) async {
    _selectedTravelMode = mode;
    
    // Recalculate route if destination is set
    if (_destination != null) {
      await calculateRoute(_destination!);
    }
    
    notifyListeners();
  }

  /// Add waypoint to current route
  Future<void> addWaypoint(LatLng waypoint) async {
    if (_destination == null) return;
    
    final currentWaypoints = _currentRoute?.waypoints ?? [];
    final newWaypoints = [...currentWaypoints, waypoint];
    
    await calculateRoute(_destination!, waypoints: newWaypoints);
  }

  /// Update current location during navigation
  Future<void> updateCurrentLocation(LatLng newLocation) async {
    _currentLocation = newLocation;
    
    if (_isNavigating && _currentRoute != null) {
      await _checkNavigationProgress();
      await _updateCurrentLocationMarker();
    }
    
    notifyListeners();
  }

  /// Get alternative routes
  Future<List<MapRoute>> getAlternativeRoutes(LatLng destination) async {
    if (_currentLocation == null) return [];
    
    try {
      // In a real implementation, you would request multiple routes
      // For now, we'll return the current route with different travel modes
      final routes = <MapRoute>[];
      
      for (final mode in TravelMode.values) {
        if (mode != _selectedTravelMode) {
          final route = await _placesService.getDirections(
            _currentLocation!,
            destination,
            mode: mode,
          );
          if (route != null) {
            routes.add(route);
          }
        }
      }
      
      return routes;
    } catch (e) {
      print('Error getting alternative routes: $e');
      return [];
    }
  }

  /// Get travel mode icon
  IconData getTravelModeIcon(TravelMode mode) {
    switch (mode) {
      case TravelMode.driving:
        return Icons.directions_car;
      case TravelMode.walking:
        return Icons.directions_walk;
      case TravelMode.bicycling:
        return Icons.directions_bike;
      case TravelMode.transit:
        return Icons.directions_transit;
    }
  }

  /// Get travel mode label
  String getTravelModeLabel(TravelMode mode) {
    switch (mode) {
      case TravelMode.driving:
        return 'Driving';
      case TravelMode.walking:
        return 'Walking';
      case TravelMode.bicycling:
        return 'Bicycling';
      case TravelMode.transit:
        return 'Transit';
    }
  }

  /// Start location tracking during navigation
  void _startLocationTracking() {
    _locationService.watchPosition().listen((position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      updateCurrentLocation(newLocation);
    });
  }

  /// Check navigation progress and update instructions
  Future<void> _checkNavigationProgress() async {
    if (_currentSteps.isEmpty || _currentLocation == null) return;
    
    final currentStep = _currentSteps[_currentStepIndex];
    final distanceToStepEnd = _locationService.calculateDistance(
      _currentLocation!,
      currentStep.endLocation,
    );
    
    // If we're close to the end of current step, move to next step
    if (distanceToStepEnd < 50 && _currentStepIndex < _currentSteps.length - 1) {
      _currentStepIndex++;
      await _updateNextInstruction();
    }
    
    // Update remaining distance and time
    await _updateRemainingInfo();
  }

  /// Update next instruction
  Future<void> _updateNextInstruction() async {
    if (_currentStepIndex < _currentSteps.length) {
      final step = _currentSteps[_currentStepIndex];
      _nextInstruction = _cleanHtmlInstructions(step.instruction);
    } else {
      _nextInstruction = 'You have arrived at your destination';
    }
    notifyListeners();
  }

  /// Update remaining distance and time
  Future<void> _updateRemainingInfo() async {
    if (_currentRoute == null || _currentLocation == null) return;
    
    // Calculate remaining distance from current location to destination
    final remainingDistanceMeters = _locationService.calculateDistance(
      _currentLocation!,
      _currentRoute!.endLocation,
    );
    
    _remainingDistance = _locationService.formatDistance(remainingDistanceMeters);
    
    // For time, we'll use a simple estimation based on travel mode
    final estimatedSpeed = _getEstimatedSpeed(_selectedTravelMode);
    final remainingTimeMinutes = (remainingDistanceMeters / 1000) / estimatedSpeed * 60;
    _remainingTime = _locationService.formatDuration(
      Duration(minutes: remainingTimeMinutes.round()),
    );
    
    notifyListeners();
  }

  /// Update route display on map
  Future<void> _updateRouteDisplay() async {
    if (_currentRoute == null) return;
    
    // Create polyline for route
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: _currentRoute!.polylinePoints,
      color: AppTheme.routeColor,
      width: AppConstants.routeLineWidth.toInt(),
      patterns: [],
    );
    
    _routePolylines = {polyline};
    
    // Add destination marker
    await _addDestinationMarker();
    
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
    
    _navigationMarkers.removeWhere((m) => m.markerId.value == 'current_location');
    _navigationMarkers.add(marker);
    notifyListeners();
  }

  /// Update current location marker
  Future<void> _updateCurrentLocationMarker() async {
    await _addCurrentLocationMarker();
  }

  /// Add destination marker
  Future<void> _addDestinationMarker() async {
    if (_destination == null) return;
    
    final marker = Marker(
      markerId: const MarkerId('destination'),
      position: _destination!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: 'Destination'),
    );
    
    _navigationMarkers.removeWhere((m) => m.markerId.value == 'destination');
    _navigationMarkers.add(marker);
    notifyListeners();
  }

  /// Clean HTML instructions
  String _cleanHtmlInstructions(String htmlInstructions) {
    return htmlInstructions
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  /// Get estimated speed for travel mode (km/h)
  double _getEstimatedSpeed(TravelMode mode) {
    switch (mode) {
      case TravelMode.driving:
        return 50.0;
      case TravelMode.walking:
        return 5.0;
      case TravelMode.bicycling:
        return 15.0;
      case TravelMode.transit:
        return 30.0;
    }
  }
}