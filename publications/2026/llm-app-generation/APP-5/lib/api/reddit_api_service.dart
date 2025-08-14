import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:momentum_reddit/models/comment.dart';
import 'package:momentum_reddit/models/post.dart';

class RedditApiService {
  static const String _baseUrl = 'https://www.reddit.com';

  Future<List<Post>> fetchPosts({String? after}) async {
    final uri = Uri.parse(
      '$_baseUrl/top.json?limit=25${after != null ? '&after=$after' : ''}',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final posts = (data['data']['children'] as List)
          .map((item) => Post.fromJson(item['data']))
          .toList();
      return posts;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<List<dynamic>> fetchComments(String postId) async {
    final uri = Uri.parse('$_baseUrl/comments/$postId.json');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final postData = data[0]['data']['children'][0]['data'];
      final commentsData = data[1]['data']['children'];

      final post = Post.fromJson(postData);
      final comments = (commentsData as List)
          .where((item) => item['kind'] == 't1')
          .map((item) => Comment.fromJson(item['data']))
          .toList();

      return [post, comments];
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
