enum DeviceType {
  light,
  thermostat,
  camera,
  speaker,
  display,
  smartPlug,
  lock,
  sensor,
  switch_,
  fan,
}

enum DeviceStatus {
  online,
  offline,
  updating,
  error,
}

class Device {
  final String id;
  final String name;
  final DeviceType type;
  final String roomId;
  final DeviceStatus status;
  final Map<String, dynamic> properties;
  final DateTime lastUpdated;
  final bool isFavorite;

  const Device({
    required this.id,
    required this.name,
    required this.type,
    required this.roomId,
    required this.status,
    required this.properties,
    required this.lastUpdated,
    this.isFavorite = false,
  });

  Device copyWith({
    String? id,
    String? name,
    DeviceType? type,
    String? roomId,
    DeviceStatus? status,
    Map<String, dynamic>? properties,
    DateTime? lastUpdated,
    bool? isFavorite,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      roomId: roomId ?? this.roomId,
      status: status ?? this.status,
      properties: properties ?? this.properties,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'roomId': roomId,
      'status': status.name,
      'properties': properties,
      'lastUpdated': lastUpdated.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] as String,
      name: json['name'] as String,
      type: DeviceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DeviceType.switch_,
      ),
      roomId: json['roomId'] as String,
      status: DeviceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DeviceStatus.offline,
      ),
      properties: Map<String, dynamic>.from(json['properties'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  String get typeDisplayName {
    switch (type) {
      case DeviceType.light:
        return 'Light';
      case DeviceType.thermostat:
        return 'Thermostat';
      case DeviceType.camera:
        return 'Camera';
      case DeviceType.speaker:
        return 'Speaker';
      case DeviceType.display:
        return 'Display';
      case DeviceType.smartPlug:
        return 'Smart Plug';
      case DeviceType.lock:
        return 'Lock';
      case DeviceType.sensor:
        return 'Sensor';
      case DeviceType.switch_:
        return 'Switch';
      case DeviceType.fan:
        return 'Fan';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case DeviceStatus.online:
        return 'Online';
      case DeviceStatus.offline:
        return 'Offline';
      case DeviceStatus.updating:
        return 'Updating';
      case DeviceStatus.error:
        return 'Error';
    }
  }

  // Helper methods for specific device types
  bool get isOn {
    return properties['isOn'] as bool? ?? false;
  }

  int get brightness {
    return properties['brightness'] as int? ?? 0;
  }

  double get temperature {
    return properties['temperature'] as double? ?? 20.0;
  }

  bool get isLocked {
    return properties['isLocked'] as bool? ?? false;
  }

  int get volume {
    return properties['volume'] as int? ?? 50;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Device && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Device(id: $id, name: $name, type: $type, status: $status)';
  }
}