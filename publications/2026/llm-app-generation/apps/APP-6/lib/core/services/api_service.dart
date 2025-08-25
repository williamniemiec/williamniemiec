import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      sendTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AppConstants.apiKey}',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      logPrint: (object) {
        if (kDebugMode) {
          debugPrint(object.toString());
        }
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add any request modifications here
        handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle successful responses
        handler.next(response);
      },
      onError: (error, handler) {
        // Handle errors
        _handleError(error);
        handler.next(error);
      },
    ));
  }

  void _handleError(DioException error) {
    String message;
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout. Please try again.';
        break;
      case DioExceptionType.badResponse:
        message = _getErrorMessage(error.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = AppConstants.networkError;
        break;
      default:
        message = AppConstants.genericError;
    }
    
    if (kDebugMode) {
      debugPrint('API Error: $message');
      debugPrint('Error details: ${error.toString()}');
    }
  }

  String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return AppConstants.genericError;
    }
  }

  // GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Upload file
  Future<Response<T>> uploadFile<T>(
    String path,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        ...?data,
      });

      return await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Download file
  Future<Response> downloadFile(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Cancel all requests
  void cancelRequests([String? reason]) {
    // Note: Dio doesn't have a clear method, but we can close it
    _dio.close();
  }
}

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.fromResponse(Response response) {
    return ApiResponse(
      success: response.statusCode != null && response.statusCode! < 400,
      data: response.data,
      statusCode: response.statusCode,
    );
  }
}

// API endpoints
class ApiEndpoints {
  // Templates
  static const String templates = '/templates';
  static const String templateCategories = '/templates/categories';
  static String templateById(String id) => '/templates/$id';
  
  // Assets
  static const String assets = '/assets';
  static const String photos = '/assets/photos';
  static const String videos = '/assets/videos';
  static const String graphics = '/assets/graphics';
  static const String icons = '/assets/icons';
  
  // Designs
  static const String designs = '/designs';
  static String designById(String id) => '/designs/$id';
  static String duplicateDesign(String id) => '/designs/$id/duplicate';
  
  // AI Features
  static const String magicDesign = '/ai/magic-design';
  static const String magicEdit = '/ai/magic-edit';
  static const String magicEraser = '/ai/magic-eraser';
  static const String textToImage = '/ai/text-to-image';
  static const String backgroundRemover = '/ai/background-remover';
  static const String magicTranslate = '/ai/magic-translate';
  
  // User
  static const String profile = '/user/profile';
  static const String subscription = '/user/subscription';
  static const String usage = '/user/usage';
  
  // Export
  static const String export = '/export';
  static String exportDesign(String id) => '/designs/$id/export';
  
  // Collaboration
  static const String teams = '/teams';
  static String teamById(String id) => '/teams/$id';
  static String teamMembers(String id) => '/teams/$id/members';
  static String shareDesign(String id) => '/designs/$id/share';
}