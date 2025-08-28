import 'package:equatable/equatable.dart';

class VideoTemplate extends Equatable {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final String previewVideoUrl;
  final Duration duration;
  final List<String> tags;
  final TemplateCategory category;
  final int requiredClips;
  final bool isPremium;
  final int downloads;
  final double rating;
  final DateTime createdAt;
  final TemplateStructure structure;

  const VideoTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.previewVideoUrl,
    required this.duration,
    required this.tags,
    required this.category,
    required this.requiredClips,
    this.isPremium = false,
    this.downloads = 0,
    this.rating = 0.0,
    required this.createdAt,
    required this.structure,
  });

  VideoTemplate copyWith({
    String? name,
    String? description,
    String? thumbnailUrl,
    String? previewVideoUrl,
    Duration? duration,
    List<String>? tags,
    TemplateCategory? category,
    int? requiredClips,
    bool? isPremium,
    int? downloads,
    double? rating,
    DateTime? createdAt,
    TemplateStructure? structure,
  }) {
    return VideoTemplate(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewVideoUrl: previewVideoUrl ?? this.previewVideoUrl,
      duration: duration ?? this.duration,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      requiredClips: requiredClips ?? this.requiredClips,
      isPremium: isPremium ?? this.isPremium,
      downloads: downloads ?? this.downloads,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      structure: structure ?? this.structure,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'previewVideoUrl': previewVideoUrl,
      'duration': duration.inMilliseconds,
      'tags': tags,
      'category': category.name,
      'requiredClips': requiredClips,
      'isPremium': isPremium,
      'downloads': downloads,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'structure': structure.toJson(),
    };
  }

  factory VideoTemplate.fromJson(Map<String, dynamic> json) {
    return VideoTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnailUrl: json['thumbnailUrl'],
      previewVideoUrl: json['previewVideoUrl'],
      duration: Duration(milliseconds: json['duration']),
      tags: List<String>.from(json['tags']),
      category: TemplateCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => TemplateCategory.trending,
      ),
      requiredClips: json['requiredClips'],
      isPremium: json['isPremium'] ?? false,
      downloads: json['downloads'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      structure: TemplateStructure.fromJson(json['structure']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        thumbnailUrl,
        previewVideoUrl,
        duration,
        tags,
        category,
        requiredClips,
        isPremium,
        downloads,
        rating,
        createdAt,
        structure,
      ];
}

enum TemplateCategory {
  trending,
  social,
  business,
  travel,
  food,
  fashion,
  fitness,
  education,
  entertainment,
  music,
  gaming,
  lifestyle,
}

class TemplateStructure extends Equatable {
  final List<TemplateClip> clips;
  final List<TemplateAudio> audioTracks;
  final List<TemplateText> textOverlays;
  final List<TemplateEffect> effects;
  final List<TemplateTransition> transitions;

  const TemplateStructure({
    required this.clips,
    required this.audioTracks,
    required this.textOverlays,
    required this.effects,
    required this.transitions,
  });

  Map<String, dynamic> toJson() {
    return {
      'clips': clips.map((c) => c.toJson()).toList(),
      'audioTracks': audioTracks.map((a) => a.toJson()).toList(),
      'textOverlays': textOverlays.map((t) => t.toJson()).toList(),
      'effects': effects.map((e) => e.toJson()).toList(),
      'transitions': transitions.map((t) => t.toJson()).toList(),
    };
  }

  factory TemplateStructure.fromJson(Map<String, dynamic> json) {
    return TemplateStructure(
      clips: (json['clips'] as List)
          .map((c) => TemplateClip.fromJson(c))
          .toList(),
      audioTracks: (json['audioTracks'] as List)
          .map((a) => TemplateAudio.fromJson(a))
          .toList(),
      textOverlays: (json['textOverlays'] as List)
          .map((t) => TemplateText.fromJson(t))
          .toList(),
      effects: (json['effects'] as List)
          .map((e) => TemplateEffect.fromJson(e))
          .toList(),
      transitions: (json['transitions'] as List)
          .map((t) => TemplateTransition.fromJson(t))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        clips,
        audioTracks,
        textOverlays,
        effects,
        transitions,
      ];
}

class TemplateClip extends Equatable {
  final int index;
  final Duration startTime;
  final Duration duration;
  final double speed;
  final List<String> filters;
  final Map<String, dynamic> transforms;

