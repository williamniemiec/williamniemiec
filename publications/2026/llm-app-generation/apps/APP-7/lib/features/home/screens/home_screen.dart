import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/post.dart';
import '../widgets/post_card.dart';
import '../widgets/feed_filter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  FeedFilter _currentFilter = FeedFilter.all;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParentSquare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Feed Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FeedFilterWidget(
              currentFilter: _currentFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _currentFilter = filter;
                });
              },
            ),
          ),
          // Feed Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshFeed,
              child: _buildFeedContent(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create post
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFeedContent() {
    // Mock data for now
    final posts = _getMockPosts();
    
    if (posts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(
          post: posts[index],
          onAppreciate: (postId) => _handleAppreciate(postId),
          onComment: (postId) => _handleComment(postId),
          onShare: (postId) => _handleShare(postId),
          onTap: () => _handlePostTap(posts[index].id),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.feed_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No posts yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for updates from your school',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _refreshFeed() async {
    // TODO: Implement feed refresh
    await Future.delayed(const Duration(seconds: 1));
  }

  void _handleAppreciate(String postId) {
    // TODO: Implement appreciate functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post appreciated!')),
    );
  }

  void _handleComment(String postId) {
    // TODO: Navigate to post detail with comment focus
  }

  void _handleShare(String postId) {
    // TODO: Implement share functionality
  }

  void _handlePostTap(String postId) {
    // TODO: Navigate to post detail
  }

  List<Post> _getMockPosts() {
    return [
      Post(
        id: '1',
        authorId: 'teacher1',
        authorName: 'Ms. Johnson',
        authorRole: 'Teacher',
        title: 'Welcome Back to School!',
        content: 'We\'re excited to start the new school year. Please remember to bring your supplies on the first day.',
        type: PostType.announcement,
        audience: PostAudience.classroom,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        appreciationCount: 12,
        commentCount: 3,
      ),
      Post(
        id: '2',
        authorId: 'principal1',
        authorName: 'Dr. Smith',
        authorRole: 'Principal',
        title: 'School Closure Alert',
        content: 'Due to inclement weather, school will be closed tomorrow. All after-school activities are cancelled.',
        type: PostType.alert,
        audience: PostAudience.school,
        isUrgent: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 4)),
        appreciationCount: 45,
        commentCount: 8,
      ),
      Post(
        id: '3',
        authorId: 'teacher2',
        authorName: 'Mr. Davis',
        authorRole: 'PE Teacher',
        title: 'Field Day Volunteers Needed',
        content: 'We need parent volunteers for our upcoming field day event. Please sign up if you can help!',
        type: PostType.signUp,
        audience: PostAudience.grade,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        appreciationCount: 8,
        commentCount: 15,
      ),
    ];
  }
}