import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/models/device.dart';

class DeviceListItem extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const DeviceListItem({
    super.key,
    required this.device,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 2,
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getDeviceColor(device.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getDeviceIcon(device.type),
            color: _getDeviceColor(device.type),
            size: 20,
          ),
        ),
        title: Text(
          device.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          _getDeviceStatusText(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusIndicator(context),
            const SizedBox(width: AppConstants.smallPadding),
            _buildDeviceControl(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    Color statusColor;
    switch (device.status) {
      case DeviceStatus.online:
        statusColor = Colors.green;
        break;
      case DeviceStatus.offline:
        statusColor = Colors.grey;
        break;
      case DeviceStatus.updating:
        statusColor = Colors.orange;
        break;
      case DeviceStatus.error:
        statusColor = Colors.red;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: statusColor,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDeviceControl(BuildContext context) {
    switch (device.type) {
      case DeviceType.light:
        return _buildLightControl(context);
      case DeviceType.lock:
        return _buildLockControl(context);
      case DeviceType.speaker:
        return _buildSpeakerControl(context);
      default:
        return _buildGenericControl(context);
    }
  }

  Widget _buildLightControl(BuildContext context) {
    final isOn = device.isOn;

    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: AppConstants.shortAnimation,
        width: 40,
        height: 24,
        decoration: BoxDecoration(
          color: isOn
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedAlign(
          duration: AppConstants.shortAnimation,
          alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLockControl(BuildContext context) {
    final isLocked = device.isLocked;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isLocked
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: !isLocked
              ? Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                )
              : null,
        ),
        child: Icon(
          isLocked ? Icons.lock : Icons.lock_open,
          color: isLocked
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildSpeakerControl(BuildContext context) {
    final isPlaying = device.properties['isPlaying'] as bool? ?? false;

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isPlaying
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: !isPlaying
              ? Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                )
              : null,
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: isPlaying
              ? Colors.white
              : Theme.of(context).colorScheme.onSurface,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildGenericControl(BuildContext context) {
    return Icon(
      Icons.more_vert,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
      size: 20,
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return MdiIcons.lightbulb;
      case DeviceType.thermostat:
        return MdiIcons.thermostat;
      case DeviceType.camera:
        return MdiIcons.camera;
      case DeviceType.speaker:
        return MdiIcons.speaker;
      case DeviceType.display:
        return MdiIcons.monitor;
      case DeviceType.smartPlug:
        return MdiIcons.power;
      case DeviceType.lock:
        return MdiIcons.lock;
      case DeviceType.sensor:
        return MdiIcons.motionSensor;
      case DeviceType.switch_:
        return MdiIcons.toggleSwitch;
      case DeviceType.fan:
        return MdiIcons.fan;
    }
  }

  Color _getDeviceColor(DeviceType type) {
    switch (type) {
      case DeviceType.light:
        return Colors.amber;
      case DeviceType.thermostat:
        return Colors.blue;
      case DeviceType.camera:
        return Colors.green;
      case DeviceType.speaker:
        return Colors.purple;
      case DeviceType.display:
        return Colors.indigo;
      case DeviceType.smartPlug:
        return Colors.orange;
      case DeviceType.lock:
        return Colors.red;
      case DeviceType.sensor:
        return Colors.teal;
      case DeviceType.switch_:
        return Colors.grey;
      case DeviceType.fan:
        return Colors.cyan;
    }
  }

  String _getDeviceStatusText() {
    switch (device.type) {
      case DeviceType.light:
        return device.isOn ? 'On • ${device.brightness}%' : 'Off';
      case DeviceType.thermostat:
        return '${device.temperature.toStringAsFixed(1)}°C';
      case DeviceType.camera:
        final isRecording = device.properties['isRecording'] as bool? ?? false;
        return isRecording ? 'Recording' : 'Standby';
      case DeviceType.speaker:
        final isPlaying = device.properties['isPlaying'] as bool? ?? false;
        return isPlaying ? 'Playing' : 'Stopped';
      case DeviceType.lock:
        return device.isLocked ? 'Locked' : 'Unlocked';
      default:
        return device.statusDisplayName;
    }
  }
}