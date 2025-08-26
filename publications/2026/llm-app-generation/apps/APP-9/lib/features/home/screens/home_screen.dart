import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/netflix_app_bar.dart';
import '../widgets/featured_content.dart';
import '../widgets/content_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarBackground = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showAppBarBackground) {
      setState(() {
        _showAppBarBackground = true;
      });
    } else if (_scrollController.offset <= 100 && _showAppBarBackground) {
      setState(() {
        _showAppBarBackground = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: NetflixAppBar(
        showBackground: _showAppBarBackground,
        actions: [
          IconButton(
            icon: const Icon(Icons.cast),
            onPressed: () {
              // TODO: Implement casting
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Featured Content
          const SliverToBoxAdapter(
            child: FeaturedContent(),
          ),
          
          // Content Carousels
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final rowTitle = AppConstants.homeRows[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                  child: ContentCarousel(
                    title: rowTitle,
                    contentList: _getMockContent(rowTitle),
                  ),
                );
              },
              childCount: AppConstants.homeRows.length,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockContent(String rowTitle) {
    // Mock content data - in a real app, this would come from an API
    return List.generate(10, (index) => {
      'id': '$rowTitle-$index',
      'title': 'Content ${index + 1}',
      'posterUrl': 'https://via.placeholder.com/300x450/333333/FFFFFF?text=Content+${index + 1}',
      'type': index % 2 == 0 ? 'movie' : 'series',
    });
  }
}