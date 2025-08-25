import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../providers/library_provider.dart';
import '../constants/app_constants.dart';
import '../models/coloring_page.dart';
import '../widgets/coloring_page_card.dart';

class MyWorksScreen extends StatefulWidget {
  const MyWorksScreen({super.key});

  @override
  State<MyWorksScreen> createState() => _MyWorksScreenState();
}

class _MyWorksScreenState extends State<MyWorksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Consumer<LibraryProvider>(
          builder: (context, libraryProvider, child) {
            return Column(
              children: [
                // App Bar
                Container(
                  color: AppConstants.surfaceColor,
                  child: Column(
                    children: [
                      // Title and Actions
                      Padding(
                        padding: const EdgeInsets.all(AppConstants.paddingMedium),
                        child: Row(
                          children: [
                            Text(
                              'My Works',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppConstants.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => libraryProvider.refresh(),
                            ),
                          ],
                        ),
                      ),

                      // Tab Bar
                      TabBar(
                        controller: _tabController,
                        labelColor: AppConstants.primaryColor,
                        unselectedLabelColor: AppConstants.textSecondary,
                        indicatorColor: AppConstants.primaryColor,
                        indicatorWeight: 3,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.play_circle_outline),
                                const SizedBox(width: 8),
                                Text('In Progress (${libraryProvider.getInProgressPages().length})'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle_outline),
                                const SizedBox(width: 8),
                                Text('Completed (${libraryProvider.getCompletedPages().length})'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildInProgressTab(context, libraryProvider),
                      _buildCompletedTab(context, libraryProvider),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInProgressTab(BuildContext context, LibraryProvider provider) {
    final inProgressPages = provider.getInProgressPages();

    if (inProgressPages.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.play_circle_outline,
        title: 'No works in progress',
        subtitle: 'Start coloring a page to see it here',
        actionText: 'Browse Library',
        onAction: () {
          // Switch to library tab (index 0)
          DefaultTabController.of(context)?.animateTo(0);
        },
      );
    }

    return _buildPageGrid(context, inProgressPages, showProgress: true);
  }

  Widget _buildCompletedTab(BuildContext context, LibraryProvider provider) {
    final completedPages = provider.getCompletedPages();

    if (completedPages.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.check_circle_outline,
        title: 'No completed works',
        subtitle: 'Complete a coloring page to see it here',
        actionText: 'Browse Library',
        onAction: () {
          // Navigate back to home screen - we can't switch tabs from here
          // since this screen doesn't have access to the main navigation
        },
      );
    }

    return _buildPageGrid(context, completedPages, showProgress: false);
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppConstants.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppConstants.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingMedium,
                ),
              ),
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageGrid(
    BuildContext context,
    List<ColoringPage> pages, {
    required bool showProgress,
  }) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: AppConstants.paddingMedium,
          mainAxisSpacing: AppConstants.paddingMedium,
        ),
        itemCount: pages.length,
        itemBuilder: (context, index) {
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
                  showProgress: showProgress,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToColoring(BuildContext context, String pageId) {
    context.push('/coloring/$pageId');
  }
}