import 'user.dart';
import 'post.dart';

class RedditComment {
  final String id;
  final String? parentId;
  final String postId;
  final String content;
  final RedditUser author;
  final DateTime createdAt;
  final int score;
  final int upvotes;
  final int downvotes;
  final VoteStatus userVote;
  final bool isSaved;
  final bool isEdited;
  final bool isDeleted;
  final bool isRemoved;
  final bool isStickied;
  final bool isScoreHidden;
  final int depth;
  final List<RedditComment> replies;
  final List<String> awards;
  final String? flair;
  final String? flairColor;
  final bool isCollapsed;
  final bool isSubmitter;
  final bool isModerator;
  final bool isAdmin;
  final Map<String, dynamic> metadata;

  const RedditComment({
    required this.id,
    this.parentId,
    required this.postId,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.score,
    this.upvotes = 0,
    this.downvotes = 0,
    this.userVote = VoteStatus.none,
    this.isSaved = false,
    this.isEdited = false,
    this.isDeleted = false,
    this.isRemoved = false,
    this.isStickied = false,
    this.isScoreHidden = false,
    this.depth = 0,
    this.replies = const [],
    this.awards = const [],
    this.flair,
    this.flairColor,
    this.isCollapsed = false,
    this.isSubmitter = false,
    this.isModerator = false,
    this.isAdmin = false,
    this.metadata = const {},
  });

