import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/explore_category_card.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: AppSpacing.lg),
            _buildQuickActions(context),
            const SizedBox(height: AppSpacing.lg),
            _buildCategoriesSection(context),
            const SizedBox(height: AppSpacing.lg),
            _buildRecentActivity(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColorLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to ParentSquare',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Stay connected with your school community',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.event_available,
                title: 'RSVP Events',
                subtitle: '3 pending',
                color: AppTheme.primaryColor,
                onTap: () => _navigateToRsvpEvents(context),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.volunteer_activism,
                title: 'Sign-ups',
                subtitle: '2 available',
                color: AppTheme.secondaryColor,
                onTap: () => _navigateToSignUps(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.assignment,
                title: 'Forms',
                subtitle: '1 to complete',
                color: Colors.orange,
                onTap: () => _navigateToForms(context),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.payment,
                title: 'Payments',
                subtitle: 'All up to date',
                color: Colors.green,
                onTap: () => _navigateToPayments(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1.2,
          children: [
            ExploreCategoryCard(
              icon: Icons.photo_library,
              title: 'Photos & Videos',
              description: 'View shared memories',
              color: Colors.purple,
              onTap: () => _navigateToPhotos(context),
            ),
            ExploreCategoryCard(
              icon: Icons.folder,
              title: 'Files & Documents',
              description: 'Access important files',
              color: Colors.blue,
              onTap: () => _navigateToFiles(context),
            ),
            ExploreCategoryCard(
              icon: Icons.poll,
              title: 'Polls & Surveys',
              description: 'Share your opinion',
              color: Colors.teal,
              onTap: () => _navigateToPolls(context),
            ),
            ExploreCategoryCard(
              icon: Icons.help_center,
              title: 'Help & Support',
              description: 'Get assistance',
              color: Colors.orange,
              onTap: () => _navigateToHelp(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildActivityItem(
          context,
          icon: Icons.event_available,
          title: 'RSVP\'d to Parent-Teacher Conference',
          subtitle: '2 hours ago',
          color: AppTheme.primaryColor,
        ),
        _buildActivityItem(
          context,
          icon: Icons.volunteer_activism,
          title: 'Signed up for Field Day volunteers',
          subtitle: '1 day ago',
          color: AppTheme.secondaryColor,
        ),
        _buildActivityItem(
          context,
          icon: Icons.assignment_turned_in,
          title: 'Completed permission slip form',
          subtitle: '3 days ago',
          color: Colors.green,
        ),
        _buildActivityItem(
          context,
          icon: Icons.photo,
          title: 'Viewed Science Fair photos',
          subtitle: '1 week ago',
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context) {
    // TODO: Implement search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search feature coming soon!')),
    );
  }

  void _navigateToRsvpEvents(BuildContext context) {
    // TODO: Navigate to RSVP events
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('RSVP Events feature coming soon!')),
    );
  }

  void _navigateToSignUps(BuildContext context) {
    // TODO: Navigate to sign-ups
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign-ups feature coming soon!')),
    );
  }

  void _navigateToForms(BuildContext context) {
    // TODO: Navigate to forms
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forms feature coming soon!')),
    );
  }

  void _navigateToPayments(BuildContext context) {
    // TODO: Navigate to payments
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payments feature coming soon!')),
    );
  }

  void _navigateToPhotos(BuildContext context) {
    // TODO: Navigate to photos
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photos feature coming soon!')),
    );
  }

  void _navigateToFiles(BuildContext context) {
    // TODO: Navigate to files
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Files feature coming soon!')),
    );
  }

  void _navigateToPolls(BuildContext context) {
    // TODO: Navigate to polls
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Polls feature coming soon!')),
    );
  }

  void _navigateToHelp(BuildContext context) {
    // TODO: Navigate to help
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help feature coming soon!')),
    );
  }
}