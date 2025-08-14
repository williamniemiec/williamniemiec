import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momentum_reddit/api/reddit_api_service.dart';
import 'package:momentum_reddit/bloc/feed_bloc.dart';
import 'package:momentum_reddit/bloc/feed_event.dart';
import 'package:momentum_reddit/bloc/feed_state.dart';
import 'package:momentum_reddit/services/cache_service.dart';
import 'package:momentum_reddit/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FeedBloc(redditApiService: RedditApiService())..add(FetchPosts()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Momentum for Reddit')),
        body: BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FeedLoaded) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (context, index) {
                  return index >= state.posts.length
                      ? const Center(child: CircularProgressIndicator())
                      : PostCard(post: state.posts[index]);
                },
              );
            } else if (state is FeedError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<FeedBloc>().add(FetchPosts());
    }

    final state = context.read<FeedBloc>().state;
    if (state is FeedLoaded) {
      final posts = state.posts;
      final currentScroll = _scrollController.offset;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final preloadIndex =
          (currentScroll / (maxScroll / posts.length)).floor() + 5;

      if (preloadIndex < posts.length) {
        final postToPreload = posts[preloadIndex];
        if (postToPreload.imageUrl != null) {
          CacheService().prefetchImage(postToPreload.imageUrl!);
        }
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
