import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../providers/navigation_provider.dart';

class NavigationScreen extends ConsumerStatefulWidget {
  final WazeRoute route;
  final Place destination;

  const NavigationScreen({
    super.key,
    required this.route,
    required this.destination,
  });

  @override
  ConsumerState<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends ConsumerState<NavigationScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(navigationProvider.notifier).startNavigation(widget.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = ref.watch(navigationProvider);
    
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.route.legs.first.startLocation.latitude,
                widget.route.legs.first.startLocation.longitude,
              ),
              zoom: AppConstants.navigationZoom,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            trafficEnabled: true,
            polylines: _buildRoutePolylines(),
            markers: _buildNavigationMarkers(),
            onCameraMove: (CameraPosition position) {
              // Handle camera movement
            },
          ),
          
          // Top instruction banner
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _buildInstructionBanner(context, navigationState),
          ),
          
          // Bottom ETA bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildETABar(context, navigationState),
          ),
          
          // Exit navigation button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: _buildExitButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBanner(BuildContext context, NavigationState navigationState) {
    final currentStep = navigationState.currentStep;
    if (currentStep == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Turn icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(AppColors.wazeBlue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTurnIcon(currentStep.turnType),
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Instruction text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${navigationState.distanceToNextStep.round()} m',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  currentStep.instruction,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (currentStep.roadName != null)
                  Text(
                    'on ${currentStep.roadName}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildETABar(BuildContext context, NavigationState navigationState) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // ETA info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.route.estimatedArrival.toString().substring(11, 16),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: WazeColors.getTrafficColor(widget.route.trafficLevel),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.route.formattedDistance} • ${widget.route.formattedDurationInTraffic}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            
            // Route options button
            IconButton(
              onPressed: () {
                _showRouteOptions(context);
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExitButton(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            _showExitConfirmation(context);
          },
          child: const Icon(Icons.close),
        ),
      ),
    );
  }

  Set<Polyline> _buildRoutePolylines() {
    return {
      Polyline(
        polylineId: const PolylineId('route'),
        points: widget.route.overviewPolyline
            .map((location) => LatLng(location.latitude, location.longitude))
            .toList(),
        color: const Color(AppColors.wazeBlue),
        width: 6,
        patterns: [],
      ),
    };
  }

  Set<Marker> _buildNavigationMarkers() {
    return {
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(
          widget.destination.location.latitude,
          widget.destination.location.longitude,
        ),
        infoWindow: InfoWindow(
          title: widget.destination.name,
          snippet: widget.destination.address,
        ),
      ),
    };
  }

  IconData _getTurnIcon(TurnType turnType) {
    switch (turnType) {
      case TurnType.left:
        return Icons.turn_left;
      case TurnType.right:
        return Icons.turn_right;
      case TurnType.straight:
        return Icons.straight;
      case TurnType.uTurn:
        return Icons.u_turn_left;
      case TurnType.exitLeft:
        return Icons.exit_to_app;
      case TurnType.exitRight:
        return Icons.exit_to_app;
      default:
        return Icons.navigation;
    }
  }

  void _showRouteOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.volume_up),
              title: const Text('Voice guidance'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // TODO: Toggle voice guidance
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.route),
              title: const Text('Alternative routes'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show alternative routes
              },
            ),
            ListTile(
              leading: const Icon(Icons.stop),
              title: const Text('Stop navigation'),
              onTap: () {
                Navigator.pop(context);
                _exitNavigation();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Navigation'),
        content: const Text('Are you sure you want to stop navigation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exitNavigation();
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }

  void _exitNavigation() {
    ref.read(navigationProvider.notifier).stopNavigation();
    Navigator.pop(context);
  }
}