import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Library'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search in library
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                // TODO: Handle menu selection
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'sort',
                  child: Text('Sort'),
                ),
                const PopupMenuItem(
                  value: 'filter',
                  child: Text('Filter'),
                ),
                const PopupMenuItem(
                  value: 'view',
                  child: Text('View Options'),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Audiobooks'),
              Tab(text: 'Podcasts'),
              Tab(text: 'Collections'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AllLibraryTab(),
            _AudiobooksTab(),
            _PodcastsTab(),
            _CollectionsTab(),
          ],
        ),
      ),
    );
  }
}

class _AllLibraryTab extends StatelessWidget {
  const _AllLibraryTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.headphones, size: 30),
            ),
            title: Text('Library Item ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Author Name'),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (index + 1) * 0.1,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 4),
                Text(
                  '${((index + 1) * 10)}% complete',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                // TODO: Handle item actions
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'play',
                  child: Text('Play'),
                ),
                const PopupMenuItem(
                  value: 'download',
                  child: Text('Download'),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Text('Remove'),
                ),
              ],
            ),
            onTap: () {
              // TODO: Navigate to player or details
            },
          ),
        );
      },
    );
  }
}

class _AudiobooksTab extends StatelessWidget {
  const _AudiobooksTab();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Icon(Icons.book, size: 50),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audiobook ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Author Name',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      LinearProgressIndicator(
                        value: (index + 1) * 0.1,
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PodcastsTab extends StatelessWidget {
  const _PodcastsTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.podcasts, size: 30),
            ),
            title: Text('Podcast ${index + 1}'),
            subtitle: Text('${(index + 1) * 3} episodes'),
            children: List.generate(3, (episodeIndex) {
              return ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text('Episode ${episodeIndex + 1}'),
                subtitle: Text('Duration: ${20 + episodeIndex * 5} min'),
                trailing: IconButton(
                  icon: const Icon(Icons.download_outlined),
                  onPressed: () {
                    // TODO: Download episode
                  },
                ),
                onTap: () {
                  // TODO: Play episode
                },
              );
            }),
          ),
        );
      },
    );
  }
}

class _CollectionsTab extends StatelessWidget {
  const _CollectionsTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Create new collection
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Collection'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.folder, size: 30),
                  ),
                  title: Text('Collection ${index + 1}'),
                  subtitle: Text('${(index + 1) * 4} items'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // TODO: Navigate to collection details
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}