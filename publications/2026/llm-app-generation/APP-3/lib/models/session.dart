class Session {
  int? id;
  String name;
  DateTime startTime;
  DateTime endTime;
  double totalDistance;
  double totalAscent;
  double totalDescent;
  double maxAltitude;

  Session({
    this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.totalDistance,
    required this.totalAscent,
    required this.totalDescent,
    required this.maxAltitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'totalDistance': totalDistance,
      'totalAscent': totalAscent,
      'totalDescent': totalDescent,
      'maxAltitude': maxAltitude,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      name: map['name'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      totalDistance: map['totalDistance'],
      totalAscent: map['totalAscent'],
      totalDescent: map['totalDescent'],
      maxAltitude: map['maxAltitude'],
    );
  }
}