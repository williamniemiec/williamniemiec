import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({super.key});

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AppConstants.templateCategories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Templates'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppTheme.accentColor,
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textSecondary,
          tabs: AppConstants.templateCategories.map((category) {
            return Tab(text: category);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: AppConstants.templateCategories.map((category) {
          return _buildTemplateGrid(category);
        }).toList(),
      ),
    );
  }

  Widget _buildTemplateGrid(String category) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            '$category Templates',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Coming Soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Templates feature coming soon!'),
                  backgroundColor: AppTheme.accentColor,
                ),
              );
            },
            child: const Text('Browse Templates'),
          ),
        ],
      ),
    );
  }
}