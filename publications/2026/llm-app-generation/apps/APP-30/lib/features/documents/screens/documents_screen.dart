import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/document_provider.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/document.dart';
import '../widgets/document_list_item.dart';
import '../widgets/create_document_fab.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Google Docs'),
        backgroundColor: AppTheme.toolbarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => AppRouter.goToSearch(context),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Implement user profile
            },
          ),
        ],
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.documents.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadDocuments(),
            child: CustomScrollView(
              slivers: [
                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () => AppRouter.goToSearch(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.dividerColor),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: AppTheme.hintTextColor,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Search in Docs',
                              style: TextStyle(
                                color: AppTheme.hintTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Recent documents section
                if (provider.recentDocuments.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Recent',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final document = provider.recentDocuments[index];
                        return DocumentListItem(
                          document: document,
                          onTap: () => _openDocument(context, document.id),
                          onMorePressed: () => _showDocumentOptions(context, document),
                        );
                      },
                      childCount: provider.recentDocuments.length,
                    ),
                  ),
                ],

                // All documents section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                    child: Text(
                      'All Documents',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final document = provider.documents[index];
                      return DocumentListItem(
                        document: document,
                        onTap: () => _openDocument(context, document.id),
                        onMorePressed: () => _showDocumentOptions(context, document),
                      );
                    },
                    childCount: provider.documents.length,
                  ),
                ),

                // Bottom padding for FAB
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: const CreateDocumentFab(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64,
            color: AppTheme.hintTextColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No documents yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first document to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.hintTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateOptions(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Document'),
          ),
        ],
      ),
    );
  }

  void _openDocument(BuildContext context, String documentId) {
    AppRouter.goToEditor(context, documentId: documentId);
  }

  void _showDocumentOptions(BuildContext context, Document document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Rename'),
            onTap: () {
              Navigator.pop(context);
              _showRenameDialog(context, document);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              AppRouter.goToSharing(context, document.id);
            },
          ),
          ListTile(
            leading: Icon(
              document.isOfflineAvailable 
                ? Icons.cloud_done 
                : Icons.offline_pin,
            ),
            title: Text(
              document.isOfflineAvailable 
                ? 'Remove from offline' 
                : 'Make available offline',
            ),
            onTap: () {
              Navigator.pop(context);
              _toggleOfflineAvailability(context, document);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context, document);
            },
          ),
        ],
      ),
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('New document'),
            onTap: () {
              Navigator.pop(context);
              _createNewDocument(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Choose template'),
            onTap: () {
              Navigator.pop(context);
              AppRouter.goToTemplates(context);
            },
          ),
        ],
      ),
    );
  }

  void _createNewDocument(BuildContext context) async {
    final provider = context.read<DocumentProvider>();
    try {
      final documentId = await provider.createDocument(title: 'Untitled document');
      if (mounted) {
        AppRouter.goToEditor(context, documentId: documentId);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating document: $e')),
        );
      }
    }
  }

  void _showRenameDialog(BuildContext context, Document document) {
    final controller = TextEditingController(text: document.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename document'),
        content: TextField(
          controller: controller,
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
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                final updatedDocument = document.copyWith(title: newTitle);
                context.read<DocumentProvider>().updateDocument(updatedDocument);
              }
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _toggleOfflineAvailability(BuildContext context, Document document) {
    final provider = context.read<DocumentProvider>();
    if (document.isOfflineAvailable) {
      provider.removeDocumentFromOffline(document.id);
    } else {
      provider.makeDocumentOfflineAvailable(document.id);
    }
  }

  void _showDeleteConfirmation(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete document'),
        content: Text('Are you sure you want to delete "${document.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DocumentProvider>().deleteDocument(document.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}