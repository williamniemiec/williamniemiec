import 'package:cinephile/api/api_service.dart';
import 'package:cinephile/models/actor.dart';
import 'package:cinephile/models/tv_show.dart';

class TvShowRepository {
  final ApiService _apiService;

  TvShowRepository(this._apiService);

  Future<List<TvShow>> getPopular() async {
    final data = await _apiService.get('tv/popular');
    final results = data['results'] as List;
    return results.map((tvShow) => TvShow.fromJson(tvShow)).toList();
  }

  Future<List<TvShow>> getTopRated() async {
    final data = await _apiService.get('tv/top_rated');
    final results = data['results'] as List;
    return results.map((tvShow) => TvShow.fromJson(tvShow)).toList();
  }

  Future<List<TvShow>> searchTvShows(String query) async {
    final data = await _apiService.get('search/tv?query=$query');
    final results = data['results'] as List;
    return results.map((tvShow) => TvShow.fromJson(tvShow)).toList();
  }

  Future<List<Actor>> getTvShowCast(int tvShowId) async {
    final data = await _apiService.get('tv/$tvShowId/credits');
    final results = data['cast'] as List;
    return results.map((actor) => Actor.fromJson(actor)).toList();
  }

  Future<Actor> getActorDetails(int actorId) async {
    final data = await _apiService.get('person/$actorId');
    return Actor.fromJson(data);
  }
}