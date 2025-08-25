import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_router.dart';
import '../../../shared/services/app_provider.dart';
import '../../../shared/models/design_project.dart';
import '../../../shared/models/room_type.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Designs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Favorites'),
            Tab(text: 'Recent'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All Projects'),
              ),
              const PopupMenuItem(
                value: 'completed',
                child: Text('Completed Only'),
              ),
              const PopupMenuItem(
                value: 'interior',
                child: Text('Interior Only'),
              ),
              const PopupMenuItem(
                value: 'exterior',
                child: Text('Exterior Only'),
              ),
            ],
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllProjects(),
          _buildFavoriteProjects(),
          _buildRecentProjects(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigation.goToHome(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAllProjects() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final projects = _filterProjects(provider.projects);
        
        if (projects.isEmpty) {
          return _buildEmptyState(
            icon: Icons.photo_library_outlined,
            title: 'No designs yet',
            subtitle: 'Create your first AI-generated design',
            actionText: 'Start Designing',
            onAction: () => AppNavigation.goToHome(context),
          );
        }

        return _buildProjectGrid(projects);
      },
    );
  }

  Widget _buildFavoriteProjects() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final projects = _filterProjects(provider.favoriteProjects);
        
        if (projects.isEmpty) {
          return _buildEmptyState(
            icon: Icons.favorite_outline,
            title: 'No favorites yet',
            subtitle: 'Mark your favorite designs by tapping the heart icon',
            actionText: 'Browse Designs',
            onAction: () => _tabController.animateTo(0),
          );
        }

        return _buildProjectGrid(projects);
      },
    );
  }

  Widget _buildRecentProjects() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final recentProjects = _filterProjects(provider.projects.take(20).toList());
        
        if (recentProjects.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history,
            title: 'No recent designs',
            subtitle: 'Your recent designs will appear here',
            actionText: 'Create Design',
            onAction: () => AppNavigation.goToHome(context),
          );
        }

        return _buildProjectGrid(recentProjects);
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTheme.headingMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectGrid(List<DesignProject> projects) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];
          return _buildProjectCard(project);
        },
      ),
    );
  }

  Widget _buildProjectCard(DesignProject project) {
    return GestureDetector(
      onTap: () => AppNavigation.goToResults(context, project.id),
      child: Container(
        decoration: AppDecorations.cardDecoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project image
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _buildProjectImage(project),
                    ),
                    
                    // Status indicator
                    Positioned(
                      top: 8,
                      left: 8,
                      child: _buildStatusIndicator(project.status),
                    ),
                    
                    // Favorite indicator
                    if (project.isFavorite)
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          color: AppTheme.errorColor,
                          size: 20,
                        ),
                      ),
                    
                    // Actions overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: _buildProjectActions(project),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Project info
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.roomType.name,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        project.designStyle.name,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(project.createdAt),
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectImage(DesignProject project) {
    final imagePath = project.generatedImagePath ?? project.originalImagePath;
    
    return Image.file(
      File(imagePath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppTheme.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                project.status == ProjectStatus.processing
                    ? Icons.hourglass_empty
                    : Icons.image_not_supported,
                color: AppTheme.textTertiary,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                project.status == ProjectStatus.processing
                    ? 'Processing...'
                    : 'Image not found',
                style: AppTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(ProjectStatus status) {
    Color color;
    IconData icon;
    String text;

    switch (status) {
      case ProjectStatus.processing:
        color = AppTheme.warningColor;
        icon = Icons.hourglass_empty;
        text = 'Processing';
        break;
      case ProjectStatus.completed:
        color = AppTheme.successColor;
        icon = Icons.check_circle;
        text = 'Done';
        break;
      case ProjectStatus.failed:
        color = AppTheme.errorColor;
        icon = Icons.error;
        text = 'Failed';
        break;
      default:
        color = AppTheme.textTertiary;
        icon = Icons.help;
        text = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectActions(DesignProject project) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleProjectAction(value, project),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 16),
              SizedBox(width: 8),
              Text('View'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'favorite',
          child: Row(
            children: [
              Icon(
                project.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(project.isFavorite ? 'Unfavorite' : 'Favorite'),
            ],
          ),
        ),
        if (project.status == ProjectStatus.completed) ...[
          const PopupMenuItem(
            value: 'share',
            child: Row(
              children: [
                Icon(Icons.share, size: 16),
                SizedBox(width: 8),
                Text('Share'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'new_style',
            child: Row(
              children: [
                Icon(Icons.refresh, size: 16),
                SizedBox(width: 8),
                Text('New Style'),
              ],
            ),
          ),
        ],
        if (project.status == ProjectStatus.failed)
          const PopupMenuItem(
            value: 'retry',
            child: Row(
              children: [
                Icon(Icons.refresh, size: 16),
                SizedBox(width: 8),
                Text('Retry'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 16, color: AppTheme.errorColor),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: AppTheme.errorColor)),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.more_vert,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  List<DesignProject> _filterProjects(List<DesignProject> projects) {
    switch (_selectedFilter) {
      case 'completed':
        return projects.where((p) => p.status == ProjectStatus.completed).toList();
      case 'interior':
        return projects.where((p) => p.roomType.category == RoomCategory.interior).toList();
      case 'exterior':
        return projects.where((p) => p.roomType.category == RoomCategory.exterior).toList();
      default:
        return projects;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _handleProjectAction(String action, DesignProject project) async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    
    switch (action) {
      case 'view':
        AppNavigation.goToResults(context, project.id);
        break;
        
      case 'favorite':
        try {
          await provider.toggleProjectFavorite(project.id);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        }
        break;
        
      case 'share':
        // Share functionality would be implemented here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Share functionality coming soon!')),
        );
        break;
        
      case 'new_style':
        AppNavigation.goToEditor(context, imagePath: project.originalImagePath);
        break;
        
      case 'retry':
        try {
          await provider.retryProject(project.id);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error retrying: ${e.toString()}'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        }
        break;
        
      case 'delete':
        _showDeleteConfirmation(project);
        break;
    }
  }

  void _showDeleteConfirmation(DesignProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Design'),
        content: const Text('Are you sure you want to delete this design? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = Provider.of<AppProvider>(context, listen: false);
              try {
                await provider.deleteProject(project.id);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting: ${e.toString()}'),
                      backgroundColor: AppTheme.errorColor,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}