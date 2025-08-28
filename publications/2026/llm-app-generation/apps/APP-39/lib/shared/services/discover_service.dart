import 'dart:math';
import '../models/discover_article.dart';

class DiscoverService {
  // Mock articles for demo
  static final List<DiscoverArticle> _mockArticles = [
    DiscoverArticle(
      id: '1',
      title: 'Flutter 3.16 Released with New Features and Performance Improvements',
      description: 'Google announces Flutter 3.16 with enhanced performance, new widgets, and improved developer experience. Learn about the latest updates and how they can benefit your app development.',
      url: 'https://flutter.dev/blog/flutter-3-16',
      imageUrl: 'https://via.placeholder.com/400x200?text=Flutter+3.16',
      source: 'Flutter Blog',
      sourceIcon: 'https://flutter.dev/favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      topics: ['Technology', 'Flutter', 'Mobile Development'],
      type: ArticleType.technology,
    ),
    DiscoverArticle(
      id: '2',
      title: 'AI Revolution: How Machine Learning is Transforming Industries',
      description: 'Explore the impact of artificial intelligence and machine learning across various industries. From healthcare to finance, discover how AI is reshaping the future.',
      url: 'https://example.com/ai-revolution',
      imageUrl: 'https://via.placeholder.com/400x200?text=AI+Revolution',
      source: 'Tech Today',
      sourceIcon: 'https://example.com/favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 4)),
      topics: ['Technology', 'AI', 'Machine Learning'],
      type: ArticleType.technology,
    ),
    DiscoverArticle(
      id: '3',
      title: 'Climate Change: Latest Research Shows Promising Solutions',
      description: 'Scientists unveil breakthrough technologies that could help combat climate change. New renewable energy solutions and carbon capture methods show promise.',
      url: 'https://example.com/climate-solutions',
      imageUrl: 'https://via.placeholder.com/400x200?text=Climate+Solutions',
      source: 'Science Daily',
      sourceIcon: 'https://example.com/science-favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      topics: ['Science', 'Climate', 'Environment'],
      type: ArticleType.science,
    ),
    DiscoverArticle(
      id: '4',
      title: 'NBA Finals: Exciting Matchup Expected This Season',
      description: 'Basketball fans gear up for an exciting NBA season with several teams showing championship potential. Analysis of top contenders and key players to watch.',
      url: 'https://example.com/nba-finals',
      imageUrl: 'https://via.placeholder.com/400x200?text=NBA+Finals',
      source: 'Sports Network',
      sourceIcon: 'https://example.com/sports-favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      topics: ['Sports', 'Basketball', 'NBA'],
      type: ArticleType.sports,
    ),
    DiscoverArticle(
      id: '5',
      title: 'New Study Reveals Benefits of Mediterranean Diet',
      description: 'Researchers find that Mediterranean diet can significantly reduce risk of heart disease and improve overall health. Learn about the key components and benefits.',
      url: 'https://example.com/mediterranean-diet',
      imageUrl: 'https://via.placeholder.com/400x200?text=Mediterranean+Diet',
      source: 'Health Magazine',
      sourceIcon: 'https://example.com/health-favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 12)),
      topics: ['Health', 'Nutrition', 'Diet'],
      type: ArticleType.health,
    ),
    DiscoverArticle(
      id: '6',
      title: 'Stock Market Reaches New Heights Amid Economic Recovery',
      description: 'Major stock indices hit record highs as economic indicators show strong recovery. Analysts discuss market trends and investment opportunities.',
      url: 'https://example.com/stock-market-highs',
      imageUrl: 'https://via.placeholder.com/400x200?text=Stock+Market',
      source: 'Financial Times',
      sourceIcon: 'https://example.com/finance-favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 16)),
      topics: ['Business', 'Finance', 'Stock Market'],
      type: ArticleType.business,
    ),
    DiscoverArticle(
      id: '7',
      title: 'Hollywood Blockbuster Breaks Box Office Records',
      description: 'The latest superhero movie shatters opening weekend records, earning over \$200 million globally. Behind-the-scenes look at the making of this epic film.',
      url: 'https://example.com/blockbuster-records',
      imageUrl: 'https://via.placeholder.com/400x200?text=Blockbuster+Movie',
      source: 'Entertainment Weekly',
      sourceIcon: 'https://example.com/entertainment-favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 20)),
      topics: ['Entertainment', 'Movies', 'Hollywood'],
      type: ArticleType.entertainment,
    ),
    DiscoverArticle(
      id: '8',
      title: 'Weather Alert: Severe Storms Expected This Weekend',
      description: 'Meteorologists warn of severe thunderstorms and potential flooding in several regions. Safety tips and preparation guidelines for residents.',
      url: 'https://example.com/weather-alert',
      imageUrl: 'https://via.placeholder.com/400x200?text=Weather+Alert',
      source: 'Weather Channel',
      sourceIcon: 'https://example.com/weather-favicon.ico',
      publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      topics: ['Weather', 'Safety', 'News'],
      type: ArticleType.weather,
    ),
  ];

  static final List<String> _allTopics = [
    'Technology', 'Science', 'Health', 'Sports', 'Business', 'Entertainment',
    'Weather', 'News', 'Politics', 'Travel', 'Food', 'Fashion', 'Art',
    'Music', 'Gaming', 'Education', 'Environment', 'Space', 'Medicine',
    'Finance', 'Cryptocurrency', 'AI', 'Machine Learning', 'Mobile Development',
    'Web Development', 'Flutter', 'React', 'JavaScript', 'Python',
  ];

