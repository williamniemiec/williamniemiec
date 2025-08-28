import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/thread.dart';
import '../models/user.dart';
import '../../core/constants/app_constants.dart';

class ThreadService {
  static const String _baseUrl = AppConstants.baseUrl;
  
  // Mock data for demo purposes
  final List<Thread> _mockThreads = [];
  final Random _random = Random();

  ThreadService() {
    _initializeMockData();
  }

  void _initializeMockData() {
    // Create some mock users
    final users = [
      User.create(
        username: 'alice_dev',
        displayName: 'Alice Johnson',
        bio: 'Software developer passionate about Flutter',
        profileImageUrl: 'https://via.placeholder.com/150/FF6B6B/FFFFFF?text=AJ',
      ),
      User.create(
        username: 'bob_designer',
        displayName: 'Bob Smith',
        bio: 'UI/UX Designer creating beautiful experiences',
        profileImageUrl: 'https://via.placeholder.com/150/4ECDC4/FFFFFF?text=BS',
      ),
      User.create(
        username: 'carol_pm',
        displayName: 'Carol Williams',
        bio: 'Product Manager at a tech startup',
        profileImageUrl: 'https://via.placeholder.com/150/45B7D1/FFFFFF?text=CW',
      ),
      User.create(
        username: 'david_writer',
        displayName: 'David Brown',
        bio: 'Technical writer and documentation enthusiast',
        profileImageUrl: 'https://via.placeholder.com/150/96CEB4/FFFFFF?text=DB',
      ),
      User.create(
        username: 'emma_data',
        displayName: 'Emma Davis',
        bio: 'Data scientist exploring AI and ML',
        profileImageUrl: 'https://via.placeholder.com/150/FFEAA7/FFFFFF?text=ED',
      ),
    ];

    // Create mock threads
    final threadContents = [
      'Just shipped a new feature! The feeling of seeing your code in production never gets old 🚀',
      'Working on a new design system. The attention to detail in spacing and typography makes all the difference.',
      'Had an amazing product discovery session today. Understanding user needs is the foundation of great products.',
      'Documentation is code. If it\'s not documented, it doesn\'t exist. Period.',
      'Machine learning models are only as good as the data they\'re trained on. Garbage in, garbage out.',
      'Flutter\'s hot reload is a game changer for mobile development. The productivity boost is incredible.',
      'User research revealed some surprising insights today. Always validate your assumptions!',
      'Clean code is not written by following a set of rules. Clean code is written by someone who cares.',
      'The best user interfaces are invisible. When design works, users don\'t notice it.',
      'Data visualization is storytelling with numbers. Make your data tell a compelling story.',
      'Debugging is like being a detective in a crime movie where you are also the murderer.',
      'Good design is obvious. Great design is transparent.',
      'The most important skill in product management is learning to say no.',
      'Code reviews are not about finding bugs. They\'re about sharing knowledge and improving together.',
      'AI will not replace humans, but humans with AI will replace humans without AI.',
    ];

    for (int i = 0; i < 15; i++) {
      final user = users[i % users.length];
      final content = threadContents[i];
      final createdAt = DateTime.now().subtract(Duration(hours: i * 2));
      
      final thread = Thread(
        id: 'thread_$i',
        content: content,
        author: user,
        likesCount: _random.nextInt(100),
        repliesCount: _random.nextInt(20),
        repostsCount: _random.nextInt(30),
        quotesCount: _random.nextInt(10),
        isLiked: _random.nextBool(),
        isReposted: _random.nextBool(),
        createdAt: createdAt,
      );
      
      _mockThreads.add(thread);
    }
  }

