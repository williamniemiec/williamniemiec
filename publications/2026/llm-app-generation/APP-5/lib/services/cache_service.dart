import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();

  factory CacheService() {
    return _instance;
  }

  CacheService._internal();

  void prefetchImage(String url) {
    if (url.isNotEmpty) {
      precacheImage(CachedNetworkImageProvider(url), ContextUnavailable());
    }
  }
}

class ContextUnavailable implements BuildContext {
  @override
  bool get mounted => false;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw Exception('Context is not available outside of the widget tree.');
  }
}
