import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment extends Equatable {
  final String id;
  final String author;
  final String body;
  final int score;
  final int depth;

  const Comment({
    required this.id,
    required this.author,
    required this.body,
    required this.score,
    required this.depth,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  @override
  List<Object?> get props => [id, author, body, score, depth];
}
