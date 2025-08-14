import 'package:cinephile/api/api_service.dart';
import 'package:cinephile/services/movie_repository.dart';
import 'package:cinephile/services/tv_show_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MovieRepository(apiService);
});

final tvShowRepositoryProvider = Provider<TvShowRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return TvShowRepository(apiService);
});

final searchProvider = StateProvider<String>((ref) => '');