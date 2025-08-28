import 'package:flutter/material.dart';
import '../../../shared/models/album.dart';
import '../../../core/constants/app_constants.dart';

class MemoriesCarousel extends StatelessWidget {
  final List<Memory> memories;
  final Function(Memory) onMemoryTap;

  const MemoriesCarousel({
    super.key,
    required this.memories,
    required this.onMemoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (memories.isEmpty) return const SizedBox.shrink();

    return Container(
      height: AppConstants.memoriesCarouselHeight.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Memories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: memories.length,
              itemBuilder: (context, index) {
                final memory = memories[index];
                return MemoryCard(
                  memory: memory,
                  onTap: () => onMemoryTap(memory),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MemoryCard extends StatelessWidget {
  final Memory memory;
  final VoidCallback onTap;

  const MemoryCard({
    super.key,
    required this.memory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            // Memory thumbnail
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Placeholder for memory cover
                      _buildMemoryThumbnail(),
                      
                      // Memory type indicator
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            _getMemoryTypeIcon(),
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                      
                      // Photo count indicator
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${memory.photoCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Memory title
            Text(
              memory.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryThumbnail() {
    // For demo purposes, we'll use a gradient background with an icon
    // In a real app, this would show the actual cover photo
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getMemoryGradientColors(),
        ),
      ),
      child: Center(
        child: Icon(
          _getMemoryTypeIcon(),
          size: 24,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  IconData _getMemoryTypeIcon() {
    switch (memory.type) {
      case MemoryType.yearAgo:
        return Icons.history;
      case MemoryType.trip:
        return Icons.flight_takeoff;
      case MemoryType.people:
        return Icons.people;
      case MemoryType.pets:
        return Icons.pets;
      case MemoryType.celebration:
        return Icons.celebration;
      case MemoryType.general:
      default:
        return Icons.photo_library;
    }
  }

  List<Color> _getMemoryGradientColors() {
    switch (memory.type) {
      case MemoryType.yearAgo:
        return [Colors.purple[400]!, Colors.purple[600]!];
      case MemoryType.trip:
        return [Colors.blue[400]!, Colors.blue[600]!];
      case MemoryType.people:
        return [Colors.pink[400]!, Colors.pink[600]!];
      case MemoryType.pets:
        return [Colors.orange[400]!, Colors.orange[600]!];
      case MemoryType.celebration:
        return [Colors.amber[400]!, Colors.amber[600]!];
      case MemoryType.general:
      default:
        return [Colors.teal[400]!, Colors.teal[600]!];
    }
  }
}

class MemoriesShimmer extends StatelessWidget {
  const MemoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.memoriesCarouselHeight.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 80,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 60,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}