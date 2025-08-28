import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';
import '../models/models.dart';

class ApiService {
  late final Dio _dio;
  static final ApiService _instance = ApiService._internal();
  
  factory ApiService() => _instance;
  
  ApiService._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.requestTimeout,
      receiveTimeout: AppConstants.requestTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    _setupInterceptors();
  }
  
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          final token = _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          if (kDebugMode) {
            debugPrint('REQUEST: ${options.method} ${options.path}');
            debugPrint('HEADERS: ${options.headers}');
            debugPrint('DATA: ${options.data}');
          }
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
            debugPrint('DATA: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint('ERROR: ${error.message}');
            debugPrint('RESPONSE: ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );
  }
  
  String? _getAuthToken() {
    // In a real app, get token from secure storage
    return null;
  }
  
  // Auth endpoints
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      return ApiResponse.success(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<User>> register({
    required String email,
    required String password,
    required String username,
    required String displayName,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'username': username,
        'displayName': displayName,
      });
      
      return ApiResponse.success(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<void>> logout() async {
    try {
      await _dio.post('/auth/logout');
      return ApiResponse.success(null);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  // Posts endpoints
  Future<ApiResponse<List<Post>>> getPosts({
    int page = 1,
    int limit = 20,
    String? userId,
    String? type,
  }) async {
    try {
      final response = await _dio.get('/posts', queryParameters: {
        'page': page,
        'limit': limit,
        if (userId != null) 'userId': userId,
        if (type != null) 'type': type,
      });
      
      final posts = (response.data['posts'] as List)
          .map((json) => Post.fromJson(json))
          .toList();
      
      return ApiResponse.success(posts);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<Post>> createPost({
    required String content,
    List<String>? mediaUrls,
    String? replyToId,
    String? quoteId,
    Poll? poll,
  }) async {
    try {
      final response = await _dio.post('/posts', data: {
        'content': content,
        if (mediaUrls != null) 'mediaUrls': mediaUrls,
        if (replyToId != null) 'replyToId': replyToId,
        if (quoteId != null) 'quoteId': quoteId,
        if (poll != null) 'poll': poll.toJson(),
      });
      
      return ApiResponse.success(Post.fromJson(response.data['post']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<Post>> likePost(String postId) async {
    try {
      final response = await _dio.post('/posts/$postId/like');
      return ApiResponse.success(Post.fromJson(response.data['post']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<Post>> repost(String postId, {String? comment}) async {
    try {
      final response = await _dio.post('/posts/$postId/repost', data: {
        if (comment != null) 'comment': comment,
      });
      return ApiResponse.success(Post.fromJson(response.data['post']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  // Users endpoints
  Future<ApiResponse<User>> getUser(String username) async {
    try {
      final response = await _dio.get('/users/$username');
      return ApiResponse.success(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<User>> followUser(String userId) async {
    try {
      final response = await _dio.post('/users/$userId/follow');
      return ApiResponse.success(User.fromJson(response.data['user']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  // Search endpoints
  Future<ApiResponse<SearchResults>> search(String query, {
    String? type,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/search', queryParameters: {
        'q': query,
        if (type != null) 'type': type,
        'page': page,
        'limit': limit,
      });
      
      return ApiResponse.success(SearchResults.fromJson(response.data));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  // Trends endpoints
  Future<ApiResponse<List<Trend>>> getTrends({String? location}) async {
    try {
      final response = await _dio.get('/trends', queryParameters: {
        if (location != null) 'location': location,
      });
      
      final trends = (response.data['trends'] as List)
          .map((json) => Trend.fromJson(json))
          .toList();
      
      return ApiResponse.success(trends);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  // Messages endpoints
  Future<ApiResponse<List<Conversation>>> getConversations() async {
    try {
      final response = await _dio.get('/conversations');
      
      final conversations = (response.data['conversations'] as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
      
      return ApiResponse.success(conversations);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<List<Message>>> getMessages(String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get('/conversations/$conversationId/messages', 
        queryParameters: {
          'page': page,
          'limit': limit,
        });
      
      final messages = (response.data['messages'] as List)
          .map((json) => Message.fromJson(json))
          .toList();
      
      return ApiResponse.success(messages);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  Future<ApiResponse<Message>> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    List<String>? mediaUrls,
  }) async {
    try {
      final response = await _dio.post('/conversations/$conversationId/messages', 
        data: {
          'content': content,
          'type': type.name,
          if (mediaUrls != null) 'mediaUrls': mediaUrls,
        });
      
      return ApiResponse.success(Message.fromJson(response.data['message']));
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    }
  }
  
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error';
        return 'Server error ($statusCode): $message';
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.unknown:
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unexpected error occurred';
    }
  }
}

// Generic API response wrapper
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  ApiResponse.success(this.data) : error = null, isSuccess = true;
  ApiResponse.error(this.error) : data = null, isSuccess = false;
}

// Search results model
class SearchResults {
  final List<Post> posts;
  final List<User> users;
  final List<Trend> trends;
  final int totalCount;
  
  SearchResults({
    required this.posts,
    required this.users,
    required this.trends,
    required this.totalCount,
  });
  
  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      posts: (json['posts'] as List? ?? [])
          .map((p) => Post.fromJson(p))
          .toList(),
      users: (json['users'] as List? ?? [])
          .map((u) => User.fromJson(u))
          .toList(),
      trends: (json['trends'] as List? ?? [])
          .map((t) => Trend.fromJson(t))
          .toList(),
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}