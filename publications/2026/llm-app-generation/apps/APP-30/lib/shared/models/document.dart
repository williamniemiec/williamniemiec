import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';

class Document {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime lastModified;
  final String ownerId;
  final String status;
  final List<String> collaborators;
  final List<DocumentVersion> versions;
  final bool isOfflineAvailable;
  final String templateId;
  final Map<String, dynamic> metadata;

  Document({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? lastModified,
    required this.ownerId,
    this.status = 'draft',
    this.collaborators = const [],
    this.versions = const [],
    this.isOfflineAvailable = false,
    this.templateId = '',
    this.metadata = const {},
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

  Document copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? lastModified,
    String? ownerId,
    String? status,
    List<String>? collaborators,
    List<DocumentVersion>? versions,
    bool? isOfflineAvailable,
    String? templateId,
    Map<String, dynamic>? metadata,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      lastModified: lastModified ?? this.lastModified,
      ownerId: ownerId ?? this.ownerId,
      status: status ?? this.status,
      collaborators: collaborators ?? this.collaborators,
      versions: versions ?? this.versions,
      isOfflineAvailable: isOfflineAvailable ?? this.isOfflineAvailable,
      templateId: templateId ?? this.templateId,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'ownerId': ownerId,
      'status': status,
      'collaborators': collaborators,
      'versions': versions.map((v) => v.toJson()).toList(),
      'isOfflineAvailable': isOfflineAvailable,
      'templateId': templateId,
      'metadata': metadata,
    };
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
      ownerId: json['ownerId'],
      status: json['status'] ?? 'draft',
      collaborators: List<String>.from(json['collaborators'] ?? []),
      versions: (json['versions'] as List<dynamic>?)
              ?.map((v) => DocumentVersion.fromJson(v))
              .toList() ??
          [],
      isOfflineAvailable: json['isOfflineAvailable'] ?? false,
      templateId: json['templateId'] ?? '',
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  // Helper methods
  bool get isShared => collaborators.isNotEmpty;
  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';
  
  String get formattedLastModified {
    final now = DateTime.now();
    final difference = now.difference(lastModified);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${lastModified.day}/${lastModified.month}/${lastModified.year}';
    }
  }

  // Helper method to get plain text content
  String get plainTextContent {
    // For now, return content as is. Later we can parse Delta format
    return content;
  }
}

class DocumentVersion {
  final String id;
  final String documentId;
  final String content;
  final DateTime createdAt;
  final String authorId;
  final String comment;
  final int versionNumber;

  DocumentVersion({
    String? id,
    required this.documentId,
    required this.content,
    DateTime? createdAt,
    required this.authorId,
    this.comment = '',
    required this.versionNumber,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'authorId': authorId,
      'comment': comment,
      'versionNumber': versionNumber,
    };
  }

  factory DocumentVersion.fromJson(Map<String, dynamic> json) {
    return DocumentVersion(
      id: json['id'],
      documentId: json['documentId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      authorId: json['authorId'],
      comment: json['comment'] ?? '',
      versionNumber: json['versionNumber'],
    );
  }
}