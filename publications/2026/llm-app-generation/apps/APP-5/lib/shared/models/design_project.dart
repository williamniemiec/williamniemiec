import 'design_style.dart';
import 'room_type.dart';

enum ProjectStatus {
  draft,
  processing,
  completed,
  failed,
}

class DesignProject {
  final String id;
  final String originalImagePath;
  final String? generatedImagePath;
  final RoomType roomType;
  final DesignStyle designStyle;
  final ProjectStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final bool isFavorite;
  final Map<String, dynamic>? metadata;

  const DesignProject({
    required this.id,
    required this.originalImagePath,
    this.generatedImagePath,
    required this.roomType,
    required this.designStyle,
    this.status = ProjectStatus.draft,
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
    this.isFavorite = false,
    this.metadata,
  });

  factory DesignProject.fromJson(Map<String, dynamic> json) {
    return DesignProject(
      id: json['id'] as String,
      originalImagePath: json['originalImagePath'] as String,
      generatedImagePath: json['generatedImagePath'] as String?,
      roomType: RoomType.fromJson(json['roomType'] as Map<String, dynamic>),
      designStyle: DesignStyle.fromJson(json['designStyle'] as Map<String, dynamic>),
      status: ProjectStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ProjectStatus.draft,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String) 
          : null,
      errorMessage: json['errorMessage'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalImagePath': originalImagePath,
      'generatedImagePath': generatedImagePath,
      'roomType': roomType.toJson(),
      'designStyle': designStyle.toJson(),
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'isFavorite': isFavorite,
      'metadata': metadata,
    };
  }

  DesignProject copyWith({
    String? id,
    String? originalImagePath,
    String? generatedImagePath,
    RoomType? roomType,
    DesignStyle? designStyle,
    ProjectStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? errorMessage,
    bool? isFavorite,
    Map<String, dynamic>? metadata,
  }) {
    return DesignProject(
      id: id ?? this.id,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      generatedImagePath: generatedImagePath ?? this.generatedImagePath,
      roomType: roomType ?? this.roomType,
      designStyle: designStyle ?? this.designStyle,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      isFavorite: isFavorite ?? this.isFavorite,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DesignProject && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}