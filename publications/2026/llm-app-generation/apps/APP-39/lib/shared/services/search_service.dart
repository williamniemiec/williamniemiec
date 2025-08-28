import 'dart:convert';
import 'dart:math';
import '../models/search_result.dart';

class SearchService {
  // Mock search results for demo
  static final List<SearchResult> _mockResults = [
    SearchResult(
      id: '1',
      title: 'Flutter - Build apps for any screen',
      url: 'https://flutter.dev',
      description: 'Flutter transforms the app development process. Build, test, and deploy beautiful mobile, web, desktop, and embedded apps from a single codebase.',
      favicon: 'https://flutter.dev/favicon.ico',
      timestamp: DateTime.now(),
      type: SearchResultType.web,
    ),
    SearchResult(
      id: '2',
      title: 'Google - Search the world\'s information',
      url: 'https://google.com',
      description: 'Search the world\'s information, including webpages, images, videos and more. Google has many special features to help you find exactly what you\'re looking for.',
      favicon: 'https://google.com/favicon.ico',
      timestamp: DateTime.now(),
      type: SearchResultType.web,
    ),
    SearchResult(
      id: '3',
      title: 'How to build a mobile app with Flutter',
      url: 'https://example.com/flutter-tutorial',
      description: 'Learn how to build beautiful mobile applications using Flutter framework. This comprehensive guide covers everything from setup to deployment.',
      favicon: 'https://example.com/favicon.ico',
      timestamp: DateTime.now(),
      type: SearchResultType.web,
    ),
    SearchResult(
      id: '4',
      title: 'Flutter Tutorial for Beginners',
      url: 'https://youtube.com/watch?v=example',
      description: 'A complete Flutter tutorial for beginners. Learn Dart programming and Flutter development from scratch.',
      thumbnail: 'https://via.placeholder.com/320x180',
      timestamp: DateTime.now(),
      type: SearchResultType.video,
    ),
    SearchResult(
      id: '5',
      title: 'Flutter News: Latest Updates and Features',
      url: 'https://news.example.com/flutter-updates',
      description: 'Stay updated with the latest Flutter news, updates, and new features announced by the Flutter team.',
      favicon: 'https://news.example.com/favicon.ico',
      timestamp: DateTime.now(),
      type: SearchResultType.news,
    ),
  ];

  static final List<String> _mockSuggestions = [
    'flutter tutorial',
    'flutter vs react native',
    'flutter web development',
    'flutter mobile app',
    'flutter installation',
    'flutter widgets',
    'flutter state management',
    'flutter firebase',
    'flutter animation',
    'flutter testing',
    'google search tips',
    'google lens features',
    'google assistant',
    'google maps api',
    'google cloud platform',
    'android development',
    'ios development',
    'mobile app design',
    'ui ux design',
    'programming languages',
  ];

