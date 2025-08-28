import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/models/location.dart';
import '../widgets/destination_search_bar.dart';
import '../widgets/services_panel.dart';
import '../widgets/saved_locations_list.dart';
import '../../booking/screens/booking_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  void _initializeLocation() async {
    final currentLocationNotifier = ref.read(currentLocationProvider.notifier);
    await currentLocationNotifier.refreshLocation();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = ref.watch(currentLocationProvider);
    final destination = ref.watch(destinationProvider);
    final currentTrip = ref.watch(currentTripProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Map
          _buildMap(currentLocation),
          
          // Top UI Elements
          SafeArea(
            child: Column(
              children: [
                // Destination Search Bar
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingM),
                  child: DestinationSearchBar(
                    onDestinationSelected: _onDestinationSelected,
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Panel
                if (currentTrip == null) ...[
                  if (destination == null)
                    const ServicesPanel()
                  else
                    _buildBookingButton(),
                ],
                
                // Saved Locations (only show when no destination is selected)
                if (destination == null && currentTrip == null)
                  const SavedLocationsList(),
              ],
            ),
          ),
          
          // Current Location Button
          Positioned(
            right: AppConstants.paddingM,
            bottom: destination == null ? 200 : 120,
            child: _buildCurrentLocationButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(Location? currentLocation) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: currentLocation != null
            ? LatLng(currentLocation.latitude, currentLocation.longitude)
            : const LatLng(37.7749, -122.4194), // Default to San Francisco
        zoom: AppConstants.defaultZoom,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      trafficEnabled: false,
      buildingsEnabled: true,
      indoorViewEnabled: false,
      mapType: MapType.normal,
      style: _getMapStyle(),
    );
  }

  Widget _buildCurrentLocationButton() {
    return FloatingActionButton(
      onPressed: _onCurrentLocationPressed,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 4,
      mini: true,
      child: const Icon(Icons.my_location),
    );
  }

  Widget _buildBookingButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(AppConstants.paddingM),
      child: ElevatedButton(
        onPressed: _onBookRidePressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
        ),
        child: const Text('Choose ride'),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMapMarkers();
  }

  void _onDestinationSelected(Location destination) {
    ref.read(destinationProvider.notifier).setDestination(destination);
    _updateMapMarkers();
    _animateToShowBothLocations();
  }

  void _onCurrentLocationPressed() async {
    final currentLocation = ref.read(currentLocationProvider);
    if (currentLocation != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentLocation.latitude, currentLocation.longitude),
          AppConstants.defaultZoom,
        ),
      );
    } else {
      // Refresh location if not available
      await ref.read(currentLocationProvider.notifier).refreshLocation();
    }
  }

  void _onBookRidePressed() {
    final currentLocation = ref.read(currentLocationProvider);
    final destination = ref.read(destinationProvider);
    
    if (currentLocation != null && destination != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookingScreen(
            pickup: currentLocation,
            destination: destination,
          ),
        ),
      );
    }
  }

  void _updateMapMarkers() {
    final currentLocation = ref.read(currentLocationProvider);
    final destination = ref.read(destinationProvider);
    
    _markers.clear();
    
    if (currentLocation != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: LatLng(currentLocation.latitude, currentLocation.longitude),
          infoWindow: InfoWindow(
            title: 'Pickup',
            snippet: currentLocation.address ?? 'Current location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }
    
    if (destination != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(destination.latitude, destination.longitude),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: destination.address ?? destination.name ?? 'Destination',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    
    setState(() {});
  }

  void _animateToShowBothLocations() async {
    final currentLocation = ref.read(currentLocationProvider);
    final destination = ref.read(destinationProvider);
    
    if (currentLocation != null && destination != null && _mapController != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          [currentLocation.latitude, destination.latitude].reduce((a, b) => a < b ? a : b),
          [currentLocation.longitude, destination.longitude].reduce((a, b) => a < b ? a : b),
        ),
        northeast: LatLng(
          [currentLocation.latitude, destination.latitude].reduce((a, b) => a > b ? a : b),
          [currentLocation.longitude, destination.longitude].reduce((a, b) => a > b ? a : b),
        ),
      );
      
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
  }

  String? _getMapStyle() {
    // You can customize the map style here
    return null;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}