import 'package:cinephile/screens/search_screen.dart';
import 'package:cinephile/utils/providers.dart';
import 'package:cinephile/widgets/movie_carousel.dart';
import 'package:cinephile/widgets/tv_show_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DiscoverScreen(),
    SearchScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieRepository = ref.watch(movieRepositoryProvider);
    final tvShowRepository = ref.watch(tvShowRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinephile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieCarousel(
              title: 'Now Playing',
              future: movieRepository.getNowPlaying(),
            ),
            MovieCarousel(
              title: 'Trending',
              future: movieRepository.getTrending(),
            ),
            MovieCarousel(
              title: 'Top Rated',
              future: movieRepository.getTopRated(),
            ),
            TvShowCarousel(
              title: 'Popular TV Shows',
              future: tvShowRepository.getPopular(),
            ),
            TvShowCarousel(
              title: 'Top Rated TV Shows',
              future: tvShowRepository.getTopRated(),
            ),
          ],
        ),
      ),
    );
  }
}