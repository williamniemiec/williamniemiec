import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/project_provider.dart';

class EditorScreen extends ConsumerStatefulWidget {
  final String projectId;

  const EditorScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  @override
  void initState() {
    super.initState();
    // Load the project when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentProjectProvider.notifier).loadProject(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(currentProject?.name ?? 'Video Editor'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _saveProject,
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: _exportProject,
            icon: const Icon(Icons.file_download),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  _showProjectSettings();
                  break;
                case 'export':
                  _exportProject();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'settings',
                child: Text('Project Settings'),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Text('Export Video'),
              ),
            ],
          ),
        ],
      ),
      body: currentProject == null
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentColor,
              ),
            )
          : Column(
              children: [
                // Video Preview Area
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppTheme.primaryColor,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 64,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(height: AppConstants.defaultPadding),
                          Text(
                            'Video Preview',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: AppConstants.smallPadding),
                          Text(
                            'Import videos to start editing',
                            style: TextStyle(
                              color: AppTheme.textTertiary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Timeline Area
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppTheme.timelineBackground,
                    child: Column(
                      children: [
                        // Timeline Controls
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.defaultPadding,
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.play_arrow),
                                color: AppTheme.accentColor,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.pause),
                                color: AppTheme.textSecondary,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.stop),
                                color: AppTheme.textSecondary,
                              ),
                              const SizedBox(width: AppConstants.defaultPadding),
                              const Text(
                                '00:00 / 00:00',
                                style: AppTheme.timelineTimestamp,
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.zoom_in),
                                color: AppTheme.textSecondary,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.zoom_out),
                                color: AppTheme.textSecondary,
                              ),
                            ],
                          ),
                        ),
                        
                        // Timeline Tracks
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(AppConstants.smallPadding),
                            child: currentProject.clips.isEmpty &&
                                    currentProject.audioTracks.isEmpty
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.timeline,
                                          size: 48,
                                          color: AppTheme.textTertiary,
                                        ),
                                        SizedBox(height: AppConstants.smallPadding),
                                        Text(
                                          'Timeline is empty',
                                          style: TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Add videos or audio to get started',
                                          style: TextStyle(
                                            color: AppTheme.textTertiary,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView(
                                    children: [
                                      // Video tracks
                                      ...currentProject.clips.map((clip) {
                                        return Container(
                                          height: AppConstants.trackHeight,
                                          margin: const EdgeInsets.only(
                                            bottom: AppConstants.smallPadding,
                                          ),
                                          decoration: AppTheme.timelineClipDecoration,
                                          child: Center(
                                            child: Text(
                                              'Video Clip',
                                              style: AppTheme.clipLabel,
                                            ),
                                          ),
                                        );
                                      }),
                                      
                                      // Audio tracks
                                      ...currentProject.audioTracks.map((track) {
                                        return Container(
                                          height: AppConstants.trackHeight,
                                          margin: const EdgeInsets.only(
                                            bottom: AppConstants.smallPadding,
                                          ),
                                          decoration: AppTheme.audioClipDecoration,
                                          child: Center(
                                            child: Text(
                                              'Audio Track',
                                              style: AppTheme.clipLabel,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Tools Area
                Container(
                  height: 80,
                  color: AppTheme.surfaceColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                    ),
                    child: Row(
                      children: [
                        _buildToolButton(
                          icon: Icons.add,
                          label: 'Add Media',
                          onPressed: _addMedia,
                        ),
                        _buildToolButton(
                          icon: Icons.content_cut,
                          label: 'Split',
                          onPressed: () {},
                        ),
                        _buildToolButton(
                          icon: Icons.speed,
                          label: 'Speed',
                          onPressed: () {},
                        ),
                        _buildToolButton(
                          icon: Icons.volume_up,
                          label: 'Audio',
                          onPressed: () {},
                        ),
                        _buildToolButton(
                          icon: Icons.text_fields,
                          label: 'Text',
                          onPressed: () {},
                        ),
                        _buildToolButton(
                          icon: Icons.auto_fix_high,
                          label: 'Effects',
                          onPressed: () {},
                        ),
                        _buildToolButton(
                          icon: Icons.filter,
                          label: 'Filters',
                          onPressed: () {},
                        ),
                        _buildToolButton(
                          icon: Icons.transform,
                          label: 'Transitions',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            color: AppTheme.textSecondary,
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.timelineBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTheme.toolbarLabel,
          ),
        ],
      ),
    );
  }

  void _saveProject() async {
    try {
      await ref.read(currentProjectProvider.notifier).saveProject();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.successProjectSaved),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save project: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _exportProject() {
    context.push('/export/${widget.projectId}');
  }

  void _showProjectSettings() {
    // TODO: Implement project settings dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Project Settings'),
        content: const Text('Project settings coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _addMedia() {
    // TODO: Implement media import functionality
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Import from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement gallery import
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement video recording
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note),
              title: const Text('Add Music'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement music library
              },
            ),
          ],
        ),
      ),
    );
  }
}