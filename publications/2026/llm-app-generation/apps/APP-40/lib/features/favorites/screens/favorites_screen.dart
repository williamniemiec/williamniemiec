import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/device.dart';
import '../widgets/device_spaces_bar.dart';
import '../widgets/favorite_device_card.dart';
import '../widgets/media_player_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadMockData();
      }
    });
  }

  void _loadMockData() {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Mock devices data
    final mockDevices = [
      Device(
        id: '1',
        name: 'Living Room Light',
        type: DeviceType.light,
        roomId: 'living_room',
        status: DeviceStatus.online,
        properties: {'isOn': true, 'brightness': 80},
        lastUpdated: DateTime.now(),
        isFavorite: true,
      ),
      Device(
        id: '2',
        name: 'Thermostat',
        type: DeviceType.thermostat,
        roomId: 'living_room',
        status: DeviceStatus.online,
        properties: {'temperature': 22.5, 'targetTemp': 23.0},
        lastUpdated: DateTime.now(),
        isFavorite: true,
      ),
      Device(
        id: '3',
        name: 'Front Door Camera',
        type: DeviceType.camera,
        roomId: 'outdoor',
        status: DeviceStatus.online,
        properties: {'isRecording': true, 'motionDetected': false},
        lastUpdated: DateTime.now(),
        isFavorite: true,
      ),
      Device(
        id: '4',
        name: 'Kitchen Speaker',
        type: DeviceType.speaker,
        roomId: 'kitchen',
        status: DeviceStatus.online,
        properties: {'isPlaying': false, 'volume': 60},
        lastUpdated: DateTime.now(),
        isFavorite: true,
      ),
    ];

    appProvider.setDevices(mockDevices);
    appProvider.setFavoriteDevices(['1', '2', '3', '4']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  title: Text(
                    appProvider.homeName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _showAddDeviceDialog(context);
                      },
                    ),
                  ],
                ),

                // Device Spaces Bar
                const SliverToBoxAdapter(
                  child: DeviceSpacesBar(),
                ),

                // Favorites Grid
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: AppConstants.defaultPadding,
                      mainAxisSpacing: AppConstants.defaultPadding,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final favoriteDevices = appProvider.favoriteDevices;
                        if (index < favoriteDevices.length) {
                          return FavoriteDeviceCard(
                            device: favoriteDevices[index],
                            onTap: () => _onDeviceTap(favoriteDevices[index]),
                            onToggle: () => _onDeviceToggle(favoriteDevices[index]),
                          );
                        }
                        return null;
                      },
                      childCount: appProvider.favoriteDevices.length,
                    ),
                  ),
                ),

                // Media Player Card (if media is playing)
                SliverToBoxAdapter(
                  child: _buildMediaPlayerSection(appProvider),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: _buildQuickActionsSection(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMediaPlayerSection(AppProvider appProvider) {
    // Check if any speaker is playing
    final playingSpeakers = appProvider.devices
        .where((device) => 
            device.type == DeviceType.speaker && 
            device.properties['isPlaying'] == true)
        .toList();

    if (playingSpeakers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: MediaPlayerCard(
        device: playingSpeakers.first,
        onPlay: () {},
        onPause: () {},
        onNext: () {},
        onPrevious: () {},
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  'Good Night',
                  Icons.bedtime,
                  () => _triggerRoutine('good_night'),
                ),
              ),
              const SizedBox(width: AppConstants.defaultPadding),
              Expanded(
                child: _buildQuickActionCard(
                  context,
                  'Good Morning',
                  Icons.wb_sunny,
                  () => _triggerRoutine('good_morning'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDeviceTap(Device device) {
    // Navigate to device detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped on ${device.name}')),
    );
  }

  void _onDeviceToggle(Device device) {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    
    // Toggle device state
    Map<String, dynamic> newProperties = Map.from(device.properties);
    
    switch (device.type) {
      case DeviceType.light:
        newProperties['isOn'] = !(device.properties['isOn'] ?? false);
        break;
      case DeviceType.speaker:
        newProperties['isPlaying'] = !(device.properties['isPlaying'] ?? false);
        break;
      default:
        break;
    }

    final updatedDevice = device.copyWith(
      properties: newProperties,
      lastUpdated: DateTime.now(),
    );

    appProvider.updateDevice(updatedDevice);
  }

  void _triggerRoutine(String routineId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Triggered routine: $routineId')),
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Device'),
        content: const Text('Device setup would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}