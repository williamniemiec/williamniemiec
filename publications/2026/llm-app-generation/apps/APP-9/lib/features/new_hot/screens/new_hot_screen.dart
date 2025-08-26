import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class NewHotScreen extends StatefulWidget {
  const NewHotScreen({super.key});

  @override
  State<NewHotScreen> createState() => _NewHotScreenState();
}

class _NewHotScreenState extends State<NewHotScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.newAndHot,
          style: TextStyle(
            color: AppTheme.netflixWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.netflixBlack,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.netflixRed,
          labelColor: AppTheme.netflixWhite,
          unselectedLabelColor: AppTheme.netflixLightGray,
          tabs: const [
            Tab(text: '🍿 Coming Soon'),
            Tab(text: '🔥 Everyone\'s Watching'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComingSoonTab(),
          _buildEveryonesWatchingTab(),
        ],
      ),
    );
  }

  Widget _buildComingSoonTab() {
    final comingSoonContent = _getMockComingSoonContent();
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: comingSoonContent.length,
      itemBuilder: (context, index) {
        final content = comingSoonContent[index];
        return _buildComingSoonCard(content);
      },
    );
  }

  Widget _buildEveryonesWatchingTab() {
    final trendingContent = _getMockTrendingContent();
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: trendingContent.length,
      itemBuilder: (context, index) {
        final content = trendingContent[index];
        return _buildTrendingCard(content, index + 1);
      },
    );
  }

  Widget _buildComingSoonCard(Map<String, dynamic> content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Release Date
          Row(
            children: [
              Container(
                width: 60,
                child: Column(
                  children: [
                    Text(
                      content['month'] ?? 'JAN',
                      style: const TextStyle(
                        color: AppTheme.netflixLightGray,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      content['day'] ?? '01',
                      style: const TextStyle(
                        color: AppTheme.netflixWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Backdrop Image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppTheme.netflixDarkGray,
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(content['backdropUrl'] ?? ''),
                          fit: BoxFit.cover,
                          onError: (error, stackTrace) {},
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Play button overlay
                          Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: AppTheme.netflixWhite,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Title and Actions
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            content['title'] ?? 'Unknown Title',
                            style: const TextStyle(
                              color: AppTheme.netflixWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Set reminder
                          },
                          icon: const Icon(
                            Icons.notifications_none,
                            color: AppTheme.netflixWhite,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Show info
                          },
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppTheme.netflixWhite,
                          ),
                        ),
                      ],
                    ),
                    
                    // Description
                    Text(
                      content['description'] ?? 'No description available.',
                      style: const TextStyle(
                        color: AppTheme.netflixLightGray,
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Genres
                    Text(
                      content['genres']?.join(' • ') ?? 'Drama • Thriller',
                      style: const TextStyle(
                        color: AppTheme.netflixLightGray,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingCard(Map<String, dynamic> content, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Rank Number
          SizedBox(
            width: 40,
            child: Text(
              '$rank',
              style: const TextStyle(
                color: AppTheme.netflixWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Content Poster
          Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.netflixDarkGray,
              borderRadius: BorderRadius.circular(4),
              image: DecorationImage(
                image: NetworkImage(content['backdropUrl'] ?? ''),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {},
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Content Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content['title'] ?? 'Unknown Title',
                  style: const TextStyle(
                    color: AppTheme.netflixWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content['description'] ?? 'No description available.',
                  style: const TextStyle(
                    color: AppTheme.netflixLightGray,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          // Action Button
          IconButton(
            onPressed: () {
              // TODO: Play content
            },
            icon: const Icon(
              Icons.play_circle_outline,
              color: AppTheme.netflixWhite,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockComingSoonContent() {
    return [
      {
        'id': 'coming-1',
        'title': 'The Crown Season 6',
        'month': 'DEC',
        'day': '14',
        'backdropUrl': 'https://via.placeholder.com/400x225/333333/FFFFFF?text=The+Crown',
        'description': 'The final season of the acclaimed series about the British Royal Family.',
        'genres': ['Drama', 'Biography', 'History'],
      },
      {
        'id': 'coming-2',
        'title': 'Stranger Things 5',
        'month': 'JAN',
        'day': '15',
        'backdropUrl': 'https://via.placeholder.com/400x225/333333/FFFFFF?text=Stranger+Things',
        'description': 'The epic conclusion to the supernatural saga in Hawkins.',
        'genres': ['Sci-Fi', 'Horror', 'Drama'],
      },
    ];
  }

  List<Map<String, dynamic>> _getMockTrendingContent() {
    return [
      {
        'id': 'trending-1',
        'title': 'Wednesday',
        'backdropUrl': 'https://via.placeholder.com/400x225/333333/FFFFFF?text=Wednesday',
        'description': 'A supernatural mystery comedy horror series following Wednesday Addams.',
      },
      {
        'id': 'trending-2',
        'title': 'Squid Game',
        'backdropUrl': 'https://via.placeholder.com/400x225/333333/FFFFFF?text=Squid+Game',
        'description': 'Players compete in childhood games with deadly consequences.',
      },
      {
        'id': 'trending-3',
        'title': 'The Witcher',
        'backdropUrl': 'https://via.placeholder.com/400x225/333333/FFFFFF?text=The+Witcher',
        'description': 'Geralt of Rivia, a solitary monster hunter, struggles to find his place.',
      },
    ];
  }
}