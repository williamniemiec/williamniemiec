import 'package:cinephile/api/api_service.dart';
import 'package:cinephile/models/actor.dart';
import 'package:cinephile/models/movie.dart';

class MovieRepository {
  final ApiService _apiService;

  MovieRepository(this._apiService);

  Future<List<Movie>> getNowPlaying() async {
    final data = await _apiService.get('movie/now_playing');
    final results = data['results'] as List;
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  Future<List<Movie>> getTrending() async {
    final data = await _apiService.get('trending/movie/week');
    final results = data['results'] as List;
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  Future<List<Movie>> getTopRated() async {
    final data = await _apiService.get('movie/top_rated');
    final results = data['results'] as List;
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final data = await _apiService.get('search/movie?query=$query');
    final results = data['results'] as List;
    return results.map((movie) => Movie.fromJson(movie)).toList();
  }

  Future<List<Actor>> getMovieCast(int movieId) async {
    final data = await _apiService.get('movie/$movieId/credits');
    final results = data['cast'] as List;
    return results.map((actor) => Actor.fromJson(actor)).toList();
  }

  Future<Actor> getActorDetails(int actorId) async {
    final data = await _apiService.get('person/$actorId');
    return Actor.fromJson(data);
  }
}