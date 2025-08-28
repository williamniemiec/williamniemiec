import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/device.dart';
import '../../../shared/models/room.dart';
import '../widgets/room_section.dart';
import '../widgets/device_list_item.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
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
    
    // Mock rooms data
    final mockRooms = [
      Room(
        id: 'living_room',
        name: 'Living Room',
        iconName: 'sofa',
        deviceIds: ['1', '2'],
        createdAt: DateTime.now(),
      ),
      Room(
        id: 'kitchen',
        name: 'Kitchen',
        iconName: 'chef_hat',
        deviceIds: ['4'],
        createdAt: DateTime.now(),
      ),
      Room(
        id: 'bedroom',
        name: 'Bedroom',
        iconName: 'bed',
        deviceIds: ['5', '6'],
        createdAt: DateTime.now(),
      ),
      Room(
        id: 'outdoor',
        name: 'Outdoor',
        iconName: 'tree',
        deviceIds: ['3'],
        createdAt: DateTime.now(),
      ),
    ];

    // Additional mock devices
    final additionalDevices = [
      Device(
        id: '5',
        name: 'Bedroom Light',
        type: DeviceType.light,
        roomId: 'bedroom',
        status: DeviceStatus.online,
        properties: {'isOn': false, 'brightness': 0},
        lastUpdated: DateTime.now(),
      ),
      Device(
        id: '6',
        name: 'Smart Lock',
        type: DeviceType.lock,
        roomId: 'bedroom',
        status: DeviceStatus.online,
        properties: {'isLocked': true},
        lastUpdated: DateTime.now(),
      ),
    ];

    // Add additional devices to existing ones
    final existingDevices = appProvider.devices;
    final allDevices = [...existingDevices, ...additionalDevices];
    
    appProvider.setRooms(mockRooms);
    appProvider.setDevices(allDevices);
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
                    'Devices',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _showSearchDialog(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddDeviceDialog(context),
                    ),
                  ],
                ),

                // Device Summary
                SliverToBoxAdapter(
                  child: _buildDeviceSummary(appProvider),
                ),

                // Rooms and Devices
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final rooms = appProvider.rooms;
                      if (index < rooms.length) {
                        final room = rooms[index];
                        final roomDevices = appProvider.getDevicesByRoom(room.id);
                        
                        return RoomSection(
                          room: room,
                          devices: roomDevices,
                          onDeviceTap: (device) => _onDeviceTap(device),
                          onDeviceToggle: (device) => _onDeviceToggle(device),
                          onRoomTap: () => _onRoomTap(room),
                        );
                      }
                      return null;
                    },
                    childCount: appProvider.rooms.length,
                  ),
                ),

                // Unassigned Devices
                SliverToBoxAdapter(
                  child: _buildUnassignedDevices(appProvider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeviceSummary(AppProvider appProvider) {
    final totalDevices = appProvider.devices.length;
    final onlineDevices = appProvider.onlineDevices.length;
    final offlineDevices = appProvider.offlineDevices.length;

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              context,
              'Total',
              totalDevices.toString(),
              Icons.devices,
              Theme.of(context).colorScheme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          Expanded(
            child: _buildSummaryItem(
              context,
              'Online',
              onlineDevices.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          Expanded(
            child: _buildSummaryItem(
              context,
              'Offline',
              offlineDevices.toString(),
              Icons.error_outline,
              Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildUnassignedDevices(AppProvider appProvider) {
    final unassignedDevices = appProvider.devices
        .where((device) => !appProvider.rooms.any((room) => room.deviceIds.contains(device.id)))
        .toList();

    if (unassignedDevices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Unassigned Devices',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ...unassignedDevices.map((device) => DeviceListItem(
            device: device,
            onTap: () => _onDeviceTap(device),
            onToggle: () => _onDeviceToggle(device),
          )),
        ],
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
      case DeviceType.lock:
        newProperties['isLocked'] = !(device.properties['isLocked'] ?? false);
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

  void _onRoomTap(Room room) {
    // Navigate to room detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped on ${room.name}')),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Devices'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter device name...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Search'),
          ),
        ],
      ),
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