import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class VideoProject extends Equatable {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? thumbnailPath;
  final Duration duration;
  final List<VideoClip> clips;
  final List<AudioTrack> audioTracks;
  final List<TextOverlay> textOverlays;
  final List<Effect> effects;
  final ProjectSettings settings;

  const VideoProject({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnailPath,
    required this.duration,
    required this.clips,
    required this.audioTracks,
    required this.textOverlays,
    required this.effects,
    required this.settings,
  });

  factory VideoProject.create({
    required String name,
    ProjectSettings? settings,
  }) {
    final now = DateTime.now();
    return VideoProject(
      id: const Uuid().v4(),
      name: name,
      createdAt: now,
      updatedAt: now,
      duration: Duration.zero,
      clips: [],
      audioTracks: [],
      textOverlays: [],
      effects: [],
      settings: settings ?? ProjectSettings.defaultSettings(),
    );
  }

  VideoProject copyWith({
    String? name,
    DateTime? updatedAt,
    String? thumbnailPath,
    Duration? duration,
    List<VideoClip>? clips,
    List<AudioTrack>? audioTracks,
    List<TextOverlay>? textOverlays,
    List<Effect>? effects,
    ProjectSettings? settings,
  }) {
    return VideoProject(
      id: id,
      name: name ?? this.name,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      duration: duration ?? this.duration,
      clips: clips ?? this.clips,
      audioTracks: audioTracks ?? this.audioTracks,
      textOverlays: textOverlays ?? this.textOverlays,
      effects: effects ?? this.effects,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'thumbnailPath': thumbnailPath,
      'duration': duration.inMilliseconds,
      'clips': clips.map((clip) => clip.toJson()).toList(),
      'audioTracks': audioTracks.map((track) => track.toJson()).toList(),
      'textOverlays': textOverlays.map((overlay) => overlay.toJson()).toList(),
      'effects': effects.map((effect) => effect.toJson()).toList(),
      'settings': settings.toJson(),
    };
  }

  factory VideoProject.fromJson(Map<String, dynamic> json) {
    return VideoProject(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      thumbnailPath: json['thumbnailPath'],
      duration: Duration(milliseconds: json['duration']),
      clips: (json['clips'] as List)
          .map((clip) => VideoClip.fromJson(clip))
          .toList(),
      audioTracks: (json['audioTracks'] as List)
          .map((track) => AudioTrack.fromJson(track))
          .toList(),
      textOverlays: (json['textOverlays'] as List)
          .map((overlay) => TextOverlay.fromJson(overlay))
          .toList(),
      effects: (json['effects'] as List)
          .map((effect) => Effect.fromJson(effect))
          .toList(),
      settings: ProjectSettings.fromJson(json['settings']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        createdAt,
        updatedAt,
        thumbnailPath,
        duration,
        clips,
        audioTracks,
        textOverlays,
        effects,
        settings,
      ];
}

class VideoClip extends Equatable {
  final String id;
  final String filePath;
  final Duration startTime;
  final Duration endTime;
  final Duration timelinePosition;
  final double speed;
  final double volume;
  final bool isMuted;
  final List<Transform> transforms;
  final List<Filter> filters;

  const VideoClip({
    required this.id,
    required this.filePath,
    required this.startTime,
    required this.endTime,
    required this.timelinePosition,
    this.speed = 1.0,
    this.volume = 1.0,
    this.isMuted = false,
    required this.transforms,
    required this.filters,
  });

  Duration get duration => endTime - startTime;

  VideoClip copyWith({
    String? filePath,
    Duration? startTime,
    Duration? endTime,
    Duration? timelinePosition,
    double? speed,
    double? volume,
    bool? isMuted,
    List<Transform>? transforms,
    List<Filter>? filters,
  }) {
    return VideoClip(
      id: id,
      filePath: filePath ?? this.filePath,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timelinePosition: timelinePosition ?? this.timelinePosition,
      speed: speed ?? this.speed,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      transforms: transforms ?? this.transforms,
      filters: filters ?? this.filters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'timelinePosition': timelinePosition.inMilliseconds,
      'speed': speed,
      'volume': volume,
      'isMuted': isMuted,
      'transforms': transforms.map((t) => t.toJson()).toList(),
      'filters': filters.map((f) => f.toJson()).toList(),
    };
  }

  factory VideoClip.fromJson(Map<String, dynamic> json) {
    return VideoClip(
      id: json['id'],
      filePath: json['filePath'],
      startTime: Duration(milliseconds: json['startTime']),
      endTime: Duration(milliseconds: json['endTime']),
      timelinePosition: Duration(milliseconds: json['timelinePosition']),
      speed: json['speed']?.toDouble() ?? 1.0,
      volume: json['volume']?.toDouble() ?? 1.0,
      isMuted: json['isMuted'] ?? false,
      transforms: (json['transforms'] as List)
          .map((t) => Transform.fromJson(t))
          .toList(),
      filters: (json['filters'] as List)
          .map((f) => Filter.fromJson(f))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        filePath,
        startTime,
        endTime,
        timelinePosition,
        speed,
        volume,
        isMuted,
        transforms,
        filters,
      ];
}

class AudioTrack extends Equatable {
  final String id;
  final String filePath;
  final Duration startTime;
  final Duration endTime;
  final Duration timelinePosition;
  final double volume;
  final bool isMuted;
  final bool isVoiceover;

  const AudioTrack({
    required this.id,
    required this.filePath,
    required this.startTime,
    required this.endTime,
    required this.timelinePosition,
    this.volume = 1.0,
    this.isMuted = false,
    this.isVoiceover = false,
  });

  Duration get duration => endTime - startTime;

  AudioTrack copyWith({
    String? filePath,
    Duration? startTime,
    Duration? endTime,
    Duration? timelinePosition,
    double? volume,
    bool? isMuted,
    bool? isVoiceover,
  }) {
    return AudioTrack(
      id: id,
      filePath: filePath ?? this.filePath,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      timelinePosition: timelinePosition ?? this.timelinePosition,
      volume: volume ?? this.volume,
      isMuted: isMuted ?? this.isMuted,
      isVoiceover: isVoiceover ?? this.isVoiceover,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'timelinePosition': timelinePosition.inMilliseconds,
      'volume': volume,
      'isMuted': isMuted,
      'isVoiceover': isVoiceover,
    };
  }

  factory AudioTrack.fromJson(Map<String, dynamic> json) {
    return AudioTrack(
      id: json['id'],
      filePath: json['filePath'],
      startTime: Duration(milliseconds: json['startTime']),
      endTime: Duration(milliseconds: json['endTime']),
      timelinePosition: Duration(milliseconds: json['timelinePosition']),
      volume: json['volume']?.toDouble() ?? 1.0,
      isMuted: json['isMuted'] ?? false,
      isVoiceover: json['isVoiceover'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        id,
        filePath,
        startTime,
        endTime,
        timelinePosition,
        volume,
        isMuted,
        isVoiceover,
      ];
}

class TextOverlay extends Equatable {
  final String id;
  final String text;
  final Duration startTime;
  final Duration endTime;
  final TextStyle style;
  final Position position;
  final List<Animation> animations;

  const TextOverlay({
    required this.id,
    required this.text,
    required this.startTime,
    required this.endTime,
    required this.style,
    required this.position,
    required this.animations,
  });

  Duration get duration => endTime - startTime;

  TextOverlay copyWith({
    String? text,
    Duration? startTime,
    Duration? endTime,
    TextStyle? style,
    Position? position,
    List<Animation>? animations,
  }) {
    return TextOverlay(
      id: id,
      text: text ?? this.text,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      style: style ?? this.style,
      position: position ?? this.position,
      animations: animations ?? this.animations,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'style': style.toJson(),
      'position': position.toJson(),
      'animations': animations.map((a) => a.toJson()).toList(),
    };
  }

  factory TextOverlay.fromJson(Map<String, dynamic> json) {
    return TextOverlay(
      id: json['id'],
      text: json['text'],
      startTime: Duration(milliseconds: json['startTime']),
      endTime: Duration(milliseconds: json['endTime']),
      style: TextStyle.fromJson(json['style']),
      position: Position.fromJson(json['position']),
      animations: (json['animations'] as List)
          .map((a) => Animation.fromJson(a))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        startTime,
        endTime,
        style,
        position,
        animations,
      ];
}

class Effect extends Equatable {
  final String id;
  final String type;
  final Duration startTime;
  final Duration endTime;
  final Map<String, dynamic> parameters;

  const Effect({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.parameters,
  });

  Duration get duration => endTime - startTime;

  Effect copyWith({
    String? type,
    Duration? startTime,
    Duration? endTime,
    Map<String, dynamic>? parameters,
  }) {
    return Effect(
      id: id,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      parameters: parameters ?? this.parameters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'startTime': startTime.inMilliseconds,
      'endTime': endTime.inMilliseconds,
      'parameters': parameters,
    };
  }

  factory Effect.fromJson(Map<String, dynamic> json) {
    return Effect(
      id: json['id'],
      type: json['type'],
      startTime: Duration(milliseconds: json['startTime']),
      endTime: Duration(milliseconds: json['endTime']),
      parameters: json['parameters'],
    );
  }

  @override
  List<Object?> get props => [id, type, startTime, endTime, parameters];
}

class ProjectSettings extends Equatable {
  final int width;
  final int height;
  final int frameRate;
  final String aspectRatio;
  final String quality;

  const ProjectSettings({
    required this.width,
    required this.height,
    required this.frameRate,
    required this.aspectRatio,
    required this.quality,
  });

  factory ProjectSettings.defaultSettings() {
    return const ProjectSettings(
      width: 1080,
      height: 1920,
      frameRate: 30,
      aspectRatio: '9:16',
      quality: 'HD',
    );
  }

  ProjectSettings copyWith({
    int? width,
    int? height,
    int? frameRate,
    String? aspectRatio,
    String? quality,
  }) {
    return ProjectSettings(
      width: width ?? this.width,
      height: height ?? this.height,
      frameRate: frameRate ?? this.frameRate,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      quality: quality ?? this.quality,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'frameRate': frameRate,
      'aspectRatio': aspectRatio,
      'quality': quality,
    };
  }

  factory ProjectSettings.fromJson(Map<String, dynamic> json) {
    return ProjectSettings(
      width: json['width'],
      height: json['height'],
      frameRate: json['frameRate'],
      aspectRatio: json['aspectRatio'],
      quality: json['quality'],
    );
  }

  @override
  List<Object?> get props => [width, height, frameRate, aspectRatio, quality];
}

// Supporting classes
class Transform extends Equatable {
  final double x;
  final double y;
  final double scaleX;
  final double scaleY;
  final double rotation;

  const Transform({
    this.x = 0,
    this.y = 0,
    this.scaleX = 1,
    this.scaleY = 1,
    this.rotation = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'scaleX': scaleX,
      'scaleY': scaleY,
      'rotation': rotation,
    };
  }

  factory Transform.fromJson(Map<String, dynamic> json) {
    return Transform(
      x: json['x']?.toDouble() ?? 0,
      y: json['y']?.toDouble() ?? 0,
      scaleX: json['scaleX']?.toDouble() ?? 1,
      scaleY: json['scaleY']?.toDouble() ?? 1,
      rotation: json['rotation']?.toDouble() ?? 0,
    );
  }

  @override
  List<Object?> get props => [x, y, scaleX, scaleY, rotation];
}

class Filter extends Equatable {
  final String type;
  final double intensity;
  final Map<String, dynamic> parameters;

  const Filter({
    required this.type,
    this.intensity = 1.0,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'intensity': intensity,
      'parameters': parameters,
    };
  }

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      type: json['type'],
      intensity: json['intensity']?.toDouble() ?? 1.0,
      parameters: json['parameters'],
    );
  }

  @override
  List<Object?> get props => [type, intensity, parameters];
}

class TextStyle extends Equatable {
  final String fontFamily;
  final double fontSize;
  final String color;
  final bool isBold;
  final bool isItalic;
  final String alignment;

  const TextStyle({
    required this.fontFamily,
    required this.fontSize,
    required this.color,
    this.isBold = false,
    this.isItalic = false,
    this.alignment = 'center',
  });

  Map<String, dynamic> toJson() {
    return {
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'color': color,
      'isBold': isBold,
      'isItalic': isItalic,
      'alignment': alignment,
    };
  }

  factory TextStyle.fromJson(Map<String, dynamic> json) {
    return TextStyle(
      fontFamily: json['fontFamily'],
      fontSize: json['fontSize']?.toDouble(),
      color: json['color'],
      isBold: json['isBold'] ?? false,
      isItalic: json['isItalic'] ?? false,
      alignment: json['alignment'] ?? 'center',
    );
  }

  @override
  List<Object?> get props => [
        fontFamily,
        fontSize,
        color,
        isBold,
        isItalic,
        alignment,
      ];
}

class Position extends Equatable {
  final double x;
  final double y;

  const Position({
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      x: json['x']?.toDouble(),
      y: json['y']?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [x, y];
}

class Animation extends Equatable {
  final String type;
  final Duration duration;
  final Map<String, dynamic> parameters;

  const Animation({
    required this.type,
    required this.duration,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration': duration.inMilliseconds,
      'parameters': parameters,
    };
  }

  factory Animation.fromJson(Map<String, dynamic> json) {
    return Animation(
      type: json['type'],
      duration: Duration(milliseconds: json['duration']),
      parameters: json['parameters'],
    );
  }

  @override
  List<Object?> get props => [type, duration, parameters];
}