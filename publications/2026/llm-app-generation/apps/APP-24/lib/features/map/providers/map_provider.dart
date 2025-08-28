import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/models/models.dart';

class MapState {
  final Location? currentLocation;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final CameraPosition? cameraPosition;
  final bool isNavigating;
  final WazeRoute? currentRoute;
  final String? mapStyle;

  const MapState({
    this.currentLocation,
    this.markers = const {},
    this.polylines = const {},
    this.cameraPosition,
    this.isNavigating = false,
    this.currentRoute,
    this.mapStyle,
  });

  MapState copyWith({
    Location? currentLocation,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
    CameraPosition? cameraPosition,
    bool? isNavigating,
    WazeRoute? currentRoute,
    String? mapStyle,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      markers: markers ?? this.markers,
      polylines: polylines ?? this.polylines,
      cameraPosition: cameraPosition ?? this.cameraPosition,
      isNavigating: isNavigating ?? this.isNavigating,
      currentRoute: currentRoute ?? this.currentRoute,
      mapStyle: mapStyle ?? this.mapStyle,
    );
  }
}

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier() : super(const MapState());

  GoogleMapController? _mapController;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void updateCurrentLocation(Location location) {
    state = state.copyWith(currentLocation: location);
  }

  void updateCameraPosition(CameraPosition position) {
    state = state.copyWith(cameraPosition: position);
  }

  void onMapTap(LatLng position) {
    // Handle map tap
    debugPrint('Map tapped at: ${position.latitude}, ${position.longitude}');
  }

  void addMarker(Marker marker) {
    final newMarkers = Set<Marker>.from(state.markers);
    newMarkers.add(marker);
    state = state.copyWith(markers: newMarkers);
  }

  void removeMarker(String markerId) {
    final newMarkers = state.markers.where((marker) => marker.markerId.value != markerId).toSet();
    state = state.copyWith(markers: newMarkers);
  }

  void addPolyline(Polyline polyline) {
    final newPolylines = Set<Polyline>.from(state.polylines);
    newPolylines.add(polyline);
    state = state.copyWith(polylines: newPolylines);
  }

  void clearPolylines() {
    state = state.copyWith(polylines: {});
  }

  void startNavigation(WazeRoute route) {
    state = state.copyWith(
      isNavigating: true,
      currentRoute: route,
    );
  }

  void stopNavigation() {
    state = state.copyWith(
      isNavigating: false,
      currentRoute: null,
    );
    clearPolylines();
  }

  void setMapStyle(String style) {
    state = state.copyWith(mapStyle: style);
    _mapController?.setMapStyle(style);
  }

  Future<void> animateToLocation(Location location, {double zoom = 15.0}) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: zoom,
          ),
        ),
      );
    }
  }
}

final mapProvider = StateNotifierProvider<MapNotifier, MapState>((ref) {
  return MapNotifier();
});