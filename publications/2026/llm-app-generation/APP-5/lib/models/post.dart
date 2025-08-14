import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post extends Equatable {
  final String id;
  final String title;
  final String author;
  final String subreddit;
  final int score;
  @JsonKey(name: 'num_comments')
  final int numComments;
  final String? thumbnail;
  @JsonKey(name: 'url_overridden_by_dest')
  final String? imageUrl;
  @JsonKey(name: 'is_video')
  final bool isVideo;
  final String selftext;

  const Post({
    required this.id,
    required this.title,
    required this.author,
    required this.subreddit,
    required this.score,
    required this.numComments,
    this.thumbnail,
    this.imageUrl,
    required this.isVideo,
    required this.selftext,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    subreddit,
    score,
    numComments,
    thumbnail,
    imageUrl,
    isVideo,
    selftext,
  ];
}