  Future<List<DiscoverArticle>> getDiscoverFeed({
    int offset = 0,
    int limit = 20,
    List<String> interests = const [],
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 600));

    List<DiscoverArticle> articles = [..._mockArticles];

    // If user has interests, prioritize articles with matching topics
    if (interests.isNotEmpty) {
      articles.sort((a, b) {
        final aMatches = a.topics.where((topic) => interests.contains(topic)).length;
        final bMatches = b.topics.where((topic) => interests.contains(topic)).length;
        
        if (aMatches != bMatches) {
          return bMatches.compareTo(aMatches); // Higher matches first
        }
        
        return b.publishedAt.compareTo(a.publishedAt); // Then by recency
      });
    } else {
      // Sort by recency if no interests
      articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    }

    // Generate additional articles if needed
    if (articles.length < offset + limit) {
      articles.addAll(_generateAdditionalArticles(
        count: (offset + limit) - articles.length,
        interests: interests,
      ));
    }

    // Apply pagination
    final startIndex = offset;
    final endIndex = min(startIndex + limit, articles.length);
    
    if (startIndex >= articles.length) {
      return [];
    }

    return articles.sublist(startIndex, endIndex);
  }

  Future<void> toggleBookmark(String articleId, bool isBookmarked) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    // In a real app, this would update the bookmark status on the server
    // For demo purposes, we'll just simulate success
  }

  Future<void> markAsRead(String articleId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    // In a real app, this would mark the article as read on the server
  }

  Future<void> hideArticle(String articleId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 150));
    
    // In a real app, this would hide the article from the user's feed
  }

  Future<void> blockSource(String source) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 200));
    
    // In a real app, this would block articles from this source
  }

  Future<List<String>> getTrendingTopics() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return a shuffled list of trending topics
    final trending = [..._allTopics];
    trending.shuffle();
    return trending.take(10).toList();
  }

  Future<List<DiscoverArticle>> getArticlesByTopic(String topic) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Filter articles by topic
    final filteredArticles = _mockArticles
        .where((article) => article.topics.contains(topic))
        .toList();
    
    // Generate additional articles for this topic if needed
    if (filteredArticles.length < 10) {
      filteredArticles.addAll(_generateTopicArticles(topic, 10 - filteredArticles.length));
    }
    
    return filteredArticles;
  }

  List<DiscoverArticle> _generateAdditionalArticles({
    required int count,
    List<String> interests = const [],
  }) {
    final articles = <DiscoverArticle>[];
    final random = Random();
    
    final titles = [
      'Breaking: Major Development in Technology Sector',
      'Scientists Make Groundbreaking Discovery',
      'Market Analysis: What Investors Need to Know',
      'Health Tips: Expert Advice for Better Living',
      'Sports Update: Championship Results and Analysis',
      'Entertainment News: Celebrity Updates and Reviews',
      'Weather Forecast: What to Expect This Week',
      'Business Trends: Industry Insights and Predictions',
    ];
    
    final sources = [
      'Tech News', 'Science Today', 'Business Insider', 'Health Weekly',
      'Sports Central', 'Entertainment Now', 'Weather Pro', 'News Network',
    ];
    
    for (int i = 0; i < count; i++) {
      final title = titles[random.nextInt(titles.length)];
      final source = sources[random.nextInt(sources.length)];
      final topicCount = random.nextInt(3) + 1;
      final articleTopics = <String>[];
      
      // Add some user interests if available
      if (interests.isNotEmpty && random.nextBool()) {
        articleTopics.add(interests[random.nextInt(interests.length)]);
      }
      
      // Fill remaining topics randomly
      while (articleTopics.length < topicCount) {
        final topic = _allTopics[random.nextInt(_allTopics.length)];
        if (!articleTopics.contains(topic)) {
          articleTopics.add(topic);
        }
      }
      
      articles.add(DiscoverArticle(
        id: 'generated_${DateTime.now().millisecondsSinceEpoch}_$i',
        title: '$title ${i + 1}',
        description: 'This is a generated article about ${articleTopics.join(', ')}. It contains relevant information and insights about the topic.',
        url: 'https://example.com/article${i + 1}',
        imageUrl: 'https://via.placeholder.com/400x200?text=Article+${i + 1}',
        source: source,
        sourceIcon: 'https://example.com/favicon.ico',
        publishedAt: DateTime.now().subtract(Duration(hours: random.nextInt(48) + 1)),
        topics: articleTopics,
        type: ArticleType.values[random.nextInt(ArticleType.values.length)],
      ));
    }
    
    return articles;
  }

  List<DiscoverArticle> _generateTopicArticles(String topic, int count) {
    final articles = <DiscoverArticle>[];
    final random = Random();
    
    for (int i = 0; i < count; i++) {
      articles.add(DiscoverArticle(
        id: 'topic_${topic}_$i',
        title: '$topic: Latest Updates and Insights ${i + 1}',
        description: 'Comprehensive coverage of $topic with expert analysis and the latest developments in the field.',
        url: 'https://example.com/$topic/article${i + 1}',
        imageUrl: 'https://via.placeholder.com/400x200?text=$topic+${i + 1}',
        source: '$topic Weekly',
        sourceIcon: 'https://example.com/favicon.ico',
        publishedAt: DateTime.now().subtract(Duration(hours: random.nextInt(72) + 1)),
        topics: [topic],
        type: ArticleType.values[random.nextInt(ArticleType.values.length)],
      ));
    }
    
    return articles;
  }
}