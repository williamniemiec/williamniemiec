import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/document_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/document.dart';

class SharingScreen extends StatefulWidget {
  final String documentId;

  const SharingScreen({
    super.key,
    required this.documentId,
  });

  @override
  State<SharingScreen> createState() => _SharingScreenState();
}

class _SharingScreenState extends State<SharingScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _selectedPermission = AppConstants.editorPermission;
  Document? _document;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadDocument() async {
    final provider = context.read<DocumentProvider>();
    _document = provider.getDocumentById(widget.documentId);
    
    if (_document == null) {
      await provider.setCurrentDocument(widget.documentId);
      _document = provider.currentDocument;
    }
    
    setState(() {
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

    if (_document == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Share'),
        ),
        body: const Center(
          child: Text('Document not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Share'),
        backgroundColor: AppTheme.toolbarColor,
        actions: [
          TextButton(
            onPressed: _shareDocument,
            child: const Text('Send'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Document info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.description,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _document!.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Last modified ${_document!.formattedLastModified}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Add people section
            Text(
              'Add people or groups',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Email input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter email addresses',
                prefixIcon: Icon(Icons.person_add),
              ),
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16),

            // Permission selector
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Permission level',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedPermission,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPermission = value;
                      });
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: AppConstants.viewerPermission,
                      child: Row(
                        children: [
                          const Icon(Icons.visibility, size: 16),
                          const SizedBox(width: 8),
                          const Text('Viewer'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: AppConstants.commenterPermission,
                      child: Row(
                        children: [
                          const Icon(Icons.comment, size: 16),
                          const SizedBox(width: 8),
                          const Text('Commenter'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: AppConstants.editorPermission,
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 16),
                          const SizedBox(width: 8),
                          const Text('Editor'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Current collaborators
            if (_document!.collaborators.isNotEmpty) ...[
              Text(
                'People with access',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              Card(
                child: Column(
                  children: [
                    // Owner
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: const Text('You (Owner)'),
                      subtitle: Text(_document!.ownerId),
                      trailing: const Text('Owner'),
                    ),
                    
                    // Collaborators
                    ..._document!.collaborators.map((email) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, color: Colors.grey[600]),
                      ),
                      title: Text(email),
                      subtitle: const Text('Editor'), // TODO: Get actual permission
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'remove') {
                            _removeCollaborator(email);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'remove',
                            child: Text('Remove access'),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
            ],

            // General access
            Text(
              'General access',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.link),
                    title: const Text('Anyone with the link'),
                    subtitle: const Text('Anyone on the internet with the link can view'),
                    trailing: Switch(
                      value: false, // TODO: Implement link sharing
                      onChanged: (value) {
                        // TODO: Toggle link sharing
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('Restricted'),
                    subtitle: const Text('Only people with access can open with the link'),
                    trailing: Radio<bool>(
                      value: true,
                      groupValue: true, // TODO: Get actual setting
                      onChanged: (value) {
                        // TODO: Set access restriction
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareDocument() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email address')),
      );
      return;
    }

    // TODO: Implement actual sharing logic
    context.read<DocumentProvider>().shareDocument(
      widget.documentId,
      [email],
      _selectedPermission,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Shared with $email')),
    );

    _emailController.clear();
  }

  void _removeCollaborator(String email) {
    // TODO: Implement remove collaborator logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed access for $email')),
    );
  }
}