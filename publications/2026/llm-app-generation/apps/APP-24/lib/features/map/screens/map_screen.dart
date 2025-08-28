import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../../../shared/services/location_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/report_button_widget.dart';
import '../widgets/speedometer_widget.dart';
import '../widgets/saved_places_widget.dart';
import '../providers/map_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();
  
  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _locationService.requestPermissions();
    await _locationService.getCurrentLocation();
    await _locationService.startLocationUpdates();
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              ref.read(mapProvider.notifier).setMapController(controller);
            },
            initialCameraPosition: CameraPosition(
              target: mapState.currentLocation != null
                  ? LatLng(
                      mapState.currentLocation!.latitude,
                      mapState.currentLocation!.longitude,
                    )
                  : const LatLng(37.7749, -122.4194), // Default to San Francisco
              zoom: AppConstants.defaultZoom,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
            trafficEnabled: true,
            buildingsEnabled: true,
            markers: mapState.markers,
            polylines: mapState.polylines,
            onCameraMove: (CameraPosition position) {
              ref.read(mapProvider.notifier).updateCameraPosition(position);
            },
            onTap: (LatLng position) {
              ref.read(mapProvider.notifier).onMapTap(position);
            },
            style: mapState.mapStyle,
          ),
          
          // Top UI Elements
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Search Bar
                const SearchBarWidget(),
                
                const SizedBox(height: 12),
                
                // Saved Places
                const SavedPlacesWidget(),
              ],
            ),
          ),
          
          // Speedometer (Top Right)
          Positioned(
            top: MediaQuery.of(context).padding.top + 100,
            right: 16,
            child: const SpeedometerWidget(),
          ),
          
          // Report Button (Bottom Right)
          const Positioned(
            bottom: 100,
            right: 16,
            child: ReportButtonWidget(),
          ),
          
          // Bottom Sheet for Route Info (if navigating)
          if (mapState.isNavigating)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildNavigationBottomSheet(context, mapState),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationBottomSheet(BuildContext context, MapState mapState) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Route Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mapState.currentRoute?.formattedDurationInTraffic ?? '0 min',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: WazeColors.getTrafficColor(
                        mapState.currentRoute?.trafficLevel ?? 'Light',
                      ),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    mapState.currentRoute?.formattedDistance ?? '0 km',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'ETA: ${mapState.currentRoute?.estimatedArrival.toString().substring(11, 16) ?? '--:--'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            
            // Stop Navigation Button
            ElevatedButton(
              onPressed: () {
                ref.read(mapProvider.notifier).stopNavigation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Stop'),
            ),
          ],
        ),
      ),
    );
  }
}