import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/project_provider.dart';
import '../../../shared/models/video_project.dart';

class CreateProjectDialog extends ConsumerStatefulWidget {
  const CreateProjectDialog({super.key});

  @override
  ConsumerState<CreateProjectDialog> createState() => _CreateProjectDialogState();
}

class _CreateProjectDialogState extends ConsumerState<CreateProjectDialog> {
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  String _selectedAspectRatio = '9:16';
  String _selectedResolution = '1080p';
  int _selectedFrameRate = 30;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Project'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                hintText: 'Enter project name',
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Aspect Ratio Selection
            Text(
              'Aspect Ratio',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Wrap(
              spacing: AppConstants.smallPadding,
              children: AppConstants.aspectRatios.map((ratio) {
                final isSelected = ratio == _selectedAspectRatio;
                return FilterChip(
                  label: Text(ratio),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedAspectRatio = ratio;
                      });
                    }
                  },
                  selectedColor: AppTheme.accentColor.withOpacity(0.3),
                  checkmarkColor: AppTheme.accentColor,
                );
              }).toList(),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Resolution Selection
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
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Frame Rate Selection
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
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Quick Start Options
            Text(
              'Quick Start',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isCreating ? null : _importFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Import Videos'),
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isCreating ? null : _recordVideo,
                    icon: const Icon(Icons.videocam),
                    label: const Text('Record Video'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createProject,
          child: _isCreating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryColor,
                  ),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createProject() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a project name'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      // Get resolution dimensions
      final resolutionData = AppConstants.resolutionDimensions[_selectedResolution];
      if (resolutionData == null) {
        throw Exception('Invalid resolution selected');
      }

      // Create project settings
      final settings = ProjectSettings(
        width: resolutionData['width']!,
        height: resolutionData['height']!,
        frameRate: _selectedFrameRate,
        aspectRatio: _selectedAspectRatio,
        quality: _selectedResolution,
      );

      // Create the project
      await ref.read(currentProjectProvider.notifier).createProject(
        name,
        settings: settings,
      );

      // Get the created project
      final project = ref.read(currentProjectProvider);
      if (project != null) {
        // Refresh project lists
        ref.invalidate(allProjectsProvider);
        ref.invalidate(recentProjectsProvider);

        // Close dialog and navigate to editor
        if (mounted) {
          Navigator.of(context).pop();
          context.push('/editor/${project.id}');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create project: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  Future<void> _importFromGallery() async {
    try {
      final List<XFile> files = await _imagePicker.pickMultipleMedia();
      if (files.isNotEmpty) {
        // Create project first
        await _createProject();
        
        // TODO: Add the selected files to the project
        // This would be implemented in the editor screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import media: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _recordVideo() async {
    try {
      final XFile? file = await _imagePicker.pickVideo(
        source: ImageSource.camera,
      );
      if (file != null) {
        // Create project first
        await _createProject();
        
        // TODO: Add the recorded video to the project
        // This would be implemented in the editor screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to record video: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}