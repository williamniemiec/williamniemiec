import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_router.dart';
import '../../../shared/services/app_provider.dart';
import '../../../shared/models/design_project.dart';
import '../widgets/before_after_slider.dart';

class ResultsScreen extends StatefulWidget {
  final String projectId;

  const ResultsScreen({super.key, required this.projectId});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  DesignProject? _project;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  void _loadProject() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final project = provider.projects.firstWhere(
      (p) => p.id == widget.projectId,
      orElse: () => throw Exception('Project not found'),
    );
    
    setState(() {
      _project = project;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Project not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Result'),
        actions: [
          IconButton(
            onPressed: _handleShare,
            icon: const Icon(Icons.share),
          ),
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              final isFavorite = _project?.isFavorite ?? false;
              return IconButton(
                onPressed: () => _handleToggleFavorite(provider),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.errorColor : null,
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody() {
    switch (_project!.status) {
      case ProjectStatus.processing:
        return _buildProcessingView();
      case ProjectStatus.completed:
        return _buildCompletedView();
      case ProjectStatus.failed:
        return _buildFailedView();
      default:
        return _buildProcessingView();
    }
  }

  Widget _buildProcessingView() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Original image preview
          Container(
            width: double.infinity,
            height: 300,
            decoration: AppDecorations.cardDecoration,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_project!.originalImagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.backgroundColor,
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppTheme.errorColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Processing indicator
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          
          Text(
            'AI is working on your design...',
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          
          Text(
            'This usually takes 30-60 seconds',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Project details
          _buildProjectDetails(),
        ],
      ),
    );
  }

  Widget _buildCompletedView() {
    if (_project!.generatedImagePath == null) {
      return _buildFailedView();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Before/After Slider
          BeforeAfterSlider(
            beforeImagePath: _project!.originalImagePath,
            afterImagePath: _project!.generatedImagePath!,
          ),
          
          const SizedBox(height: 24),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Project details
                _buildProjectDetails(),
                const SizedBox(height: 24),
                
                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailedView() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 24),
          
          const Text(
            'Generation Failed',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: 8),
          
          Text(
            _project!.errorMessage ?? 'An error occurred while generating your design',
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => AppNavigation.goToHome(context),
                  child: const Text('Go Home'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleRetry,
                  child: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetails() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Project Details',
            style: AppTheme.headingSmall,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Room Type',
                  _project!.roomType.name,
                  Icons.room,
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Style',
                  _project!.designStyle.name,
                  Icons.palette,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Created',
                  _formatDate(_project!.createdAt),
                  Icons.schedule,
                ),
              ),
              if (_project!.completedAt != null)
                Expanded(
                  child: _buildDetailItem(
                    'Completed',
                    _formatDate(_project!.completedAt!),
                    Icons.check_circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _handleShare,
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _handleNewStyle,
                icon: const Icon(Icons.refresh),
                label: const Text('New Style'),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Secondary actions
        Row(
          children: [
            Expanded(
              child: TextButton.icon(
                onPressed: () => AppNavigation.goToGallery(context),
                icon: const Icon(Icons.photo_library),
                label: const Text('View Gallery'),
              ),
            ),
            Expanded(
              child: TextButton.icon(
                onPressed: _handleNewProject,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('New Project'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    if (_project!.status != ProjectStatus.completed) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          top: BorderSide(color: AppTheme.dividerColor),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => AppNavigation.goToHome(context),
                child: const Text('Home'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _handleNewProject,
                child: const Text('New Design'),
              ),
            ),
          ],
        ),
      ),
    );
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

  Future<void> _handleShare() async {
    if (_project!.status != ProjectStatus.completed || 
        _project!.generatedImagePath == null) {
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(_project!.generatedImagePath!)],
        text: 'Check out my AI-generated home design! Created with ${_project!.designStyle.name} style for my ${_project!.roomType.name}.',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _handleToggleFavorite(AppProvider provider) async {
    try {
      await provider.toggleProjectFavorite(_project!.id);
      setState(() {
        _project = provider.projects.firstWhere((p) => p.id == _project!.id);
      });
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
  }

  Future<void> _handleRetry() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    try {
      await provider.retryProject(_project!.id);
      setState(() {
        _project = provider.projects.firstWhere((p) => p.id == _project!.id);
      });
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
  }

  void _handleNewStyle() {
    AppNavigation.goToEditor(context, imagePath: _project!.originalImagePath);
  }

  void _handleNewProject() {
    AppNavigation.goToHome(context);
  }
}