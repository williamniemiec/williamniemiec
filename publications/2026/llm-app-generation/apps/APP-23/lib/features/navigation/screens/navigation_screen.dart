import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/navigation_provider.dart';
import '../../../shared/models/models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Map
              _buildNavigationMap(navigationProvider),
              
              // Top instruction banner
              if (navigationProvider.isNavigating)
                _buildInstructionBanner(navigationProvider),
              
              // Travel mode selector
              if (!navigationProvider.isNavigating)
                _buildTravelModeSelector(navigationProvider),
              
              // Route info panel
              if (navigationProvider.currentRoute != null && !navigationProvider.isNavigating)
                _buildRouteInfoPanel(navigationProvider),
              
              // Navigation controls
              if (navigationProvider.isNavigating)
                _buildNavigationControls(navigationProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationMap(NavigationProvider navigationProvider) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: navigationProvider.currentLocation ?? 
                const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
        zoom: AppConstants.defaultZoom,
      ),
      markers: navigationProvider.navigationMarkers,
      polylines: navigationProvider.routePolylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onTap: (position) {
        if (!navigationProvider.isNavigating) {
          navigationProvider.calculateRoute(position);
        }
      },
    );
  }

  Widget _buildInstructionBanner(NavigationProvider navigationProvider) {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(AppConstants.spacingM),
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              navigationProvider.nextInstruction,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppConstants.spacingS),
            Row(
              children: [
                Icon(
                  navigationProvider.getTravelModeIcon(navigationProvider.selectedTravelMode),
                  size: 16,
                  color: AppTheme.secondaryTextColor,
                ),
                const SizedBox(width: AppConstants.spacingXS),
                Text(
                  '${navigationProvider.remainingDistance} • ${navigationProvider.remainingTime}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTravelModeSelector(NavigationProvider navigationProvider) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: TravelMode.values.map((mode) {
            final isSelected = navigationProvider.selectedTravelMode == mode;
            return Expanded(
              child: GestureDetector(
                onTap: () => navigationProvider.changeTravelMode(mode),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        navigationProvider.getTravelModeIcon(mode),
                        color: isSelected ? Colors.white : AppTheme.secondaryTextColor,
                        size: 20,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        navigationProvider.getTravelModeLabel(mode),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected ? Colors.white : AppTheme.secondaryTextColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRouteInfoPanel(NavigationProvider navigationProvider) {
    final route = navigationProvider.currentRoute!;
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: const BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppConstants.bottomSheetBorderRadius),
            topRight: Radius.circular(AppConstants.bottomSheetBorderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Route summary
            Row(
              children: [
                Icon(
                  navigationProvider.getTravelModeIcon(navigationProvider.selectedTravelMode),
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(width: AppConstants.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${route.distance} • ${route.duration}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'via ${route.id}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.spacingM),
            
            // Start navigation button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: navigationProvider.startNavigation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationControls(NavigationProvider navigationProvider) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        children: [
          FloatingActionButton(
            heroTag: "stop_navigation",
            onPressed: navigationProvider.stopNavigation,
            backgroundColor: AppTheme.errorColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.stop),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${navigationProvider.remainingDistance} • ${navigationProvider.remainingTime}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}