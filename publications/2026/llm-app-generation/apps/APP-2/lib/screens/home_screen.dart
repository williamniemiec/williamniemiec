import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../providers/library_provider.dart';
import '../constants/app_constants.dart';
import '../models/coloring_page.dart';
import '../widgets/coloring_page_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Consumer<LibraryProvider>(
          builder: (context, libraryProvider, child) {
            if (libraryProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
              );
            }

            if (libraryProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppConstants.errorColor,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      libraryProvider.error!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    ElevatedButton(
                      onPressed: () => libraryProvider.refresh(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: AppConstants.surfaceColor,
                  elevation: 0,
                  title: Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => libraryProvider.refresh(),
                    ),
                  ],
                ),

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    child: SearchBarWidget(
                      controller: _searchController,
                      onChanged: (query) => libraryProvider.search(query),
                      hintText: 'Search coloring pages...',
                    ),
                  ),
                ),

                // Category Filter
                SliverToBoxAdapter(
                  child: CategoryFilter(
                    categories: libraryProvider.categories,
                    selectedCategory: libraryProvider.selectedCategory,
                    onCategorySelected: (category) {
                      libraryProvider.selectCategory(category);
                    },
                  ),
                ),

                // Statistics Banner (for Featured category)
                if (libraryProvider.selectedCategory == 'Featured')
                  SliverToBoxAdapter(
                    child: _buildStatisticsBanner(context, libraryProvider),
                  ),

                // Recently Viewed (for Featured category)
                if (libraryProvider.selectedCategory == 'Featured')
                  _buildRecentlyViewedSection(context, libraryProvider),

                // Main Grid
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  sliver: _buildColoringPagesGrid(context, libraryProvider),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatisticsBanner(BuildContext context, LibraryProvider provider) {
    final stats = provider.getStatistics();
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Total', stats['total']!, Icons.palette),
          _buildStatItem(context, 'Completed', stats['completed']!, Icons.check_circle),
          _buildStatItem(context, 'In Progress', stats['inProgress']!, Icons.play_circle),
          _buildStatItem(context, 'Favorites', stats['favorites']!, Icons.favorite),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, int value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          value.toString(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentlyViewedSection(BuildContext context, LibraryProvider provider) {
    final recentPages = provider.getRecentlyViewedPages();
    
    if (recentPages.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            child: Text(
              'Recently Viewed',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              itemCount: recentPages.length,
              itemBuilder: (context, index) {
                final page = recentPages[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: AppConstants.paddingMedium),
                  child: ColoringPageCard(
                    page: page,
                    onTap: () => _navigateToColoring(context, page.id),
                    showProgress: true,
                    compact: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColoringPagesGrid(BuildContext context, LibraryProvider provider) {
    final pages = provider.filteredPages;

    if (pages.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: AppConstants.textLight,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                provider.searchQuery.isNotEmpty
                    ? 'No results found'
                    : 'No coloring pages available',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppConstants.textSecondary,
                ),
              ),
              if (provider.searchQuery.isNotEmpty) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Try searching with different keywords',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.textLight,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppConstants.paddingMedium,
        mainAxisSpacing: AppConstants.paddingMedium,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final page = pages[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: AppConstants.animationMedium,
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: ColoringPageCard(
                  page: page,
                  onTap: () => _navigateToColoring(context, page.id),
                  showProgress: true,
                ),
              ),
            ),
          );
        },
        childCount: pages.length,
      ),
    );
  }

  void _navigateToColoring(BuildContext context, String pageId) {
    context.push('/coloring/$pageId');
  }
}