  const TemplateClip({
    required this.index,
    required this.startTime,
    required this.duration,
    this.speed = 1.0,
    required this.filters,
    required this.transforms,
  });

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'startTime': startTime.inMilliseconds,
      'duration': duration.inMilliseconds,
      'speed': speed,
      'filters': filters,
      'transforms': transforms,
    };
  }

  factory TemplateClip.fromJson(Map<String, dynamic> json) {
    return TemplateClip(
      index: json['index'],
      startTime: Duration(milliseconds: json['startTime']),
      duration: Duration(milliseconds: json['duration']),
      speed: json['speed']?.toDouble() ?? 1.0,
      filters: List<String>.from(json['filters']),
      transforms: json['transforms'],
    );
  }

  @override
  List<Object?> get props => [
        index,
        startTime,
        duration,
        speed,
        filters,
        transforms,
      ];
}

class TemplateAudio extends Equatable {
  final String audioUrl;
  final Duration startTime;
  final Duration duration;
  final double volume;
  final bool fadeIn;
  final bool fadeOut;

  const TemplateAudio({
    required this.audioUrl,
    required this.startTime,
    required this.duration,
    this.volume = 1.0,
    this.fadeIn = false,
    this.fadeOut = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'audioUrl': audioUrl,
      'startTime': startTime.inMilliseconds,
      'duration': duration.inMilliseconds,
      'volume': volume,
      'fadeIn': fadeIn,
      'fadeOut': fadeOut,
    };
  }

  factory TemplateAudio.fromJson(Map<String, dynamic> json) {
    return TemplateAudio(
      audioUrl: json['audioUrl'],
      startTime: Duration(milliseconds: json['startTime']),
      duration: Duration(milliseconds: json['duration']),
      volume: json['volume']?.toDouble() ?? 1.0,
      fadeIn: json['fadeIn'] ?? false,
      fadeOut: json['fadeOut'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
        audioUrl,
        startTime,
        duration,
        volume,
        fadeIn,
        fadeOut,
      ];
}

class TemplateText extends Equatable {
  final String text;
  final Duration startTime;
  final Duration duration;
  final Map<String, dynamic> style;
  final Map<String, dynamic> position;
  final List<Map<String, dynamic>> animations;

  const TemplateText({
    required this.text,
    required this.startTime,
    required this.duration,
    required this.style,
    required this.position,
    required this.animations,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'startTime': startTime.inMilliseconds,
      'duration': duration.inMilliseconds,
      'style': style,
      'position': position,
      'animations': animations,
    };
  }

  factory TemplateText.fromJson(Map<String, dynamic> json) {
    return TemplateText(
      text: json['text'],
      startTime: Duration(milliseconds: json['startTime']),
      duration: Duration(milliseconds: json['duration']),
      style: json['style'],
      position: json['position'],
      animations: List<Map<String, dynamic>>.from(json['animations']),
    );
  }

  @override
  List<Object?> get props => [
        text,
        startTime,
        duration,
        style,
        position,
        animations,
      ];
}

class TemplateEffect extends Equatable {
  final String type;
  final Duration startTime;
  final Duration duration;
  final Map<String, dynamic> parameters;

  const TemplateEffect({
    required this.type,
    required this.startTime,
    required this.duration,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startTime': startTime.inMilliseconds,
      'duration': duration.inMilliseconds,
      'parameters': parameters,
    };
  }

  factory TemplateEffect.fromJson(Map<String, dynamic> json) {
    return TemplateEffect(
      type: json['type'],
      startTime: Duration(milliseconds: json['startTime']),
      duration: Duration(milliseconds: json['duration']),
      parameters: json['parameters'],
    );
  }

  @override
  List<Object?> get props => [type, startTime, duration, parameters];
}

class TemplateTransition extends Equatable {
  final String type;
  final Duration duration;
  final int fromClipIndex;
  final int toClipIndex;
  final Map<String, dynamic> parameters;

  const TemplateTransition({
    required this.type,
    required this.duration,
    required this.fromClipIndex,
    required this.toClipIndex,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'duration': duration.inMilliseconds,
      'fromClipIndex': fromClipIndex,
      'toClipIndex': toClipIndex,
      'parameters': parameters,
    };
  }

  factory TemplateTransition.fromJson(Map<String, dynamic> json) {
    return TemplateTransition(
      type: json['type'],
      duration: Duration(milliseconds: json['duration']),
      fromClipIndex: json['fromClipIndex'],
      toClipIndex: json['toClipIndex'],
      parameters: json['parameters'],
    );
  }

  @override
  List<Object?> get props => [
        type,
        duration,
        fromClipIndex,
        toClipIndex,
        parameters,
      ];
}