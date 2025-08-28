import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/models/device.dart';

class FavoriteDeviceCard extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const FavoriteDeviceCard({
    super.key,
    required this.device,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getDeviceColor(device.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getDeviceIcon(device.type),
                      color: _getDeviceColor(device.type),
                      size: 24,
                    ),
                  ),
                  _buildStatusIndicator(context),
                ],
              ),
              
              const SizedBox(height: AppConstants.smallPadding),
              
              // Device name
              Text(
                device.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Device status/value
              Text(
                _getDeviceStatusText(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              
              const Spacer(),
              
              // Control section
              _buildDeviceControl(context),
            ],
          ),
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
      case DeviceType.thermostat:
        return _buildThermostatControl(context);
      case DeviceType.speaker:
        return _buildSpeakerControl(context);
      case DeviceType.camera:
        return _buildCameraControl(context);
      default:
        return _buildGenericControl(context);
    }
  }

  Widget _buildLightControl(BuildContext context) {
    final isOn = device.isOn;
    final brightness = device.brightness;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isOn && brightness > 0)
          Text(
            '$brightness%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          const SizedBox.shrink(),
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: AppConstants.shortAnimation,
            width: 48,
            height: 28,
            decoration: BoxDecoration(
              color: isOn
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedAlign(
              duration: AppConstants.shortAnimation,
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThermostatControl(BuildContext context) {
    final temperature = device.temperature;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${temperature.toStringAsFixed(1)}°C',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _adjustTemperature(-0.5),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: const Icon(Icons.remove, size: 16),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _adjustTemperature(0.5),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: const Icon(Icons.add, size: 16),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpeakerControl(BuildContext context) {
    final isPlaying = device.properties['isPlaying'] as bool? ?? false;
    final volume = device.volume;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Vol: $volume%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isPlaying
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
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
        ),
      ],
    );
  }

  Widget _buildCameraControl(BuildContext context) {
    final isRecording = device.properties['isRecording'] as bool? ?? false;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isRecording ? Colors.red : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              isRecording ? 'Recording' : 'Standby',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        Icon(
          Icons.videocam,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildGenericControl(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.more_horiz,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          size: 20,
        ),
      ],
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
      default:
        return device.statusDisplayName;
    }
  }

  void _adjustTemperature(double delta) {
    // This would typically call a service to adjust the temperature
    // For now, it's just a placeholder
  }
}