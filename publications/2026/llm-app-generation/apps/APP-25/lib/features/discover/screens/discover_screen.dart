import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/discover_provider.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
      ),
      body: Consumer<DiscoverProvider>(
        builder: (context, discoverProvider, _) {
          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search communities...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: discoverProvider.searchSubreddits,
                ),
              ),
              
              // Content
              Expanded(
                child: discoverProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : discoverProvider.searchQuery.isNotEmpty
                        ? _buildSearchResults(discoverProvider)
                        : _buildDiscoverContent(discoverProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchResults(DiscoverProvider provider) {
    if (provider.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.searchResults.isEmpty) {
      return const Center(
        child: Text('No communities found'),
      );
    }

    return ListView.builder(
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final subreddit = provider.searchResults[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(subreddit.displayName[0].toUpperCase()),
          ),
          title: Text('r/${subreddit.displayName}'),
          subtitle: Text(subreddit.description),
          trailing: Text('${subreddit.formattedSubscribers} members'),
        );
      },
    );
  }

  Widget _buildDiscoverContent(DiscoverProvider provider) {
    return ListView(
      children: [
        // Popular Communities
        Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Text(
            'Popular Communities',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...provider.popularSubreddits.map((subreddit) => ListTile(
          leading: CircleAvatar(
            child: Text(subreddit.displayName[0].toUpperCase()),
          ),
          title: Text('r/${subreddit.displayName}'),
          subtitle: Text(subreddit.description),
          trailing: Text('${subreddit.formattedSubscribers} members'),
        )),
        
        // Trending Posts
        Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Text(
            'Trending Posts',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...provider.trendingPosts.map((post) => ListTile(
          title: Text(post.title),
          subtitle: Text('r/${post.subreddit.displayName} • ${post.timeAgo}'),
          trailing: Text('${post.formattedScore} ↑'),
        )),
      ],
    );
  }
}