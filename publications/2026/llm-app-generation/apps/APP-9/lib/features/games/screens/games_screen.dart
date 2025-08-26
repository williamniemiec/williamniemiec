import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/game_card.dart';
import '../widgets/game_category_filter.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', ...AppConstants.gameCategories];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.games,
          style: TextStyle(
            color: AppTheme.netflixWhite,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.netflixBlack,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement game search
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          GameCategoryFilter(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          
          // Games Grid
          Expanded(
            child: _buildGamesGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesGrid() {
    final games = _getMockGames();
    final filteredGames = _selectedCategory == 'All' 
        ? games 
        : games.where((game) => game['category'] == _selectedCategory).toList();

    if (filteredGames.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videogame_asset_outlined,
              size: 64,
              color: AppTheme.netflixLightGray,
            ),
            SizedBox(height: 16),
            Text(
              'No games found',
              style: TextStyle(
                color: AppTheme.netflixLightGray,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: filteredGames.length,
      itemBuilder: (context, index) {
        final game = filteredGames[index];
        return GameCard(game: game);
      },
    );
  }

  List<Map<String, dynamic>> _getMockGames() {
    // Mock game data - in a real app, this would come from an API
    return [
      {
        'id': 'game-1',
        'title': 'Stranger Things: 1984',
        'iconUrl': 'https://via.placeholder.com/150x150/333333/FFFFFF?text=ST',
        'category': 'Adventure',
        'rating': 4.5,
        'sizeInMB': 250,
        'isInstalled': false,
        'isDownloading': false,
        'description': 'Experience the world of Stranger Things in this retro adventure game.',
      },
      {
        'id': 'game-2',
        'title': 'Oxenfree',
        'iconUrl': 'https://via.placeholder.com/150x150/333333/FFFFFF?text=OX',
        'category': 'Adventure',
        'rating': 4.2,
        'sizeInMB': 180,
        'isInstalled': true,
        'isDownloading': false,
        'description': 'A supernatural thriller about a group of friends who unwittingly open a ghostly rift.',
      },
      {
        'id': 'game-3',
        'title': 'Card Blast',
        'iconUrl': 'https://via.placeholder.com/150x150/333333/FFFFFF?text=CB',
        'category': 'Puzzle',
        'rating': 4.0,
        'sizeInMB': 120,
        'isInstalled': false,
        'isDownloading': true,
        'description': 'Match cards and clear the board in this addictive puzzle game.',
      },
      {
        'id': 'game-4',
        'title': 'Shooting Hoops',
        'iconUrl': 'https://via.placeholder.com/150x150/333333/FFFFFF?text=SH',
        'category': 'Sports',
        'rating': 3.8,
        'sizeInMB': 95,
        'isInstalled': false,
        'isDownloading': false,
        'description': 'Test your basketball skills in this arcade-style sports game.',
      },
      {
        'id': 'game-5',
        'title': 'Teeter Up',
        'iconUrl': 'https://via.placeholder.com/150x150/333333/FFFFFF?text=TU',
        'category': 'Arcade',
        'rating': 4.1,
        'sizeInMB': 85,
        'isInstalled': true,
        'isDownloading': false,
        'description': 'Balance and climb your way to the top in this challenging arcade game.',
      },
      {
        'id': 'game-6',
        'title': 'Dominoes Cafe',
        'iconUrl': 'https://via.placeholder.com/150x150/333333/FFFFFF?text=DC',
        'category': 'Strategy',
        'rating': 4.3,
        'sizeInMB': 110,
        'isInstalled': false,
        'isDownloading': false,
        'description': 'Play classic dominoes with players from around the world.',
      },
    ];
  }
}