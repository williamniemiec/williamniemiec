import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/project_provider.dart';

class ExportScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ExportScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends ConsumerState<ExportScreen> {
  String _selectedFormat = 'MP4';
  String _selectedResolution = '1080p';
  int _selectedFrameRate = 30;
  int _selectedBitrate = 5000;
  bool _isExporting = false;
  double _exportProgress = 0.0;

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
        title: const Text('Export Video'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: currentProject == null
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.accentColor,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project: ${currentProject.name}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.smallPadding),
                          Text(
                            'Duration: ${_formatDuration(currentProject.duration)}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Text(
                            'Clips: ${currentProject.clips.length}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Export Settings
                  Text(
                    'Export Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Format Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Format',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.smallPadding),
                          DropdownButtonFormField<String>(
                            value: _selectedFormat,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.exportFormats.map((format) {
                              return DropdownMenuItem(
                                value: format,
                                child: Text(format),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedFormat = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Resolution Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resolution',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.smallPadding),
                          DropdownButtonFormField<String>(
                            value: _selectedResolution,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.resolutions.map((resolution) {
                              return DropdownMenuItem(
                                value: resolution,
                                child: Text(resolution),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedResolution = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Frame Rate Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Frame Rate',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.smallPadding),
                          DropdownButtonFormField<int>(
                            value: _selectedFrameRate,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.frameRates.map((frameRate) {
                              return DropdownMenuItem(
                                value: frameRate,
                                child: Text('${frameRate} fps'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedFrameRate = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Bitrate Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bitrate',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppConstants.smallPadding),
                          DropdownButtonFormField<int>(
                            value: _selectedBitrate,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.exportBitrates.map((bitrate) {
                              return DropdownMenuItem(
                                value: bitrate,
                                child: Text('${bitrate} kbps'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedBitrate = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),

                  // Export Progress
                  if (_isExporting) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exporting...',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppConstants.smallPadding),
                            LinearProgressIndicator(
                              value: _exportProgress,
                              backgroundColor: AppTheme.textTertiary,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.accentColor,
                              ),
                            ),
                            const SizedBox(height: AppConstants.smallPadding),
                            Text(
                              '${(_exportProgress * 100).toInt()}% complete',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                  ],

                  // Export Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isExporting ? null : _startExport,
                      icon: _isExporting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryColor,
                              ),
                            )
                          : const Icon(Icons.file_download),
                      label: Text(_isExporting ? 'Exporting...' : 'Export Video'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _startExport() async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    setState(() {
      _isExporting = true;
      _exportProgress = 0.0;
    });

    try {
      // Simulate export progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          setState(() {
            _exportProgress = i / 100;
          });
        }
      }

      // TODO: Implement actual video export using VideoService
      // final videoService = ref.read(videoServiceProvider);
      // final outputPath = await videoService.exportProject(
      //   project: currentProject,
      //   outputPath: 'path/to/output.mp4',
      //   onProgress: (progress) {
      //     if (mounted) {
      //       setState(() {
      //         _exportProgress = progress;
      //       });
      //     }
      //   },
      // );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.successProjectExported),
            backgroundColor: AppTheme.successColor,
          ),
        );
        
        // Show export complete dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Complete'),
            content: const Text('Your video has been exported successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pop(); // Go back to editor
                },
                child: const Text('Done'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Open file location or share
                },
                child: const Text('Share'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
          _exportProgress = 0.0;
        });
      }
    }
  }
}