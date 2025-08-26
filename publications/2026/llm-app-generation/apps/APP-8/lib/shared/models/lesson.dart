enum LessonType {
  basic,
  story,
  practice,
  checkpoint,
}

enum LessonStatus {
  locked,
  available,
  completed,
  perfect,
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final LessonType type;
  final LessonStatus status;
  final int unitNumber;
  final int lessonNumber;
  final List<Exercise> exercises;
  final int xpReward;
  final int gemsReward;
  final String? iconUrl;
  final List<String> prerequisites;
  final String language;
  final String difficulty;
  final DateTime? completedAt;
  final int? score;
  final bool isCheckpoint;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.unitNumber,
    required this.lessonNumber,
    required this.exercises,
    this.xpReward = 10,
    this.gemsReward = 5,
    this.iconUrl,
    this.prerequisites = const [],
    required this.language,
    this.difficulty = 'beginner',
    this.completedAt,
    this.score,
    this.isCheckpoint = false,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    LessonType? type,
    LessonStatus? status,
    int? unitNumber,
    int? lessonNumber,
    List<Exercise>? exercises,
    int? xpReward,
    int? gemsReward,
    String? iconUrl,
    List<String>? prerequisites,
    String? language,
    String? difficulty,
    DateTime? completedAt,
    int? score,
    bool? isCheckpoint,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      unitNumber: unitNumber ?? this.unitNumber,
      lessonNumber: lessonNumber ?? this.lessonNumber,
      exercises: exercises ?? this.exercises,
      xpReward: xpReward ?? this.xpReward,
      gemsReward: gemsReward ?? this.gemsReward,
      iconUrl: iconUrl ?? this.iconUrl,
      prerequisites: prerequisites ?? this.prerequisites,
      language: language ?? this.language,
      difficulty: difficulty ?? this.difficulty,
      completedAt: completedAt ?? this.completedAt,
      score: score ?? this.score,
      isCheckpoint: isCheckpoint ?? this.isCheckpoint,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'unitNumber': unitNumber,
      'lessonNumber': lessonNumber,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'xpReward': xpReward,
      'gemsReward': gemsReward,
      'iconUrl': iconUrl,
      'prerequisites': prerequisites,
      'language': language,
      'difficulty': difficulty,
      'completedAt': completedAt?.toIso8601String(),
      'score': score,
      'isCheckpoint': isCheckpoint,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: LessonType.values.firstWhere((e) => e.name == json['type']),
      status: LessonStatus.values.firstWhere((e) => e.name == json['status']),
      unitNumber: json['unitNumber'],
      lessonNumber: json['lessonNumber'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
      xpReward: json['xpReward'] ?? 10,
      gemsReward: json['gemsReward'] ?? 5,
      iconUrl: json['iconUrl'],
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      language: json['language'],
      difficulty: json['difficulty'] ?? 'beginner',
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt']) 
          : null,
      score: json['score'],
      isCheckpoint: json['isCheckpoint'] ?? false,
    );
  }
}

enum ExerciseType {
  translation,
  multipleChoice,
  matching,
  listening,
  speaking,
  fillInTheBlank,
  wordBank,
  imageSelection,
}

class Exercise {
  final String id;
  final ExerciseType type;
  final String question;
  final String? questionAudio;
  final List<String> options;
  final String correctAnswer;
  final List<String> acceptableAnswers;
  final String? explanation;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const Exercise({
    required this.id,
    required this.type,
    required this.question,
    this.questionAudio,
    this.options = const [],
    required this.correctAnswer,
    this.acceptableAnswers = const [],
    this.explanation,
    this.imageUrl,
    this.metadata,
  });

  Exercise copyWith({
    String? id,
    ExerciseType? type,
    String? question,
    String? questionAudio,
    List<String>? options,
    String? correctAnswer,
    List<String>? acceptableAnswers,
    String? explanation,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Exercise(
      id: id ?? this.id,
      type: type ?? this.type,
      question: question ?? this.question,
      questionAudio: questionAudio ?? this.questionAudio,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      acceptableAnswers: acceptableAnswers ?? this.acceptableAnswers,
      explanation: explanation ?? this.explanation,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'question': question,
      'questionAudio': questionAudio,
      'options': options,
      'correctAnswer': correctAnswer,
      'acceptableAnswers': acceptableAnswers,
      'explanation': explanation,
      'imageUrl': imageUrl,
      'metadata': metadata,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      type: ExerciseType.values.firstWhere((e) => e.name == json['type']),
      question: json['question'],
      questionAudio: json['questionAudio'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'],
      acceptableAnswers: List<String>.from(json['acceptableAnswers'] ?? []),
      explanation: json['explanation'],
      imageUrl: json['imageUrl'],
      metadata: json['metadata'],
    );
  }
}