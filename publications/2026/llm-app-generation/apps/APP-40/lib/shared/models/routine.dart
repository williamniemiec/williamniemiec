enum RoutineType {
  household,
  personal,
}

enum StarterType {
  voiceCommand,
  timeOfDay,
  sunrise,
  sunset,
  deviceStateChange,
  location,
}

enum ActionType {
  adjustLights,
  setThermostat,
  playMedia,
  broadcastMessage,
  controlDevices,
  sendNotification,
}

class RoutineStarter {
  final String id;
  final StarterType type;
  final Map<String, dynamic> parameters;

  const RoutineStarter({
    required this.id,
    required this.type,
    required this.parameters,
  });

  RoutineStarter copyWith({
    String? id,
    StarterType? type,
    Map<String, dynamic>? parameters,
  }) {
    return RoutineStarter(
      id: id ?? this.id,
      type: type ?? this.type,
      parameters: parameters ?? this.parameters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'parameters': parameters,
    };
  }

  factory RoutineStarter.fromJson(Map<String, dynamic> json) {
    return RoutineStarter(
      id: json['id'] as String,
      type: StarterType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => StarterType.voiceCommand,
      ),
      parameters: Map<String, dynamic>.from(json['parameters'] as Map),
    );
  }

  String get displayName {
    switch (type) {
      case StarterType.voiceCommand:
        return 'Voice command: "${parameters['command']}"';
      case StarterType.timeOfDay:
        return 'At ${parameters['time']}';
      case StarterType.sunrise:
        return 'At sunrise';
      case StarterType.sunset:
        return 'At sunset';
      case StarterType.deviceStateChange:
        return 'When ${parameters['deviceName']} ${parameters['state']}';
      case StarterType.location:
        return 'When ${parameters['action']} ${parameters['location']}';
    }
  }
}

class RoutineAction {
  final String id;
  final ActionType type;
  final Map<String, dynamic> parameters;

  const RoutineAction({
    required this.id,
    required this.type,
    required this.parameters,
  });

  RoutineAction copyWith({
    String? id,
    ActionType? type,
    Map<String, dynamic>? parameters,
  }) {
    return RoutineAction(
      id: id ?? this.id,
      type: type ?? this.type,
      parameters: parameters ?? this.parameters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'parameters': parameters,
    };
  }

  factory RoutineAction.fromJson(Map<String, dynamic> json) {
    return RoutineAction(
      id: json['id'] as String,
      type: ActionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActionType.controlDevices,
      ),
      parameters: Map<String, dynamic>.from(json['parameters'] as Map),
    );
  }

  String get displayName {
    switch (type) {
      case ActionType.adjustLights:
        return 'Adjust lights to ${parameters['brightness']}%';
      case ActionType.setThermostat:
        return 'Set thermostat to ${parameters['temperature']}°';
      case ActionType.playMedia:
        return 'Play ${parameters['media']}';
      case ActionType.broadcastMessage:
        return 'Broadcast: "${parameters['message']}"';
      case ActionType.controlDevices:
        return 'Control ${parameters['deviceCount']} devices';
      case ActionType.sendNotification:
        return 'Send notification: "${parameters['message']}"';
    }
  }
}

class Routine {
  final String id;
  final String name;
  final RoutineType type;
  final bool isEnabled;
  final List<RoutineStarter> starters;
  final List<RoutineAction> actions;
  final DateTime createdAt;
  final DateTime lastTriggered;

  const Routine({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
    required this.starters,
    required this.actions,
    required this.createdAt,
    required this.lastTriggered,
  });

  Routine copyWith({
    String? id,
    String? name,
    RoutineType? type,
    bool? isEnabled,
    List<RoutineStarter>? starters,
    List<RoutineAction>? actions,
    DateTime? createdAt,
    DateTime? lastTriggered,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      starters: starters ?? this.starters,
      actions: actions ?? this.actions,
      createdAt: createdAt ?? this.createdAt,
      lastTriggered: lastTriggered ?? this.lastTriggered,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'isEnabled': isEnabled,
      'starters': starters.map((s) => s.toJson()).toList(),
      'actions': actions.map((a) => a.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastTriggered': lastTriggered.toIso8601String(),
    };
  }

  factory Routine.fromJson(Map<String, dynamic> json) {
    return Routine(
      id: json['id'] as String,
      name: json['name'] as String,
      type: RoutineType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => RoutineType.personal,
      ),
      isEnabled: json['isEnabled'] as bool,
      starters: (json['starters'] as List)
          .map((s) => RoutineStarter.fromJson(s as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List)
          .map((a) => RoutineAction.fromJson(a as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastTriggered: DateTime.parse(json['lastTriggered'] as String),
    );
  }

  String get typeDisplayName {
    switch (type) {
      case RoutineType.household:
        return 'Household';
      case RoutineType.personal:
        return 'Personal';
    }
  }

  String get primaryStarter {
    if (starters.isEmpty) return 'No starter';
    return starters.first.displayName;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Routine && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Routine(id: $id, name: $name, type: $type, enabled: $isEnabled)';
  }
}