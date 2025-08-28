import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/home_provider.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      context.read<HomeProvider>().switchTab(_tabController.index);
    }
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
        title: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppTheme.xBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.xBlue,
          labelColor: Theme.of(context).textTheme.bodyLarge?.color,
          unselectedLabelColor: AppTheme.xGray,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          if (homeProvider.isLoading && homeProvider.currentPosts.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (homeProvider.error != null && homeProvider.currentPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    homeProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => homeProvider.refreshPosts(),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => homeProvider.refreshPosts(),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: homeProvider.currentPosts.length +
                  (homeProvider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= homeProvider.currentPosts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final post = homeProvider.currentPosts[index];
                return PostCard(
                  post: post,
                  onLike: () => homeProvider.toggleLike(post.id),
                  onRepost: () => homeProvider.toggleRepost(post.id),
                  onBookmark: () => homeProvider.toggleBookmark(post.id),
                  onReply: () {
                    // TODO: Navigate to compose screen with reply
                  },
                  onShare: () {
                    // TODO: Implement share functionality
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}