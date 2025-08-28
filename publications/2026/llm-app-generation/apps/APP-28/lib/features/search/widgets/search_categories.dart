import 'package:flutter/material.dart';
import '../../../shared/models/photo.dart';

class SearchCategories extends StatelessWidget {
  final List<Photo> photos;
  final Function(String, List<Photo>) onCategoryTap;

  const SearchCategories({
    super.key,
    required this.photos,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = _generateCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Browse by category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () => onCategoryTap(category.name, category.photos),
            );
          },
        ),
      ],
    );
  }

  List<SearchCategory> _generateCategories() {
    final categories = <SearchCategory>[];

    // People & Pets
    final peoplePhotos = photos.where((photo) => 
      photo.tags.any((tag) => ['people', 'person', 'family', 'friends'].contains(tag.toLowerCase()))
    ).toList();
    if (peoplePhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'People',
        icon: Icons.people,
        color: Colors.pink,
        photos: peoplePhotos,
      ));
    }

    // Places
    final placePhotos = photos.where((photo) => photo.location != null).toList();
    if (placePhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'Places',
        icon: Icons.place,
        color: Colors.blue,
        photos: placePhotos,
      ));
    }

    // Nature
    final naturePhotos = photos.where((photo) => 
      photo.tags.any((tag) => ['nature', 'landscape', 'trees', 'flowers', 'mountains', 'forest'].contains(tag.toLowerCase()))
    ).toList();
    if (naturePhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'Nature',
        icon: Icons.nature,
        color: Colors.green,
        photos: naturePhotos,
      ));
    }

    // Beach & Ocean
    final beachPhotos = photos.where((photo) => 
      photo.tags.any((tag) => ['beach', 'ocean', 'water', 'waves'].contains(tag.toLowerCase()))
    ).toList();
    if (beachPhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'Beach',
        icon: Icons.beach_access,
        color: Colors.cyan,
        photos: beachPhotos,
      ));
    }

    // City & Architecture
    final cityPhotos = photos.where((photo) => 
      photo.tags.any((tag) => ['city', 'building', 'architecture', 'urban'].contains(tag.toLowerCase()))
    ).toList();
    if (cityPhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'City',
        icon: Icons.location_city,
        color: Colors.grey,
        photos: cityPhotos,
      ));
    }

    // Food
    final foodPhotos = photos.where((photo) => 
      photo.tags.any((tag) => ['food', 'meal', 'restaurant', 'cooking'].contains(tag.toLowerCase()))
    ).toList();
    if (foodPhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'Food',
        icon: Icons.restaurant,
        color: Colors.orange,
        photos: foodPhotos,
      ));
    }

    // Videos
    final videoPhotos = photos.where((photo) => photo.type == PhotoType.video).toList();
    if (videoPhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'Videos',
        icon: Icons.videocam,
        color: Colors.purple,
        photos: videoPhotos,
      ));
    }

    // Favorites
    final favoritePhotos = photos.where((photo) => photo.isFavorite).toList();
    if (favoritePhotos.isNotEmpty) {
      categories.add(SearchCategory(
        name: 'Favorites',
        icon: Icons.favorite,
        color: Colors.red,
        photos: favoritePhotos,
      ));
    }

    return categories;
  }
}

class CategoryCard extends StatelessWidget {
  final SearchCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              category.color.withOpacity(0.8),
              category.color,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                category.icon,
                color: Colors.white,
                size: 32,
              ),
              const Spacer(),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${category.photos.length} item${category.photos.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchCategory {
  final String name;
  final IconData icon;
  final Color color;
  final List<Photo> photos;

  SearchCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.photos,
  });
}