import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/pin.dart';
import '../models/board.dart';
import '../models/user.dart';
import '../models/comment.dart';
import '../models/message.dart';
import '../models/search.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://api.pinterest.com/v1';
  late final Dio _dio;
  String? _accessToken;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  void setAccessToken(String token) {
    _accessToken = token;
  }

  // Auth endpoints
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.data['token'] != null) {
        setAccessToken(response.data['token']);
      }
      
      return User.fromJson(response.data['user']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> register(String email, String password, String username, String displayName) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'username': username,
        'displayName': displayName,
      });
      
      if (response.data['token'] != null) {
        setAccessToken(response.data['token']);
      }
      
      return User.fromJson(response.data['user']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Pin endpoints
  Future<List<Pin>> getHomeFeed({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/pins/feed', queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      return (response.data['pins'] as List)
          .map((json) => Pin.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pin> getPin(String pinId) async {
    try {
      final response = await _dio.get('/pins/$pinId');
      return Pin.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pin> createPin({
    required String title,
    String? description,
    required String imageUrl,
    String? sourceUrl,
    required String boardId,
    List<String>? tags,
  }) async {
    try {
      final response = await _dio.post('/pins', data: {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'sourceUrl': sourceUrl,
        'boardId': boardId,
        'tags': tags,
      });
      
      return Pin.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePin(String pinId) async {
    try {
      await _dio.delete('/pins/$pinId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pin> likePin(String pinId) async {
    try {
      final response = await _dio.post('/pins/$pinId/like');
      return Pin.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pin> unlikePin(String pinId) async {
    try {
      final response = await _dio.delete('/pins/$pinId/like');
      return Pin.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Pin> savePin(String pinId, String boardId) async {
    try {
      final response = await _dio.post('/pins/$pinId/save', data: {
        'boardId': boardId,
      });
      return Pin.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Board endpoints
  Future<List<Board>> getUserBoards(String userId) async {
    try {
      final response = await _dio.get('/users/$userId/boards');
      return (response.data['boards'] as List)
          .map((json) => Board.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Board> createBoard({
    required String name,
    String? description,
    BoardPrivacy privacy = BoardPrivacy.public,
    String? category,
  }) async {
    try {
      final response = await _dio.post('/boards', data: {
        'name': name,
        'description': description,
        'privacy': privacy.name,
        'category': category,
      });
      
      return Board.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Pin>> getBoardPins(String boardId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/boards/$boardId/pins', queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      return (response.data['pins'] as List)
          .map((json) => Pin.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Search endpoints
  Future<SearchResult> searchPins(String query, {int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/search/pins', queryParameters: {
        'q': query,
        'page': page,
        'limit': limit,
      });
      
      return SearchResult.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<SearchSuggestion>> getSearchSuggestions(String query) async {
    try {
      final response = await _dio.get('/search/suggestions', queryParameters: {
        'q': query,
      });
      
      return (response.data['suggestions'] as List)
          .map((json) => SearchSuggestion.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Visual search
  Future<List<Pin>> visualSearch(String imageUrl) async {
    try {
      final response = await _dio.post('/search/visual', data: {
        'imageUrl': imageUrl,
      });
      
      return (response.data['pins'] as List)
          .map((json) => Pin.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // User endpoints
  Future<User> getUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('/users/me');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> followUser(String userId) async {
    try {
      await _dio.post('/users/$userId/follow');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> unfollowUser(String userId) async {
    try {
      await _dio.delete('/users/$userId/follow');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Comments endpoints
  Future<List<Comment>> getPinComments(String pinId) async {
    try {
      final response = await _dio.get('/pins/$pinId/comments');
      return (response.data['comments'] as List)
          .map((json) => Comment.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Comment> addComment(String pinId, String content, {String? parentCommentId}) async {
    try {
      final response = await _dio.post('/pins/$pinId/comments', data: {
        'content': content,
        'parentCommentId': parentCommentId,
      });
      
      return Comment.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Messages endpoints
  Future<List<Conversation>> getConversations() async {
    try {
      final response = await _dio.get('/messages/conversations');
      return (response.data['conversations'] as List)
          .map((json) => Conversation.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final response = await _dio.get('/messages/conversations/$conversationId');
      return (response.data['messages'] as List)
          .map((json) => Message.fromJson(json))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Message> sendMessage({
    required String receiverId,
    required MessageType type,
    String? content,
    String? pinId,
    String? boardId,
  }) async {
    try {
      final response = await _dio.post('/messages', data: {
        'receiverId': receiverId,
        'type': type.name,
        'content': content,
        'pinId': pinId,
        'boardId': boardId,
      });
      
      return Message.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Upload image
  Future<String> uploadImage(File imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });
      
      final response = await _dio.post('/upload/image', data: formData);
      return response.data['imageUrl'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timeout. Please check your internet connection.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['message'] ?? 'Unknown error occurred';
          return Exception('Server error ($statusCode): $message');
        default:
          return Exception('Network error: ${error.message}');
      }
    }
    return Exception('Unexpected error: $error');
  }
}