import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/project_provider.dart';
import '../../../shared/models/video_project.dart';
import '../widgets/project_card.dart';
import '../widgets/create_project_dialog.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProjectsTab(),
                  _buildTemplatesTab(),
                  _buildRecentTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateProjectDialog,
        backgroundColor: AppTheme.accentColor,
        foregroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings),
                color: AppTheme.textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search projects...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
            ),
            onChanged: _performSearch,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppTheme.accentColor,
        labelColor: AppTheme.textPrimary,
        unselectedLabelColor: AppTheme.textSecondary,
        tabs: const [
          Tab(text: 'My Projects'),
          Tab(text: 'Templates'),
          Tab(text: 'Recent'),
        ],
      ),
    );
  }

  Widget _buildProjectsTab() {
    return Consumer(
      builder: (context, ref, child) {
        final projectsAsync = ref.watch(allProjectsProvider);
        
        return projectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyState();
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(allProjectsProvider);
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppConstants.defaultPadding,
                  mainAxisSpacing: AppConstants.defaultPadding,
                  childAspectRatio: 0.8,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(
                    project: projects[index],
                    onTap: () => _openProject(projects[index]),
                    onDelete: () => _deleteProject(projects[index]),
                    onDuplicate: () => _duplicateProject(projects[index]),
                  );
                },
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppTheme.accentColor,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                Text(
                  'Failed to load projects',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.defaultPadding),
                ElevatedButton(
                  onPressed: () => ref.invalidate(allProjectsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTemplatesTab() {
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
            'Templates Coming Soon',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Browse trending video templates',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ElevatedButton(
            onPressed: () => context.push('/templates'),
            child: const Text('Browse Templates'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTab() {
    return Consumer(
      builder: (context, ref, child) {
        final recentProjectsAsync = ref.watch(recentProjectsProvider);
        
        return recentProjectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyState();
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
                  child: ListTile(
                    leading: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.videoClipColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: project.thumbnailPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                project.thumbnailPath!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.video_file,
                                    color: AppTheme.textPrimary,
                                  );
                                },
                              ),
                            )
                          : const Icon(
                              Icons.video_file,
                              color: AppTheme.textPrimary,
                            ),
                    ),
                    title: Text(
                      project.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Updated ${_formatDate(project.updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'open':
                            _openProject(project);
                            break;
                          case 'duplicate':
                            _duplicateProject(project);
                            break;
                          case 'delete':
                            _deleteProject(project);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'open',
                          child: Text('Open'),
                        ),
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Text('Duplicate'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                    onTap: () => _openProject(project),
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppTheme.accentColor,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Failed to load recent projects',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_call_outlined,
            size: 64,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'No projects yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Create your first video project',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ElevatedButton.icon(
            onPressed: _showCreateProjectDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      ref.read(searchProjectsProvider.notifier).searchProjects(query);
    } else {
      ref.read(searchProjectsProvider.notifier).clearSearch();
    }
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateProjectDialog(),
    );
  }

  void _openProject(VideoProject project) {
    context.push('/editor/${project.id}');
  }

  void _deleteProject(VideoProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text('Are you sure you want to delete "${project.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(projectServiceProvider).deleteProject(project.id);
                ref.invalidate(allProjectsProvider);
                ref.invalidate(recentProjectsProvider);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppConstants.successProjectDeleted),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete project: $e'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _duplicateProject(VideoProject project) async {
    try {
      await ref.read(projectServiceProvider).duplicateProject(project.id);
      ref.invalidate(allProjectsProvider);
      ref.invalidate(recentProjectsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project duplicated successfully'),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to duplicate project: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}