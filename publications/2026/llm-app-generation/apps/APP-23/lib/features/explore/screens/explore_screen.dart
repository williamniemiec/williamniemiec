import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/explore_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_pills_widget.dart';
import '../widgets/place_info_sheet.dart';
import '../../navigation/screens/navigation_screen.dart';
import '../../saved/screens/saved_screen.dart';
import '../../contribute/screens/contribute_screen.dart';
import '../../updates/screens/updates_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExploreProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          _buildExploreTab(),
          const NavigationScreen(),
          const SavedScreen(),
          const ContributeScreen(),
          const UpdatesScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildExploreTab() {
    return Consumer<ExploreProvider>(
      builder: (context, exploreProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Google Map
              _buildGoogleMap(exploreProvider),
              
              // Search Bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                child: SearchBarWidget(
                  onSearch: exploreProvider.searchPlaces,
                  onSuggestionTap: (suggestion) {
                    exploreProvider.searchPlaces(suggestion);
                  },
                ),
              ),
              
              // Category Pills
              Positioned(
                top: MediaQuery.of(context).padding.top + 80,
                left: 16,
                right: 16,
                child: CategoryPillsWidget(
                  onCategoryTap: exploreProvider.searchNearbyPlaces,
                ),
              ),
              
              // Current Location Button
              Positioned(
                bottom: 120,
                right: 16,
                child: FloatingActionButton(
                  heroTag: "current_location",
                  onPressed: exploreProvider.moveCameraToCurrentLocation,
                  backgroundColor: AppTheme.surfaceColor,
                  foregroundColor: AppTheme.primaryBlue,
                  child: const Icon(Icons.my_location),
                ),
              ),
              
              // Go Button (Navigation FAB)
              Positioned(
                bottom: 180,
                right: 16,
                child: FloatingActionButton.extended(
                  heroTag: "navigation",
                  onPressed: () {
                    _pageController.animateToPage(
                      1,
                      duration: AppConstants.mediumAnimation,
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.directions),
                  label: const Text('Go'),
                ),
              ),
              
              // Map Type Button
              Positioned(
                bottom: 240,
                right: 16,
                child: FloatingActionButton(
                  heroTag: "map_type",
                  mini: true,
                  onPressed: () => _showMapTypeDialog(exploreProvider),
                  backgroundColor: AppTheme.surfaceColor,
                  foregroundColor: AppTheme.primaryBlue,
                  child: const Icon(Icons.layers),
                ),
              ),
              
              // Loading Indicator
              if (exploreProvider.isLoading)
                const Positioned(
                  top: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              
              // Place Info Sheet
              if (exploreProvider.selectedPlace != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: PlaceInfoSheet(
                    place: exploreProvider.selectedPlace!,
                    onClose: exploreProvider.clearSelectedPlace,
                    onDirections: (place) {
                      // Navigate to navigation screen with selected place
                      _pageController.animateToPage(
                        1,
                        duration: AppConstants.mediumAnimation,
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGoogleMap(ExploreProvider exploreProvider) {
    return GoogleMap(
      onMapCreated: exploreProvider.setMapController,
      initialCameraPosition: CameraPosition(
        target: exploreProvider.currentLocation ?? 
                const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
        zoom: AppConstants.defaultZoom,
      ),
      markers: exploreProvider.markers,
      polylines: exploreProvider.polylines,
      mapType: exploreProvider.mapType,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onCameraMove: (position) {
        exploreProvider.updateZoom(position.zoom);
      },
      onTap: (position) {
        // Clear selected place when tapping on map
        if (exploreProvider.selectedPlace != null) {
          exploreProvider.clearSelectedPlace();
        }
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _pageController.animateToPage(
          index,
          duration: AppConstants.mediumAnimation,
          curve: Curves.easeInOut,
        );
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryBlue,
      unselectedItemColor: AppTheme.secondaryTextColor,
      backgroundColor: AppTheme.surfaceColor,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          label: 'Go',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Contribute',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Updates',
        ),
      ],
    );
  }

  void _showMapTypeDialog(ExploreProvider exploreProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMapTypeOption(
              'Normal',
              MapType.normal,
              exploreProvider.mapType == MapType.normal,
              exploreProvider,
            ),
            _buildMapTypeOption(
              'Satellite',
              MapType.satellite,
              exploreProvider.mapType == MapType.satellite,
              exploreProvider,
            ),
            _buildMapTypeOption(
              'Terrain',
              MapType.terrain,
              exploreProvider.mapType == MapType.terrain,
              exploreProvider,
            ),
            _buildMapTypeOption(
              'Hybrid',
              MapType.hybrid,
              exploreProvider.mapType == MapType.hybrid,
              exploreProvider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTypeOption(
    String title,
    MapType mapType,
    bool isSelected,
    ExploreProvider exploreProvider,
  ) {
    return ListTile(
      title: Text(title),
      leading: Radio<MapType>(
        value: mapType,
        groupValue: exploreProvider.mapType,
        onChanged: (value) {
          if (value != null) {
            exploreProvider.changeMapType(value);
            Navigator.of(context).pop();
          }
        },
      ),
      onTap: () {
        exploreProvider.changeMapType(mapType);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}