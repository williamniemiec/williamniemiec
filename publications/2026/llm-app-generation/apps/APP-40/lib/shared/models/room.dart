class Room {
  final String id;
  final String name;
  final String iconName;
  final List<String> deviceIds;
  final DateTime createdAt;

  const Room({
    required this.id,
    required this.name,
    required this.iconName,
    required this.deviceIds,
    required this.createdAt,
  });

  Room copyWith({
    String? id,
    String? name,
    String? iconName,
    List<String>? deviceIds,
    DateTime? createdAt,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      deviceIds: deviceIds ?? this.deviceIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'deviceIds': deviceIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      deviceIds: List<String>.from(json['deviceIds'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Room && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Room(id: $id, name: $name, deviceCount: ${deviceIds.length})';
  }
}