  Future<List<Thread>> getForYouFeed({int offset = 0, int limit = 20}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Return paginated mock data
      final endIndex = (offset + limit).clamp(0, _mockThreads.length);
      if (offset >= _mockThreads.length) return [];
      
      return _mockThreads.sublist(offset, endIndex);
    } catch (e) {
      throw Exception('Failed to load for you feed: $e');
    }
  }

  Future<List<Thread>> getFollowingFeed({int offset = 0, int limit = 20}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      // For demo, return a subset of threads (simulating following feed)
      final followingThreads = _mockThreads.where((t) => 
        t.author.username.contains('alice') || 
        t.author.username.contains('bob')
      ).toList();
      
      final endIndex = (offset + limit).clamp(0, followingThreads.length);
      if (offset >= followingThreads.length) return [];
      
      return followingThreads.sublist(offset, endIndex);
    } catch (e) {
      throw Exception('Failed to load following feed: $e');
    }
  }

  Future<Thread> createThread({
    required String content,
    required User author,
    List<MediaAttachment> attachments = const [],
    String? parentThreadId,
    String? quotedThreadId,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      final thread = Thread.create(
        content: content,
        author: author,
        attachments: attachments,
        parentThreadId: parentThreadId,
        quotedThreadId: quotedThreadId,
      );
      
      // Add to mock data
      _mockThreads.insert(0, thread);
      
      return thread;
    } catch (e) {
      throw Exception('Failed to create thread: $e');
    }
  }

  Future<Thread?> getThread(String threadId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      return _mockThreads.firstWhere(
        (t) => t.id == threadId,
        orElse: () => throw Exception('Thread not found'),
      );
    } catch (e) {
      throw Exception('Failed to get thread: $e');
    }
  }

  Future<List<Thread>> getThreadReplies(String threadId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // For demo, return some mock replies
      final replies = _mockThreads.where((t) => 
        t.parentThreadId == threadId
      ).toList();
      
      return replies;
    } catch (e) {
      throw Exception('Failed to get thread replies: $e');
    }
  }

  Future<bool> toggleLike(String threadId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));
      
      final threadIndex = _mockThreads.indexWhere((t) => t.id == threadId);
      if (threadIndex == -1) throw Exception('Thread not found');
      
      final thread = _mockThreads[threadIndex];
      final newIsLiked = !thread.isLiked;
      final newLikesCount = newIsLiked 
        ? thread.likesCount + 1 
        : thread.likesCount - 1;
      
      _mockThreads[threadIndex] = thread.copyWith(
        isLiked: newIsLiked,
        likesCount: newLikesCount,
      );
      
      return newIsLiked;
    } catch (e) {
      throw Exception('Failed to toggle like: $e');
    }
  }

  Future<bool> toggleRepost(String threadId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));
      
      final threadIndex = _mockThreads.indexWhere((t) => t.id == threadId);
      if (threadIndex == -1) throw Exception('Thread not found');
      
      final thread = _mockThreads[threadIndex];
      final newIsReposted = !thread.isReposted;
      final newRepostsCount = newIsReposted 
        ? thread.repostsCount + 1 
        : thread.repostsCount - 1;
      
      _mockThreads[threadIndex] = thread.copyWith(
        isReposted: newIsReposted,
        repostsCount: newRepostsCount,
      );
      
      return newIsReposted;
    } catch (e) {
      throw Exception('Failed to toggle repost: $e');
    }
  }

  Future<Thread> replyToThread({
    required String parentThreadId,
    required String content,
    required User author,
    List<MediaAttachment> attachments = const [],
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      final parentThread = await getThread(parentThreadId);
      if (parentThread == null) throw Exception('Parent thread not found');
      
      final reply = Thread.create(
        content: content,
        author: author,
        attachments: attachments,
        type: ThreadType.reply,
        parentThreadId: parentThreadId,
        parentThread: parentThread,
      );
      
      // Add to mock data
      _mockThreads.insert(0, reply);
      
      // Update parent thread reply count
      final parentIndex = _mockThreads.indexWhere((t) => t.id == parentThreadId);
      if (parentIndex != -1) {
        _mockThreads[parentIndex] = _mockThreads[parentIndex].copyWith(
          repliesCount: _mockThreads[parentIndex].repliesCount + 1,
        );
      }
      
      return reply;
    } catch (e) {
      throw Exception('Failed to reply to thread: $e');
    }
  }

  Future<Thread> quoteThread({
    required String quotedThreadId,
    required String content,
    required User author,
    List<MediaAttachment> attachments = const [],
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      final quotedThread = await getThread(quotedThreadId);
      if (quotedThread == null) throw Exception('Quoted thread not found');
      
      final quote = Thread.create(
        content: content,
        author: author,
        attachments: attachments,
        type: ThreadType.quote,
        quotedThreadId: quotedThreadId,
        quotedThread: quotedThread,
      );
      
      // Add to mock data
      _mockThreads.insert(0, quote);
      
      // Update quoted thread quote count
      final quotedIndex = _mockThreads.indexWhere((t) => t.id == quotedThreadId);
      if (quotedIndex != -1) {
        _mockThreads[quotedIndex] = _mockThreads[quotedIndex].copyWith(
          quotesCount: _mockThreads[quotedIndex].quotesCount + 1,
        );
      }
      
      return quote;
    } catch (e) {
      throw Exception('Failed to quote thread: $e');
    }
  }

  Future<List<Thread>> searchThreads(String query) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      if (query.isEmpty) return [];
      
      // Simple text search in mock data
      final results = _mockThreads.where((thread) =>
        thread.content.toLowerCase().contains(query.toLowerCase()) ||
        thread.author.displayName.toLowerCase().contains(query.toLowerCase()) ||
        thread.author.username.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      return results;
    } catch (e) {
      throw Exception('Failed to search threads: $e');
    }
  }

  Future<List<Thread>> getUserThreads(String userId, {int offset = 0, int limit = 20}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      final userThreads = _mockThreads.where((t) => t.author.id == userId).toList();
      
      final endIndex = (offset + limit).clamp(0, userThreads.length);
      if (offset >= userThreads.length) return [];
      
      return userThreads.sublist(offset, endIndex);
    } catch (e) {
      throw Exception('Failed to get user threads: $e');
    }
  }

  Future<void> deleteThread(String threadId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      _mockThreads.removeWhere((t) => t.id == threadId);
    } catch (e) {
      throw Exception('Failed to delete thread: $e');
    }
  }

  // Helper method to make authenticated requests
  Future<http.Response> _makeAuthenticatedRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_getAuthToken()}',
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(url, headers: headers);
      case 'POST':
        return await http.post(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'PUT':
        return await http.put(
          url,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'DELETE':
        return await http.delete(url, headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  String? _getAuthToken() {
    // In a real app, this would return the stored auth token
    return 'mock_token';
  }
}