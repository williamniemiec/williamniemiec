import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/design.dart';

class EditorScreen extends StatefulWidget {
  final String? designId;
  final String? format;

  const EditorScreen({
    super.key,
    this.designId,
  }) : format = null;

  const EditorScreen.newDesign({
    super.key,
    required this.format,
  }) : designId = null;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  bool _isLoading = true;
  Design? _currentDesign;

  @override
  void initState() {
    super.initState();
    _initializeEditor();
  }

  Future<void> _initializeEditor() async {
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
      // TODO: Load actual design or create new one
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        title: Text(
          widget.designId != null ? 'Edit Design' : 'New ${widget.format ?? 'Design'}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _undoAction,
            icon: const Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _redoAction,
            icon: const Icon(Icons.redo),
          ),
          IconButton(
            onPressed: _shareDesign,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        children: [
          // Canvas Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: Stack(
                  children: [
                    // Canvas background
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                    ),
                    // Placeholder content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.design_services,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Canvas Area',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Drag and drop elements here',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Toolbar
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToolButton(
                  icon: Icons.dashboard,
                  label: 'Templates',
                  onTap: _showTemplates,
                ),
                _buildToolButton(
                  icon: Icons.image,
                  label: 'Elements',
                  onTap: _showElements,
                ),
                _buildToolButton(
                  icon: Icons.text_fields,
                  label: 'Text',
                  onTap: _addText,
                ),
                _buildToolButton(
                  icon: Icons.photo_library,
                  label: 'Uploads',
                  onTap: _showUploads,
                ),
                _buildToolButton(
                  icon: Icons.auto_fix_high,
                  label: 'Magic',
                  onTap: _showMagicTools,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _undoAction() {
    // TODO: Implement undo functionality
    debugPrint('Undo action');
  }

  void _redoAction() {
    // TODO: Implement redo functionality
    debugPrint('Redo action');
  }

  void _shareDesign() {
    // TODO: Implement share functionality
    debugPrint('Share design');
  }

  void _showTemplates() {
    // TODO: Show templates panel
    debugPrint('Show templates');
  }

  void _showElements() {
    // TODO: Show elements panel
    debugPrint('Show elements');
  }

  void _addText() {
    // TODO: Add text element
    debugPrint('Add text');
  }

  void _showUploads() {
    // TODO: Show uploads panel
    debugPrint('Show uploads');
  }

  void _showMagicTools() {
    // TODO: Show magic tools panel
    debugPrint('Show magic tools');
  }
}