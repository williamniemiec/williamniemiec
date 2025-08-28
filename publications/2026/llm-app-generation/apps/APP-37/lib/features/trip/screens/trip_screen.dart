import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/models/trip.dart';
import '../widgets/trip_status_card.dart';
import '../widgets/driver_info_card.dart';
import '../widgets/trip_actions_panel.dart';
import '../../profile/screens/rating_screen.dart';

class TripScreen extends ConsumerStatefulWidget {
  final Trip trip;

  const TripScreen({
    super.key,
    required this.trip,
  });

  @override
  ConsumerState<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends ConsumerState<TripScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeTrip();
    });
  }

  void _initializeTrip() {
    ref.read(currentTripProvider.notifier).setTrip(widget.trip);
    _updateMapMarkers();
  }

  @override
  Widget build(BuildContext context) {
    final currentTrip = ref.watch(currentTripProvider) ?? widget.trip;

    return Scaffold(
      body: Stack(
        children: [
          // Map
          _buildMap(currentTrip),
          
          // Trip Status Card
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingM),
              child: TripStatusCard(trip: currentTrip),
            ),
          ),
          
          // Bottom Panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomPanel(currentTrip),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(Trip trip) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: LatLng(
          trip.pickupLocation.latitude,
          trip.pickupLocation.longitude,
        ),
        zoom: AppConstants.defaultZoom,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      trafficEnabled: true,
      buildingsEnabled: true,
      indoorViewEnabled: false,
      mapType: MapType.normal,
    );
  }

  Widget _buildBottomPanel(Trip trip) {
    if (trip.isCompleted) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusL),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
                const SizedBox(height: AppConstants.paddingM),
                const Text(
                  'Trip completed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingS),
                Text(
                  'Total: \$${trip.actualFare?.toStringAsFixed(2) ?? trip.estimatedFare?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingL),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _navigateToRating(trip),
                    child: const Text('Rate your trip'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trip.driver != null)
          DriverInfoCard(
            driver: trip.driver!,
            trip: trip,
          ),
        TripActionsPanel(trip: trip),
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMapMarkers();
    _animateToShowRoute();
  }

  void _updateMapMarkers() {
    final trip = ref.read(currentTripProvider) ?? widget.trip;
    
    _markers.clear();
    
    // Pickup marker
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(
          trip.pickupLocation.latitude,
          trip.pickupLocation.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: trip.pickupLocation.address ?? 'Pickup location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    
    // Destination marker
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          trip.destinationLocation.latitude,
          trip.destinationLocation.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Destination',
          snippet: trip.destinationLocation.address ?? 'Destination',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    
    // Driver marker (if available and trip is active)
    if (trip.driver?.currentLocation != null && trip.isActive) {
      _markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: LatLng(
            trip.driver!.currentLocation!.latitude,
            trip.driver!.currentLocation!.longitude,
          ),
          infoWindow: InfoWindow(
            title: trip.driver!.fullName,
            snippet: trip.driver!.vehicle.displayName,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    
    setState(() {});
  }

  void _animateToShowRoute() async {
    final trip = ref.read(currentTripProvider) ?? widget.trip;
    
    if (_mapController != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          [trip.pickupLocation.latitude, trip.destinationLocation.latitude]
              .reduce((a, b) => a < b ? a : b),
          [trip.pickupLocation.longitude, trip.destinationLocation.longitude]
              .reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          [trip.pickupLocation.latitude, trip.destinationLocation.latitude]
              .reduce((a, b) => a > b ? a : b),
          [trip.pickupLocation.longitude, trip.destinationLocation.longitude]
              .reduce((a, b) => a > b ? a : b),
        ),
      );
      
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  void _navigateToRating(Trip trip) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RatingScreen(trip: trip),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}