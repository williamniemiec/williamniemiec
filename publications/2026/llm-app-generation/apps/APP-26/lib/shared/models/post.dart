import 'package:hive/hive.dart';
import 'user.dart';

part 'post.g.dart';

@HiveType(typeId: 1)
class Post extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String authorId;

  @HiveField(2)
  final User author;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final List<String> mediaUrls;

  @HiveField(5)
  final String type; // text, image, video, poll, repost, quote

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  @HiveField(8)
  final int likesCount;

  @HiveField(9)
  final int repostsCount;

  @HiveField(10)
  final int repliesCount;

  @HiveField(11)
  final int viewsCount;

  @HiveField(12)
  final int bookmarksCount;

  @HiveField(13)
  final bool isLiked;

  @HiveField(14)
  final bool isReposted;

  @HiveField(15)
  final bool isBookmarked;

  @HiveField(16)
  final String? replyToId;

  @HiveField(17)
  final Post? replyTo;

  @HiveField(18)
  final String? repostOfId;

  @HiveField(19)
  final Post? repostOf;

  @HiveField(20)
  final String? quoteOfId;

  @HiveField(21)
  final Post? quoteOf;

  @HiveField(22)
  final List<String> hashtags;

  @HiveField(23)
  final List<String> mentions;

  @HiveField(24)
  final List<String> urls;

  @HiveField(25)
  final Poll? poll;

  @HiveField(26)
  final bool isEdited;

  @HiveField(27)
  final DateTime? editedAt;

  @HiveField(28)
  final bool isPinned;

  @HiveField(29)
  final String? location;

  @HiveField(30)
  final Map<String, dynamic>? metadata;

  Post({
    required this.id,
    required this.authorId,
    required this.author,
    required this.content,
    this.mediaUrls = const [],
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.likesCount = 0,
    this.repostsCount = 0,
    this.repliesCount = 0,
    this.viewsCount = 0,
    this.bookmarksCount = 0,
    this.isLiked = false,
    this.isReposted = false,
    this.isBookmarked = false,
    this.replyToId,
    this.replyTo,
    this.repostOfId,
    this.repostOf,
    this.quoteOfId,
    this.quoteOf,
    this.hashtags = const [],
    this.mentions = const [],
    this.urls = const [],
    this.poll,
    this.isEdited = false,
    this.editedAt,
    this.isPinned = false,
    this.location,
    this.metadata,
  });

  Post copyWith({
    String? id,
    String? authorId,
    User? author,
    String? content,
    List<String>? mediaUrls,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? repostsCount,
    int? repliesCount,
    int? viewsCount,
    int? bookmarksCount,
    bool? isLiked,
    bool? isReposted,
    bool? isBookmarked,
    String? replyToId,
    Post? replyTo,
    String? repostOfId,
    Post? repostOf,
    String? quoteOfId,
    Post? quoteOf,
    List<String>? hashtags,
    List<String>? mentions,
    List<String>? urls,
    Poll? poll,
    bool? isEdited,
    DateTime? editedAt,
    bool? isPinned,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      author: author ?? this.author,
      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      repostsCount: repostsCount ?? this.repostsCount,
      repliesCount: repliesCount ?? this.repliesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      bookmarksCount: bookmarksCount ?? this.bookmarksCount,
      isLiked: isLiked ?? this.isLiked,
      isReposted: isReposted ?? this.isReposted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      replyToId: replyToId ?? this.replyToId,
      replyTo: replyTo ?? this.replyTo,
      repostOfId: repostOfId ?? this.repostOfId,
      repostOf: repostOf ?? this.repostOf,
      quoteOfId: quoteOfId ?? this.quoteOfId,
      quoteOf: quoteOf ?? this.quoteOf,
      hashtags: hashtags ?? this.hashtags,
      mentions: mentions ?? this.mentions,
      urls: urls ?? this.urls,
      poll: poll ?? this.poll,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      isPinned: isPinned ?? this.isPinned,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'author': author.toJson(),
      'content': content,
      'mediaUrls': mediaUrls,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likesCount': likesCount,
      'repostsCount': repostsCount,
      'repliesCount': repliesCount,
      'viewsCount': viewsCount,
      'bookmarksCount': bookmarksCount,
      'isLiked': isLiked,
      'isReposted': isReposted,
      'isBookmarked': isBookmarked,
      'replyToId': replyToId,
      'replyTo': replyTo?.toJson(),
      'repostOfId': repostOfId,
      'repostOf': repostOf?.toJson(),
      'quoteOfId': quoteOfId,
      'quoteOf': quoteOf?.toJson(),
      'hashtags': hashtags,
      'mentions': mentions,
      'urls': urls,
      'poll': poll?.toJson(),
      'isEdited': isEdited,
      'editedAt': editedAt?.toIso8601String(),
      'isPinned': isPinned,
      'location': location,
      'metadata': metadata,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      content: json['content'] as String,
      mediaUrls: List<String>.from(json['mediaUrls'] as List? ?? []),
      type: json['type'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      likesCount: json['likesCount'] as int? ?? 0,
      repostsCount: json['repostsCount'] as int? ?? 0,
      repliesCount: json['repliesCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as int? ?? 0,
      bookmarksCount: json['bookmarksCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      isReposted: json['isReposted'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      replyToId: json['replyToId'] as String?,
      replyTo: json['replyTo'] != null 
          ? Post.fromJson(json['replyTo'] as Map<String, dynamic>)
          : null,
      repostOfId: json['repostOfId'] as String?,
      repostOf: json['repostOf'] != null 
          ? Post.fromJson(json['repostOf'] as Map<String, dynamic>)
          : null,
      quoteOfId: json['quoteOfId'] as String?,
      quoteOf: json['quoteOf'] != null 
          ? Post.fromJson(json['quoteOf'] as Map<String, dynamic>)
          : null,
      hashtags: List<String>.from(json['hashtags'] as List? ?? []),
      mentions: List<String>.from(json['mentions'] as List? ?? []),
      urls: List<String>.from(json['urls'] as List? ?? []),
      poll: json['poll'] != null 
          ? Poll.fromJson(json['poll'] as Map<String, dynamic>)
          : null,
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] != null 
          ? DateTime.parse(json['editedAt'] as String)
          : null,
      isPinned: json['isPinned'] as bool? ?? false,
      location: json['location'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Post && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Post(id: $id, authorId: $authorId, content: ${content.length > 50 ? '${content.substring(0, 50)}...' : content})';
  }
}

@HiveType(typeId: 2)
class Poll extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<PollOption> options;

  @HiveField(2)
  final DateTime endsAt;

  @HiveField(3)
  final int totalVotes;

  @HiveField(4)
  final bool hasVoted;

  @HiveField(5)
  final String? votedOptionId;

  Poll({
    required this.id,
    required this.options,
    required this.endsAt,
    this.totalVotes = 0,
    this.hasVoted = false,
    this.votedOptionId,
  });

  Poll copyWith({
    String? id,
    List<PollOption>? options,
    DateTime? endsAt,
    int? totalVotes,
    bool? hasVoted,
    String? votedOptionId,
  }) {
    return Poll(
      id: id ?? this.id,
      options: options ?? this.options,
      endsAt: endsAt ?? this.endsAt,
      totalVotes: totalVotes ?? this.totalVotes,
      hasVoted: hasVoted ?? this.hasVoted,
      votedOptionId: votedOptionId ?? this.votedOptionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'options': options.map((option) => option.toJson()).toList(),
      'endsAt': endsAt.toIso8601String(),
      'totalVotes': totalVotes,
      'hasVoted': hasVoted,
      'votedOptionId': votedOptionId,
    };
  }

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
      id: json['id'] as String,
      options: (json['options'] as List)
          .map((option) => PollOption.fromJson(option as Map<String, dynamic>))
          .toList(),
      endsAt: DateTime.parse(json['endsAt'] as String),
      totalVotes: json['totalVotes'] as int? ?? 0,
      hasVoted: json['hasVoted'] as bool? ?? false,
      votedOptionId: json['votedOptionId'] as String?,
    );
  }

  bool get isExpired => DateTime.now().isAfter(endsAt);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Poll && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@HiveType(typeId: 3)
class PollOption extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final int votes;

  PollOption({
    required this.id,
    required this.text,
    this.votes = 0,
  });

  PollOption copyWith({
    String? id,
    String? text,
    int? votes,
  }) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      votes: votes ?? this.votes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'votes': votes,
    };
  }

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] as String,
      text: json['text'] as String,
      votes: json['votes'] as int? ?? 0,
    );
  }

  double getPercentage(int totalVotes) {
    if (totalVotes == 0) return 0.0;
    return (votes / totalVotes) * 100;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PollOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}