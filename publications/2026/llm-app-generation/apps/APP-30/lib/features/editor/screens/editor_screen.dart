import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/document_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/document.dart' as doc_model;

class EditorScreen extends StatefulWidget {
  final String? documentId;
  final String? templateId;

  const EditorScreen({
    super.key,
    this.documentId,
    this.templateId,
  });

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  doc_model.Document? _currentDocument;
  bool _isLoading = true;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onContentChanged);
    _initializeDocument();
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _initializeDocument() async {
    final provider = context.read<DocumentProvider>();
    
    try {
      if (widget.documentId != null) {
        // Load existing document
        await provider.setCurrentDocument(widget.documentId!);
        _currentDocument = provider.currentDocument;
        
        if (_currentDocument != null) {
          // Load content into editor
          _controller.text = _currentDocument!.plainTextContent;
        }
      } else if (widget.templateId != null) {
        // Create document from template
        _currentDocument = await provider.createDocumentFromTemplate(widget.templateId!);
        
        // Load template content into editor
        _controller.text = _currentDocument!.plainTextContent;
      } else {
        // Create new blank document
        final documentId = await provider.createDocument(title: 'Untitled document');
        await provider.setCurrentDocument(documentId);
        _currentDocument = provider.currentDocument;
        _controller.text = '';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading document: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onContentChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
    
    // Auto-save after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _hasUnsavedChanges) {
        _autoSave();
      }
    });
  }

  void _autoSave() async {
    if (_currentDocument != null) {
      final updatedDocument = _currentDocument!.copyWith(
        content: _controller.text,
        lastModified: DateTime.now(),
      );
      
      await context.read<DocumentProvider>().updateDocument(updatedDocument);
      _currentDocument = updatedDocument;
      
      if (mounted) {
        setState(() {
          _hasUnsavedChanges = false;
        });
      }
    }
  }

  void _showRenameDialog() {
    if (_currentDocument == null) return;
    
    final titleController = TextEditingController(text: _currentDocument!.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename document'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Document name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newTitle = titleController.text.trim();
              if (newTitle.isNotEmpty && _currentDocument != null) {
                final updatedDocument = _currentDocument!.copyWith(title: newTitle);
                context.read<DocumentProvider>().updateDocument(updatedDocument);
                setState(() {
                  _currentDocument = updatedDocument;
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
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

    if (_currentDocument == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Document not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.documentBackgroundColor,
      appBar: AppBar(
        title: GestureDetector(
          onTap: _showRenameDialog,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _currentDocument!.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.edit, size: 16),
            ],
          ),
        ),
        backgroundColor: AppTheme.toolbarColor,
        actions: [
          if (_hasUnsavedChanges)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Saving...',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement sharing
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing feature coming soon')),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'rename':
                  _showRenameDialog();
                  break;
                case 'export':
                  // TODO: Implement export
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export feature coming soon')),
                  );
                  break;
                case 'delete':
                  _showDeleteConfirmation();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'rename',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Rename'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: Colors.red),
                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Simple formatting toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.toolbarColor,
              border: Border(
                bottom: BorderSide(color: AppTheme.dividerColor),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.format_bold),
                  onPressed: () {
                    // TODO: Implement bold formatting
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.format_italic),
                  onPressed: () {
                    // TODO: Implement italic formatting
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.format_underlined),
                  onPressed: () {
                    // TODO: Implement underline formatting
                  },
                ),
                const VerticalDivider(),
                IconButton(
                  icon: const Icon(Icons.format_list_bulleted),
                  onPressed: () {
                    // TODO: Implement bullet list
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.format_list_numbered),
                  onPressed: () {
                    // TODO: Implement numbered list
                  },
                ),
                const Spacer(),
                Text(
                  '${_controller.text.length} characters',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Document editor
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppTheme.primaryTextColor,
                ),
                decoration: const InputDecoration(
                  hintText: 'Start typing...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                autofocus: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    if (_currentDocument == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete document'),
        content: Text('Are you sure you want to delete "${_currentDocument!.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DocumentProvider>().deleteDocument(_currentDocument!.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close editor
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}