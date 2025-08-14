import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momentum_reddit/api/reddit_api_service.dart';
import 'package:momentum_reddit/bloc/post_detail_bloc.dart';
import 'package:momentum_reddit/bloc/post_detail_event.dart';
import 'package:momentum_reddit/bloc/post_detail_state.dart';
import 'package:momentum_reddit/models/post.dart';
import 'package:momentum_reddit/widgets/comment_widget.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostDetailBloc(redditApiService: RedditApiService())
            ..add(FetchComments(post.id)),
      child: Scaffold(
        appBar: AppBar(title: Text(post.title)),
        body: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            if (state is PostDetailInitial || state is PostDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostDetailLoaded) {
              return ListView.builder(
                itemCount: state.comments.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildPostContent(context, state.post);
                  }
                  final comment = state.comments[index - 1];
                  return CommentWidget(comment: comment);
                },
              );
            } else if (state is PostDetailError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Something went wrong.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildPostContent(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8.0),
          Text(
            'r/${post.subreddit} • u/${post.author}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16.0),
          if (post.selftext.isNotEmpty)
            Text(post.selftext, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
