import 'package:bloc/bloc.dart';
import 'package:momentum_reddit/api/reddit_api_service.dart';
import 'package:momentum_reddit/bloc/post_detail_event.dart';
import 'package:momentum_reddit/bloc/post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final RedditApiService redditApiService;

  PostDetailBloc({required this.redditApiService})
    : super(PostDetailInitial()) {
    on<FetchComments>(_onFetchComments);
  }

  Future<void> _onFetchComments(
    FetchComments event,
    Emitter<PostDetailState> emit,
  ) async {
    emit(PostDetailLoading());
    try {
      final result = await redditApiService.fetchComments(event.postId);
      emit(PostDetailLoaded(post: result[0], comments: result[1]));
    } catch (e) {
      emit(PostDetailError(e.toString()));
    }
  }
}
