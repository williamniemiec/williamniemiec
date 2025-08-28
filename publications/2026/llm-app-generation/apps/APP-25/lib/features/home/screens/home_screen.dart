import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';
import '../providers/home_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/sort_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeProvider>().loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.reddit,
              color: AppTheme.redditOrange,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text('Reddit'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go(AppRoutes.discover),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => context.go(AppRoutes.profile),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          if (homeProvider.isLoading && homeProvider.posts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (homeProvider.error != null && homeProvider.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    homeProvider.error!,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  ElevatedButton(
                    onPressed: () => homeProvider.loadPosts(refresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => homeProvider.loadPosts(refresh: true),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Sort Selector
                SliverToBoxAdapter(
                  child: SortSelector(
                    currentSort: homeProvider.sortType,
                    onSortChanged: homeProvider.setSortType,
                  ),
                ),
                
                // Posts List
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < homeProvider.posts.length) {
                        final post = homeProvider.posts[index];
                        return PostCard(
                          post: post,
                          onVote: (voteStatus) => homeProvider.votePost(post.id, voteStatus),
                          onSave: () => homeProvider.savePost(post.id),
                          onTap: () => context.go('/post/${post.id}'),
                        );
                      } else if (homeProvider.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(AppConstants.defaultPadding),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (!homeProvider.hasMore) {
                        return Padding(
                          padding: const EdgeInsets.all(AppConstants.defaultPadding),
                          child: Center(
                            child: Text(
                              'You\'ve reached the end!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    childCount: homeProvider.posts.length + 1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}