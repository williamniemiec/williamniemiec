// Import statements for the models used
import 'pin.dart';
import 'board.dart';
import 'user.dart';

class SearchResult {
  final List<Pin> pins;
  final List<Board> boards;
  final List<User> users;
  final String query;
  final int totalResults;
  final bool hasMore;
  final String? nextPageToken;

  const SearchResult({
    this.pins = const [],
    this.boards = const [],
    this.users = const [],
    required this.query,
    this.totalResults = 0,
    this.hasMore = false,
    this.nextPageToken,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      pins: (json['pins'] as List<dynamic>?)
              ?.map((e) => Pin.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => Board.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      query: json['query'] as String,
      totalResults: json['totalResults'] as int? ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
      nextPageToken: json['nextPageToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pins': pins.map((e) => e.toJson()).toList(),
      'boards': boards.map((e) => e.toJson()).toList(),
      'users': users.map((e) => e.toJson()).toList(),
      'query': query,
      'totalResults': totalResults,
      'hasMore': hasMore,
      'nextPageToken': nextPageToken,
    };
  }

  SearchResult copyWith({
    List<Pin>? pins,
    List<Board>? boards,
    List<User>? users,
    String? query,
    int? totalResults,
    bool? hasMore,
    String? nextPageToken,
  }) {
    return SearchResult(
      pins: pins ?? this.pins,
      boards: boards ?? this.boards,
      users: users ?? this.users,
      query: query ?? this.query,
      totalResults: totalResults ?? this.totalResults,
      hasMore: hasMore ?? this.hasMore,
      nextPageToken: nextPageToken ?? this.nextPageToken,
    );
  }

  bool get isEmpty => pins.isEmpty && boards.isEmpty && users.isEmpty;
  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'SearchResult(query: $query, pins: ${pins.length}, boards: ${boards.length}, users: ${users.length})';
  }
}

class SearchSuggestion {
  final String id;
  final String text;
  final String type; // 'query', 'user', 'board', 'category'
  final String? imageUrl;
  final int searchCount;

  const SearchSuggestion({
    required this.id,
    required this.text,
    required this.type,
    this.imageUrl,
    this.searchCount = 0,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      id: json['id'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
      imageUrl: json['imageUrl'] as String?,
      searchCount: json['searchCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type,
      'imageUrl': imageUrl,
      'searchCount': searchCount,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchSuggestion && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SearchSuggestion(text: $text, type: $type)';
  }
}
