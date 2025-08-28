import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/providers/weather_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/radar_controls.dart';
import '../widgets/radar_layer_selector.dart';
import '../widgets/radar_animation_controls.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> with TickerProviderStateMixin {
  GoogleMapController? _mapController;
  late AnimationController _animationController;
  late AnimationController _fadeController;
  
  String _selectedLayer = 'precipitation';
  bool _isAnimating = false;
  int _currentFrameIndex = 0;
  
  final Map<String, String> _layerOptions = {
    'precipitation': 'Precipitation',
    'satellite': 'Satellite',
    'temperature': 'Temperature',
    'wind': 'Wind Speed',
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRadarData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadRadarData() async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.loadRadarData();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _centerMapOnCurrentLocation();
  }

  void _centerMapOnCurrentLocation() {
    final weatherProvider = context.read<WeatherProvider>();
    final location = weatherProvider.currentLocation;
    
    if (location != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(location.latitude, location.longitude),
          8.0,
        ),
      );
    }
  }

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
    
    if (_isAnimating) {
      _startRadarAnimation();
    } else {
      _animationController.stop();
    }
  }

  void _startRadarAnimation() {
    final weatherProvider = context.read<WeatherProvider>();
    final frames = weatherProvider.radarFrames;
    
    if (frames.isEmpty) return;
    
    _animationController.repeat();
    _animationController.addListener(() {
      final frameIndex = (_animationController.value * frames.length).floor() % frames.length;
      if (frameIndex != _currentFrameIndex) {
        setState(() {
          _currentFrameIndex = frameIndex;
        });
      }
    });
  }

  void _onLayerChanged(String layer) {
    setState(() {
      _selectedLayer = layer;
    });
    // In a real implementation, this would load different radar data
    _loadRadarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Radar'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _centerMapOnCurrentLocation,
            tooltip: 'Center on current location',
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final location = weatherProvider.currentLocation;
          
          if (location == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading location...'),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Google Map
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(location.latitude, location.longitude),
                  zoom: 8.0,
                ),
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: {
                  Marker(
                    markerId: const MarkerId('current_location'),
                    position: LatLng(location.latitude, location.longitude),
                    infoWindow: InfoWindow(
                      title: location.name,
                      snippet: location.displayName,
                    ),
                  ),
                },
              ),
              
              // Radar overlay (simulated)
              if (_selectedLayer == 'precipitation')
                _buildRadarOverlay(),
              
              // Layer selector
              Positioned(
                top: 16,
                right: 16,
                child: RadarLayerSelector(
                  selectedLayer: _selectedLayer,
                  layerOptions: _layerOptions,
                  onLayerChanged: _onLayerChanged,
                ),
              ),
              
              // Animation controls
              Positioned(
                bottom: 100,
                left: 16,
                right: 16,
                child: RadarAnimationControls(
                  isAnimating: _isAnimating,
                  currentFrame: _currentFrameIndex,
                  totalFrames: weatherProvider.radarFrames.length,
                  onToggleAnimation: _toggleAnimation,
                  onFrameChanged: (frame) {
                    setState(() {
                      _currentFrameIndex = frame;
                    });
                  },
                ),
              ),
              
              // Radar controls
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: RadarControls(
                  selectedLayer: _selectedLayer,
                  onRefresh: _loadRadarData,
                  isLoading: weatherProvider.isRadarLoading,
                ),
              ),
              
              // Loading indicator
              if (weatherProvider.isRadarLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading radar data...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRadarOverlay() {
    // This is a simplified radar overlay
    // In a real implementation, this would show actual radar tiles
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.3, -0.2),
          radius: 0.8,
          colors: [
            AppTheme.lightRain.withOpacity(0.3),
            AppTheme.moderateRain.withOpacity(0.2),
            AppTheme.heavyRain.withOpacity(0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animationController.value * 2 * 3.14159,
            child: Container(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  colors: [
                    Colors.transparent,
                    AppTheme.lightRain.withOpacity(0.2),
                    AppTheme.moderateRain.withOpacity(0.3),
                    AppTheme.heavyRain.withOpacity(0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.2, 0.4, 0.6, 1.0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}