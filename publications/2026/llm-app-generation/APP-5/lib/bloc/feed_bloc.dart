import 'package:bloc/bloc.dart';
import 'package:momentum_reddit/api/reddit_api_service.dart';
import 'package:momentum_reddit/bloc/feed_event.dart';
import 'package:momentum_reddit/bloc/feed_state.dart';
import 'package:momentum_reddit/models/post.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final RedditApiService redditApiService;

  FeedBloc({required this.redditApiService}) : super(FeedInitial()) {
    on<FetchPosts>(_onFetchPosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<FeedState> emit) async {
    final currentState = state;
    if (currentState is FeedLoaded && currentState.hasReachedMax) {
      return;
    }

    try {
      if (currentState is FeedInitial) {
        emit(FeedLoading());
        final posts = await redditApiService.fetchPosts();
        emit(FeedLoaded(posts: posts, hasReachedMax: false));
      } else if (currentState is FeedLoaded) {
        final lastPostId = currentState.posts.last.id;
        final posts = await redditApiService.fetchPosts(after: lastPostId);
        emit(
          posts.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : FeedLoaded(
                  posts: currentState.posts + posts,
                  hasReachedMax: false,
                ),
        );
      }
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }
}

extension on FeedLoaded {
  FeedLoaded copyWith({List<Post>? posts, bool? hasReachedMax}) {
    return FeedLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}