  factory RedditComment.fromJson(Map<String, dynamic> json, {int depth = 0}) {
    final data = json['data'] ?? json;
    
    // Parse replies
    List<RedditComment> replies = [];
    if (data['replies'] != null && data['replies'] != '') {
      final repliesData = data['replies'];
      if (repliesData is Map && repliesData['data']?['children'] is List) {
        replies = (repliesData['data']['children'] as List)
            .where((reply) => reply['kind'] == 't1') // Only comments, not "more" objects
            .map((reply) => RedditComment.fromJson(reply, depth: depth + 1))
            .toList();
      }
    }

    return RedditComment(
      id: data['id'] ?? '',
      parentId: data['parent_id']?.toString().replaceFirst('t1_', ''),
      postId: data['link_id']?.toString().replaceFirst('t3_', '') ?? '',
      content: data['body'] ?? '',
      author: RedditUser.fromJson({
        'name': data['author'] ?? '[deleted]',
        'id': data['author_fullname'] ?? '',
      }),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['created_utc'] ?? 0) * 1000).toInt(),
      ),
      score: (data['score'] ?? 0).toInt(),
      upvotes: (data['ups'] ?? 0).toInt(),
      downvotes: (data['downs'] ?? 0).toInt(),
      userVote: _parseVoteStatus(data['likes']),
      isSaved: data['saved'] ?? false,
      isEdited: data['edited'] is num && data['edited'] > 0,
      isDeleted: data['author'] == '[deleted]',
      isRemoved: data['body'] == '[removed]',
      isStickied: data['stickied'] ?? false,
      isScoreHidden: data['score_hidden'] ?? false,
      depth: depth,
      replies: replies,
      awards: _parseAwards(data['all_awardings']),
      flair: data['author_flair_text'],
      flairColor: data['author_flair_background_color'],
      isCollapsed: data['collapsed'] ?? false,
      isSubmitter: data['is_submitter'] ?? false,
      isModerator: data['distinguished'] == 'moderator',
      isAdmin: data['distinguished'] == 'admin',
      metadata: {
        'gilded': data['gilded'] ?? 0,
        'controversiality': data['controversiality'] ?? 0,
        'can_gild': data['can_gild'] ?? false,
        'can_mod_post': data['can_mod_post'] ?? false,
      },
    );
  }

  static VoteStatus _parseVoteStatus(dynamic likes) {
    if (likes == true) return VoteStatus.upvoted;
    if (likes == false) return VoteStatus.downvoted;
    return VoteStatus.none;
  }

  static List<String> _parseAwards(dynamic awardings) {
    if (awardings is! List) return [];
    return awardings
        .map((award) => award['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .cast<String>()
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId != null ? 't1_$parentId' : null,
      'link_id': 't3_$postId',
      'body': content,
      'author': author.username,
      'author_fullname': author.id,
      'created_utc': createdAt.millisecondsSinceEpoch / 1000,
      'score': score,
      'ups': upvotes,
      'downs': downvotes,
      'likes': userVote == VoteStatus.upvoted ? true : 
               userVote == VoteStatus.downvoted ? false : null,
      'saved': isSaved,
      'edited': isEdited,
      'stickied': isStickied,
      'score_hidden': isScoreHidden,
      'depth': depth,
      'replies': replies.map((reply) => reply.toJson()).toList(),
      'all_awardings': awards.map((award) => {'name': award}).toList(),
      'author_flair_text': flair,
      'author_flair_background_color': flairColor,
      'collapsed': isCollapsed,
      'is_submitter': isSubmitter,
      'distinguished': isModerator ? 'moderator' : (isAdmin ? 'admin' : null),
      'metadata': metadata,
    };
  }

  RedditComment copyWith({
    String? id,
    String? parentId,
    String? postId,
    String? content,
    RedditUser? author,
    DateTime? createdAt,
    int? score,
    int? upvotes,
    int? downvotes,
    VoteStatus? userVote,
    bool? isSaved,
    bool? isEdited,
    bool? isDeleted,
    bool? isRemoved,
    bool? isStickied,
    bool? isScoreHidden,
    int? depth,
    List<RedditComment>? replies,
    List<String>? awards,
    String? flair,
    String? flairColor,
    bool? isCollapsed,
    bool? isSubmitter,
    bool? isModerator,
    bool? isAdmin,
    Map<String, dynamic>? metadata,
  }) {
    return RedditComment(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      userVote: userVote ?? this.userVote,
      isSaved: isSaved ?? this.isSaved,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isRemoved: isRemoved ?? this.isRemoved,
      isStickied: isStickied ?? this.isStickied,
      isScoreHidden: isScoreHidden ?? this.isScoreHidden,
      depth: depth ?? this.depth,
      replies: replies ?? this.replies,
      awards: awards ?? this.awards,
      flair: flair ?? this.flair,
      flairColor: flairColor ?? this.flairColor,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      isSubmitter: isSubmitter ?? this.isSubmitter,
      isModerator: isModerator ?? this.isModerator,
      isAdmin: isAdmin ?? this.isAdmin,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedScore {
    if (isScoreHidden) return '•';
    if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}M';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(1)}k';
    }
    return score.toString();
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  String get displayContent {
    if (isDeleted) return '[deleted]';
    if (isRemoved) return '[removed]';
    return content;
  }

  String get authorDisplayName {
    if (isDeleted) return '[deleted]';
    return author.username;
  }

  bool get hasReplies => replies.isNotEmpty;
  
  int get totalRepliesCount {
    int count = replies.length;
    for (final reply in replies) {
      count += reply.totalRepliesCount;
    }
    return count;
  }

  List<RedditComment> get flattenedReplies {
    List<RedditComment> flattened = [];
    for (final reply in replies) {
      flattened.add(reply);
      flattened.addAll(reply.flattenedReplies);
    }
    return flattened;
  }

  RedditComment addReply(RedditComment reply) {
    return copyWith(
      replies: [...replies, reply.copyWith(depth: depth + 1)],
    );
  }

  RedditComment removeReply(String replyId) {
    return copyWith(
      replies: replies.where((reply) => reply.id != replyId).toList(),
    );
  }

  RedditComment updateReply(RedditComment updatedReply) {
    final updatedReplies = replies.map((reply) {
      if (reply.id == updatedReply.id) {
        return updatedReply.copyWith(depth: reply.depth);
      }
      return reply;
    }).toList();
    
    return copyWith(replies: updatedReplies);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RedditComment && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RedditComment(id: $id, author: ${author.username}, score: $score, depth: $depth)';
  }
}

// Helper class for comment threading
class CommentThread {
  final RedditComment rootComment;
  final List<RedditComment> allComments;
  final int maxDepth;

  const CommentThread({
    required this.rootComment,
    required this.allComments,
    this.maxDepth = 10,
  });

  factory CommentThread.fromComment(RedditComment comment) {
    final allComments = [comment, ...comment.flattenedReplies];
    final maxDepth = allComments.fold<int>(
      0, 
      (max, comment) => comment.depth > max ? comment.depth : max,
    );
    
    return CommentThread(
      rootComment: comment,
      allComments: allComments,
      maxDepth: maxDepth,
    );
  }

  List<RedditComment> getCommentsAtDepth(int depth) {
    return allComments.where((comment) => comment.depth == depth).toList();
  }

  RedditComment? findComment(String commentId) {
    return allComments.firstWhere(
      (comment) => comment.id == commentId,
      orElse: () => throw StateError('Comment not found'),
    );
  }

  int get totalComments => allComments.length;
  
  bool get hasNestedReplies => maxDepth > 0;
}