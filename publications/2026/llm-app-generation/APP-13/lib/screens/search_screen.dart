import 'package:cinephile/models/movie.dart';
import 'package:cinephile/models/tv_show.dart';
import 'package:cinephile/utils/providers.dart';
import 'package:cinephile/widgets/movie_carousel.dart';
import 'package:cinephile/widgets/tv_show_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchResultsProvider = FutureProvider<Map<String, List<dynamic>>>((ref) async {
  final searchTerm = ref.watch(searchProvider);
  if (searchTerm.isEmpty) {
    return {'movies': [], 'tvShows': []};
  }

  final movieRepository = ref.watch(movieRepositoryProvider);
  final tvShowRepository = ref.watch(tvShowRepositoryProvider);

  final movieResults = await movieRepository.searchMovies(searchTerm);
  final tvShowResults = await tvShowRepository.searchTvShows(searchTerm);

  return {'movies': movieResults, 'tvShows': tvShowResults};
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                ref.read(searchProvider.notifier).state = value;
              },
              decoration: const InputDecoration(
                hintText: 'Search for a movie or TV show...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: searchResults.when(
              data: (data) {
                final movies = data['movies'] as List<Movie>;
                final tvShows = data['tvShows'] as List<TvShow>;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      MovieCarousel(
                        title: 'Movies',
                        future: Future.value(movies),
                      ),
                      TvShowCarousel(
                        title: 'TV Shows',
                        future: Future.value(tvShows),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text(err.toString())),
            ),
          ),
        ],
      ),
    );
  }
}