class Sound {
  final String id;
  final String name;
  final String audioUrl;
  final String? artistName;
  final String? albumCover;
  final int duration; // in seconds
  final int usageCount; // how many videos use this sound
  final bool isTrending;
  final bool isOriginal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Sound({
    required this.id,
    required this.name,
    required this.audioUrl,
    this.artistName,
    this.albumCover,
    required this.duration,
    this.usageCount = 0,
    this.isTrending = false,
    this.isOriginal = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      id: json['id'] as String,
      name: json['name'] as String,
      audioUrl: json['audioUrl'] as String,
      artistName: json['artistName'] as String?,
      albumCover: json['albumCover'] as String?,
      duration: json['duration'] as int,
      usageCount: json['usageCount'] as int? ?? 0,
      isTrending: json['isTrending'] as bool? ?? false,
      isOriginal: json['isOriginal'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'audioUrl': audioUrl,
      'artistName': artistName,
      'albumCover': albumCover,
      'duration': duration,
      'usageCount': usageCount,
      'isTrending': isTrending,
      'isOriginal': isOriginal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Sound copyWith({
    String? id,
    String? name,
    String? audioUrl,
    String? artistName,
    String? albumCover,
    int? duration,
    int? usageCount,
    bool? isTrending,
    bool? isOriginal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Sound(
      id: id ?? this.id,
      name: name ?? this.name,
      audioUrl: audioUrl ?? this.audioUrl,
      artistName: artistName ?? this.artistName,
      albumCover: albumCover ?? this.albumCover,
      duration: duration ?? this.duration,
      usageCount: usageCount ?? this.usageCount,
      isTrending: isTrending ?? this.isTrending,
      isOriginal: isOriginal ?? this.isOriginal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sound && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Sound(id: $id, name: $name, artist: $artistName)';
  }
}