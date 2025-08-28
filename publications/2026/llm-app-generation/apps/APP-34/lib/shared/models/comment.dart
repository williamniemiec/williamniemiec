import 'user.dart';

class Comment {
  final String id;
  final String videoId;
  final User user;
  final String text;
  final int likesCount;
  final bool isLiked;
  final String? parentCommentId; // For replies
  final List<Comment> replies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Comment({
    required this.id,
    required this.videoId,
    required this.user,
    required this.text,
    this.likesCount = 0,
    this.isLiked = false,
    this.parentCommentId,
    this.replies = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      videoId: json['videoId'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      text: json['text'] as String,
      likesCount: json['likesCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      parentCommentId: json['parentCommentId'] as String?,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoId': videoId,
      'user': user.toJson(),
      'text': text,
      'likesCount': likesCount,
      'isLiked': isLiked,
      'parentCommentId': parentCommentId,
      'replies': replies.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Comment copyWith({
    String? id,
    String? videoId,
    User? user,
    String? text,
    int? likesCount,
    bool? isLiked,
    String? parentCommentId,
    List<Comment>? replies,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      id: id ?? this.id,
      videoId: videoId ?? this.videoId,
      user: user ?? this.user,
      text: text ?? this.text,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isReply => parentCommentId != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Comment(id: $id, user: ${user.username}, text: $text)';
  }
}