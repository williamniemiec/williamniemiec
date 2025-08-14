import 'package:equatable/equatable.dart';
import 'package:momentum_reddit/models/post.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object> get props => [];
}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final bool hasReachedMax;

  const FeedLoaded({required this.posts, required this.hasReachedMax});

  @override
  List<Object> get props => [posts, hasReachedMax];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object> get props => [message];
}