  Future<List<SearchResult>> search(String query) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.trim().isEmpty) {
      return [];
    }

    // Filter mock results based on query
    final filteredResults = _mockResults.where((result) {
      final queryLower = query.toLowerCase();
      return result.title.toLowerCase().contains(queryLower) ||
             result.description.toLowerCase().contains(queryLower);
    }).toList();

    // If no filtered results, return some random results
    if (filteredResults.isEmpty) {
      final random = Random();
      final randomResults = <SearchResult>[];
      final shuffled = [..._mockResults]..shuffle(random);
      
      for (int i = 0; i < min(3, shuffled.length); i++) {
        randomResults.add(shuffled[i].copyWith(
          title: '${shuffled[i].title} - Related to "$query"',
          description: 'Search result related to your query: $query. ${shuffled[i].description}',
        ));
      }
      
      return randomResults;
    }

    return filteredResults;
  }

  Future<List<String>> getSuggestions(String query) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 200));

    if (query.trim().isEmpty) {
      return [];
    }

    final queryLower = query.toLowerCase();
    final suggestions = _mockSuggestions
        .where((suggestion) => suggestion.toLowerCase().contains(queryLower))
        .take(10)
        .toList();

    // If no matching suggestions, return some that start with the query
    if (suggestions.isEmpty) {
      return _mockSuggestions
          .where((suggestion) => suggestion.toLowerCase().startsWith(queryLower))
          .take(5)
          .toList();
    }

    return suggestions;
  }

  Future<List<SearchResult>> getImageResults(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock image results
    final imageResults = <SearchResult>[];
    for (int i = 1; i <= 20; i++) {
      imageResults.add(SearchResult(
        id: 'img_$i',
        title: '$query - Image $i',
        url: 'https://example.com/image$i.jpg',
        description: 'High quality image related to $query',
        thumbnail: 'https://via.placeholder.com/300x200?text=Image+$i',
        timestamp: DateTime.now(),
        type: SearchResultType.image,
      ));
    }

    return imageResults;
  }

  Future<List<SearchResult>> getVideoResults(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Generate mock video results
    final videoResults = <SearchResult>[];
    for (int i = 1; i <= 10; i++) {
      videoResults.add(SearchResult(
        id: 'vid_$i',
        title: '$query - Video Tutorial $i',
        url: 'https://youtube.com/watch?v=example$i',
        description: 'Learn about $query in this comprehensive video tutorial',
        thumbnail: 'https://via.placeholder.com/320x180?text=Video+$i',
        timestamp: DateTime.now(),
        type: SearchResultType.video,
      ));
    }

    return videoResults;
  }

  Future<List<SearchResult>> getNewsResults(String query) async {
    await Future.delayed(const Duration(milliseconds: 350));

    // Generate mock news results
    final newsResults = <SearchResult>[];
    final sources = ['TechCrunch', 'The Verge', 'Wired', 'Ars Technica', 'Engadget'];
    
    for (int i = 1; i <= 15; i++) {
      final source = sources[i % sources.length];
      newsResults.add(SearchResult(
        id: 'news_$i',
        title: 'Breaking: $query Makes Headlines - Latest Updates',
        url: 'https://${source.toLowerCase().replaceAll(' ', '')}.com/article$i',
        description: 'Latest news and updates about $query from $source. Stay informed with the most recent developments.',
        favicon: 'https://${source.toLowerCase().replaceAll(' ', '')}.com/favicon.ico',
        timestamp: DateTime.now().subtract(Duration(hours: i)),
        type: SearchResultType.news,
      ));
    }

    return newsResults;
  }

  Future<List<SearchResult>> getShoppingResults(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock shopping results
    final shoppingResults = <SearchResult>[];
    final stores = ['Amazon', 'eBay', 'Best Buy', 'Target', 'Walmart'];
    
    for (int i = 1; i <= 12; i++) {
      final store = stores[i % stores.length];
      final price = (Random().nextDouble() * 500 + 10).toStringAsFixed(2);
      
      shoppingResults.add(SearchResult(
        id: 'shop_$i',
        title: '$query - Premium Quality \$$price',
        url: 'https://${store.toLowerCase().replaceAll(' ', '')}.com/product$i',
        description: 'Buy $query from $store. High quality product with fast shipping and great customer reviews.',
        thumbnail: 'https://via.placeholder.com/200x200?text=Product+$i',
        timestamp: DateTime.now(),
        type: SearchResultType.shopping,
      ));
    }

    return shoppingResults;
  }

  Future<String?> getAIOverview(String query) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock AI overview responses
    final overviews = {
      'flutter': 'Flutter is an open-source UI software development kit created by Google. It is used to develop cross-platform applications for Android, iOS, Linux, macOS, Windows, Google Fuchsia, and the web from a single codebase. Flutter uses the Dart programming language and provides a rich set of pre-designed widgets.',
      'google': 'Google LLC is an American multinational technology company that specializes in Internet-related services and products. Founded in 1998 by Larry Page and Sergey Brin, Google is best known for its search engine, which processes over 8.5 billion searches per day.',
      'programming': 'Programming is the process of creating a set of instructions that tell a computer how to perform a task. It involves writing code in various programming languages like Python, Java, JavaScript, C++, and many others. Programming is essential for software development, web development, mobile app creation, and automation.',
    };

    // Find matching overview
    final queryLower = query.toLowerCase();
    for (final key in overviews.keys) {
      if (queryLower.contains(key)) {
        return overviews[key];
      }
    }

    // Default AI overview
    return 'Based on current information, $query refers to a topic that encompasses various aspects and applications. Here\'s what you should know: This is a comprehensive subject with multiple facets that can be explored through various resources and perspectives.';
  }
}