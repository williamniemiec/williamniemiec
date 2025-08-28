import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/models/room.dart';
import '../../../shared/models/device.dart';
import 'device_list_item.dart';

class RoomSection extends StatefulWidget {
  final Room room;
  final List<Device> devices;
  final Function(Device) onDeviceTap;
  final Function(Device) onDeviceToggle;
  final VoidCallback onRoomTap;

  const RoomSection({
    super.key,
    required this.room,
    required this.devices,
    required this.onDeviceTap,
    required this.onDeviceToggle,
    required this.onRoomTap,
  });

  @override
  State<RoomSection> createState() => _RoomSectionState();
}

class _RoomSectionState extends State<RoomSection> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Column(
        children: [
          // Room Header
          InkWell(
            onTap: widget.onRoomTap,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Container(
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getRoomIcon(widget.room.iconName),
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.room.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${widget.devices.length} devices',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Device status indicators
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDeviceStatusIndicator(context),
                      const SizedBox(width: AppConstants.smallPadding),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: AnimatedRotation(
                          turns: _isExpanded ? 0.5 : 0,
                          duration: AppConstants.shortAnimation,
                          child: Icon(
                            Icons.expand_more,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Device List
          AnimatedContainer(
            duration: AppConstants.mediumAnimation,
            height: _isExpanded ? null : 0,
            child: AnimatedOpacity(
              duration: AppConstants.mediumAnimation,
              opacity: _isExpanded ? 1.0 : 0.0,
              child: _isExpanded
                  ? Container(
                      margin: const EdgeInsets.only(top: AppConstants.smallPadding),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      child: Column(
                        children: widget.devices
                            .map((device) => DeviceListItem(
                                  device: device,
                                  onTap: () => widget.onDeviceTap(device),
                                  onToggle: () => widget.onDeviceToggle(device),
                                ))
                            .toList(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceStatusIndicator(BuildContext context) {
    final onlineDevices = widget.devices.where((d) => d.status == DeviceStatus.online).length;
    final totalDevices = widget.devices.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: onlineDevices == totalDevices
                ? Colors.green
                : onlineDevices > 0
                    ? Colors.orange
                    : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$onlineDevices/$totalDevices',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  IconData _getRoomIcon(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'sofa':
        return MdiIcons.sofa;
      case 'chef_hat':
        return MdiIcons.chefHat;
      case 'bed':
        return MdiIcons.bed;
      case 'tree':
        return MdiIcons.tree;
      case 'bathtub':
        return MdiIcons.bathtub;
      case 'desk':
        return MdiIcons.desk;
      case 'car':
        return MdiIcons.car;
      default:
        return MdiIcons.home;
    }
  }
}