class Comment {
  final String id;
  final String pinId;
  final String userId;
  final String username;
  final String? userProfileImageUrl;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final bool isLiked;
  final String? parentCommentId; // For replies
  final List<Comment> replies;

  const Comment({
    required this.id,
    required this.pinId,
    required this.userId,
    required this.username,
    this.userProfileImageUrl,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.likesCount = 0,
    this.isLiked = false,
    this.parentCommentId,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      pinId: json['pinId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userProfileImageUrl: json['userProfileImageUrl'] as String?,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      parentCommentId: json['parentCommentId'] as String?,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pinId': pinId,
      'userId': userId,
      'username': username,
      'userProfileImageUrl': userProfileImageUrl,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likesCount': likesCount,
      'isLiked': isLiked,
      'parentCommentId': parentCommentId,
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  Comment copyWith({
    String? id,
    String? pinId,
    String? userId,
    String? username,
    String? userProfileImageUrl,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    bool? isLiked,
    String? parentCommentId,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      pinId: pinId ?? this.pinId,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      replies: replies ?? this.replies,
    );
  }

  bool get isReply => parentCommentId != null;
  bool get hasReplies => replies.isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Comment(id: $id, content: $content, username: $username)';
  }
}