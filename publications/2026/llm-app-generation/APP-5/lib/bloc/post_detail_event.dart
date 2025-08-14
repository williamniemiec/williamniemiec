import 'package:equatable/equatable.dart';

abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchComments extends PostDetailEvent {
  final String postId;

  const FetchComments(this.postId);

  @override
  List<Object> get props => [postId];
}
