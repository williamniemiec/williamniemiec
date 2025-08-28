import 'user.dart';
import 'subreddit.dart';

enum PostType { text, image, video, link, poll, gallery }

enum VoteStatus { upvoted, downvoted, none }

class PostMedia {
  final String? imageUrl;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
  final String? caption;
  final bool isGif;

  const PostMedia({
    this.imageUrl,
    this.videoUrl,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.caption,
    this.isGif = false,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) {
    return PostMedia(
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      width: json['width']?.toInt(),
      height: json['height']?.toInt(),
      caption: json['caption'],
      isGif: json['is_gif'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'caption': caption,
      'is_gif': isGif,
    };
  }
}

class PollOption {
  final String id;
  final String text;
  final int votes;

  const PollOption({
    required this.id,
    required this.text,
    required this.votes,
  });

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      votes: (json['vote_count'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'vote_count': votes,
    };
  }
}

class PostPoll {
  final List<PollOption> options;
  final int totalVotes;
  final DateTime? endsAt;
  final bool isVotingClosed;
  final String? userVote;

  const PostPoll({
    required this.options,
    required this.totalVotes,
    this.endsAt,
    this.isVotingClosed = false,
    this.userVote,
  });

  factory PostPoll.fromJson(Map<String, dynamic> json) {
    return PostPoll(
      options: (json['options'] as List?)
              ?.map((option) => PollOption.fromJson(option))
              .toList() ??
          [],
      totalVotes: (json['total_vote_count'] ?? 0).toInt(),
      endsAt: json['voting_end_timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['voting_end_timestamp'] * 1000).toInt())
          : null,
      isVotingClosed: json['is_voting_closed'] ?? false,
      userVote: json['user_selection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'options': options.map((option) => option.toJson()).toList(),
      'total_vote_count': totalVotes,
      'voting_end_timestamp': endsAt?.millisecondsSinceEpoch,
      'is_voting_closed': isVotingClosed,
      'user_selection': userVote,
    };
  }
}

class RedditPost {
  final String id;
  final String title;
  final String? content;
  final String? url;
  final PostType type;
  final RedditUser author;
  final Subreddit subreddit;
  final DateTime createdAt;
  final int score;
  final int upvotes;
  final int downvotes;
  final int commentCount;
  final VoteStatus userVote;
  final bool isSaved;
  final bool isHidden;
  final bool isLocked;
  final bool isPinned;
  final bool isNsfw;
  final bool isSpoiler;
  final bool isArchived;
  final String? flair;
  final String? flairColor;
  final PostMedia? media;
  final List<PostMedia>? gallery;
  final PostPoll? poll;
  final List<String> awards;
  final String? thumbnailUrl;
  final String? domain;
  final Map<String, dynamic> metadata;

  const RedditPost({
    required this.id,
    required this.title,
    this.content,
    this.url,
    required this.type,
    required this.author,
    required this.subreddit,
    required this.createdAt,
    required this.score,
    this.upvotes = 0,
    this.downvotes = 0,
    required this.commentCount,
    this.userVote = VoteStatus.none,
    this.isSaved = false,
    this.isHidden = false,
    this.isLocked = false,
    this.isPinned = false,
    this.isNsfw = false,
    this.isSpoiler = false,
    this.isArchived = false,
    this.flair,
    this.flairColor,
    this.media,
    this.gallery,
    this.poll,
    this.awards = const [],
    this.thumbnailUrl,
    this.domain,
    this.metadata = const {},
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    return RedditPost(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      content: data['selftext']?.isNotEmpty == true ? data['selftext'] : null,
      url: data['url'],
      type: _determinePostType(data),
      author: RedditUser.fromJson(data['author'] ?? {}),
      subreddit: Subreddit.fromJson(data['subreddit'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        ((data['created_utc'] ?? 0) * 1000).toInt(),
      ),
      score: (data['score'] ?? 0).toInt(),
      upvotes: (data['ups'] ?? 0).toInt(),
      downvotes: (data['downs'] ?? 0).toInt(),
      commentCount: (data['num_comments'] ?? 0).toInt(),
      userVote: _parseVoteStatus(data['likes']),
      isSaved: data['saved'] ?? false,
      isHidden: data['hidden'] ?? false,
      isLocked: data['locked'] ?? false,
      isPinned: data['pinned'] ?? data['stickied'] ?? false,
      isNsfw: data['over_18'] ?? false,
      isSpoiler: data['spoiler'] ?? false,
      isArchived: data['archived'] ?? false,
      flair: data['link_flair_text'],
      flairColor: data['link_flair_background_color'],
      media: _parseMedia(data),
      gallery: _parseGallery(data),
      poll: data['poll_data'] != null ? PostPoll.fromJson(data['poll_data']) : null,
      awards: _parseAwards(data['all_awardings']),
      thumbnailUrl: _cleanThumbnail(data['thumbnail']),
      domain: data['domain'],
      metadata: data['metadata'] ?? {},
    );
  }

  static PostType _determinePostType(Map<String, dynamic> data) {
    if (data['poll_data'] != null) return PostType.poll;
    if (data['is_gallery'] == true) return PostType.gallery;
    if (data['is_video'] == true) return PostType.video;
    if (data['post_hint'] == 'image') return PostType.image;
    if (data['url'] != null && data['is_self'] != true) return PostType.link;
    return PostType.text;
  }

  static VoteStatus _parseVoteStatus(dynamic likes) {
    if (likes == true) return VoteStatus.upvoted;
    if (likes == false) return VoteStatus.downvoted;
    return VoteStatus.none;
  }

  static PostMedia? _parseMedia(Map<String, dynamic> data) {
    if (data['preview']?['images']?.isNotEmpty == true) {
      final image = data['preview']['images'][0];
      return PostMedia(
        imageUrl: image['source']?['url'],
        thumbnailUrl: image['resolutions']?.isNotEmpty == true
            ? image['resolutions'][0]['url']
            : null,
        width: image['source']?['width']?.toInt(),
        height: image['source']?['height']?.toInt(),
        isGif: data['url']?.toString().contains('.gif') ?? false,
      );
    }
    return null;
  }

  static List<PostMedia>? _parseGallery(Map<String, dynamic> data) {
    if (data['is_gallery'] != true) return null;
    
    final galleryData = data['gallery_data']?['items'] as List?;
    if (galleryData == null) return null;

    return galleryData.map((item) {
      return PostMedia(
        imageUrl: item['s']?['u'],
        width: item['s']?['x']?.toInt(),
        height: item['s']?['y']?.toInt(),
        caption: item['caption'],
      );
    }).toList();
  }

  static List<String> _parseAwards(dynamic awardings) {
    if (awardings is! List) return [];
    return awardings
        .map((award) => award['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .cast<String>()
        .toList();
  }

  static String? _cleanThumbnail(String? thumbnail) {
    if (thumbnail == null || 
        thumbnail == 'self' || 
        thumbnail == 'default' || 
        thumbnail == 'nsfw') {
      return null;
    }
    return thumbnail;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'selftext': content,
      'url': url,
      'type': type.name,
      'author': author.toJson(),
      'subreddit': subreddit.toJson(),
      'created_utc': createdAt.millisecondsSinceEpoch / 1000,
      'score': score,
      'ups': upvotes,
      'downs': downvotes,
      'num_comments': commentCount,
      'likes': userVote == VoteStatus.upvoted ? true : 
               userVote == VoteStatus.downvoted ? false : null,
      'saved': isSaved,
      'hidden': isHidden,
      'locked': isLocked,
      'pinned': isPinned,
      'over_18': isNsfw,
      'spoiler': isSpoiler,
      'archived': isArchived,
      'link_flair_text': flair,
      'link_flair_background_color': flairColor,
      'media': media?.toJson(),
      'gallery': gallery?.map((m) => m.toJson()).toList(),
      'poll_data': poll?.toJson(),
      'awards': awards,
      'thumbnail': thumbnailUrl,
      'domain': domain,
      'metadata': metadata,
    };
  }

  RedditPost copyWith({
    String? id,
    String? title,
    String? content,
    String? url,
    PostType? type,
    RedditUser? author,
    Subreddit? subreddit,
    DateTime? createdAt,
    int? score,
    int? upvotes,
    int? downvotes,
    int? commentCount,
    VoteStatus? userVote,
    bool? isSaved,
    bool? isHidden,
    bool? isLocked,
    bool? isPinned,
    bool? isNsfw,
    bool? isSpoiler,
    bool? isArchived,
    String? flair,
    String? flairColor,
    PostMedia? media,
    List<PostMedia>? gallery,
    PostPoll? poll,
    List<String>? awards,
    String? thumbnailUrl,
    String? domain,
    Map<String, dynamic>? metadata,
  }) {
    return RedditPost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      url: url ?? this.url,
      type: type ?? this.type,
      author: author ?? this.author,
      subreddit: subreddit ?? this.subreddit,
      createdAt: createdAt ?? this.createdAt,
      score: score ?? this.score,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      commentCount: commentCount ?? this.commentCount,
      userVote: userVote ?? this.userVote,
      isSaved: isSaved ?? this.isSaved,
      isHidden: isHidden ?? this.isHidden,
      isLocked: isLocked ?? this.isLocked,
      isPinned: isPinned ?? this.isPinned,
      isNsfw: isNsfw ?? this.isNsfw,
      isSpoiler: isSpoiler ?? this.isSpoiler,
      isArchived: isArchived ?? this.isArchived,
      flair: flair ?? this.flair,
      flairColor: flairColor ?? this.flairColor,
      media: media ?? this.media,
      gallery: gallery ?? this.gallery,
      poll: poll ?? this.poll,
      awards: awards ?? this.awards,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      domain: domain ?? this.domain,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedScore {
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

  bool get hasMedia => media != null || gallery != null;
  bool get hasText => content != null && content!.isNotEmpty;
  bool get isExternalLink => type == PostType.link && url != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RedditPost && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'RedditPost(id: $id, title: $title, score: $score)';
  }
}