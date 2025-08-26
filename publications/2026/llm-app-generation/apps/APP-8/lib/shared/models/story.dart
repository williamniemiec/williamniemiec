enum StoryStatus {
  locked,
  available,
  completed,
}

class Story {
  final String id;
  final String title;
  final String description;
  final StoryStatus status;
  final List<StoryPart> parts;
  final String language;
  final String difficulty;
  final int xpReward;
  final int gemsReward;
  final String? thumbnailUrl;
  final List<String> prerequisites;
  final DateTime? completedAt;
  final int? score;
  final int estimatedMinutes;

  const Story({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.parts,
    required this.language,
    this.difficulty = 'beginner',
    this.xpReward = 15,
    this.gemsReward = 8,
    this.thumbnailUrl,
    this.prerequisites = const [],
    this.completedAt,
    this.score,
    this.estimatedMinutes = 5,
  });

  Story copyWith({
    String? id,
    String? title,
    String? description,
    StoryStatus? status,
    List<StoryPart>? parts,
    String? language,
    String? difficulty,
    int? xpReward,
    int? gemsReward,
    String? thumbnailUrl,
    List<String>? prerequisites,
    DateTime? completedAt,
    int? score,
    int? estimatedMinutes,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      parts: parts ?? this.parts,
      language: language ?? this.language,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      gemsReward: gemsReward ?? this.gemsReward,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      prerequisites: prerequisites ?? this.prerequisites,
      completedAt: completedAt ?? this.completedAt,
      score: score ?? this.score,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'parts': parts.map((p) => p.toJson()).toList(),
      'language': language,
      'difficulty': difficulty,
      'xpReward': xpReward,
      'gemsReward': gemsReward,
      'thumbnailUrl': thumbnailUrl,
      'prerequisites': prerequisites,
      'completedAt': completedAt?.toIso8601String(),
      'score': score,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: StoryStatus.values.firstWhere((e) => e.name == json['status']),
      parts: (json['parts'] as List)
          .map((p) => StoryPart.fromJson(p))
          .toList(),
      language: json['language'],
      difficulty: json['difficulty'] ?? 'beginner',
      xpReward: json['xpReward'] ?? 15,
      gemsReward: json['gemsReward'] ?? 8,
      thumbnailUrl: json['thumbnailUrl'],
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      score: json['score'],
      estimatedMinutes: json['estimatedMinutes'] ?? 5,
    );
  }
}

enum StoryPartType {
  dialogue,
  question,
  choice,
}

class StoryPart {
  final String id;
  final StoryPartType type;
  final String? character;
  final String? characterImageUrl;
  final String text;
  final String? audioUrl;
  final List<String>? choices;
  final String? correctChoice;
  final String? question;
  final String? answer;
  final Map<String, dynamic>? metadata;

  const StoryPart({
    required this.id,
    required this.type,
    this.character,
    this.characterImageUrl,
    required this.text,
    this.audioUrl,
    this.choices,
    this.correctChoice,
    this.question,
    this.answer,
    this.metadata,
  });

  StoryPart copyWith({
    String? id,
    StoryPartType? type,
    String? character,
    String? characterImageUrl,
    String? text,
    String? audioUrl,
    List<String>? choices,
    String? correctChoice,
    String? question,
    String? answer,
    Map<String, dynamic>? metadata,
  }) {
    return StoryPart(
      id: id ?? this.id,
      type: type ?? this.type,
      character: character ?? this.character,
      characterImageUrl: characterImageUrl ?? this.characterImageUrl,
      text: text ?? this.text,
      audioUrl: audioUrl ?? this.audioUrl,
      choices: choices ?? this.choices,
      correctChoice: correctChoice ?? this.correctChoice,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'character': character,
      'characterImageUrl': characterImageUrl,
      'text': text,
      'audioUrl': audioUrl,
      'choices': choices,
      'correctChoice': correctChoice,
      'question': question,
      'answer': answer,
      'metadata': metadata,
    };
  }

  factory StoryPart.fromJson(Map<String, dynamic> json) {
    return StoryPart(
      id: json['id'],
      type: StoryPartType.values.firstWhere((e) => e.name == json['type']),
      character: json['character'],
      characterImageUrl: json['characterImageUrl'],
      text: json['text'],
      audioUrl: json['audioUrl'],
      choices: json['choices'] != null 
          ? List<String>.from(json['choices']) 
          : null,
      correctChoice: json['correctChoice'],
      question: json['question'],
      answer: json['answer'],
      metadata: json['metadata'],
    );
  }
}