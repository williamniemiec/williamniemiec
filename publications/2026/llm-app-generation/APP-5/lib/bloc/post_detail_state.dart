import 'package:equatable/equatable.dart';
import 'package:momentum_reddit/models/comment.dart';
import 'package:momentum_reddit/models/post.dart';

abstract class PostDetailState extends Equatable {
  const PostDetailState();

  @override
  List<Object> get props => [];
}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailLoaded extends PostDetailState {
  final Post post;
  final List<Comment> comments;

  const PostDetailLoaded({required this.post, required this.comments});

  @override
  List<Object> get props => [post, comments];
}

class PostDetailError extends PostDetailState {
  final String message;

  const PostDetailError(this.message);

  @override
  List<Object> get props => [message];
}
