import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/document_provider.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/theme/app_theme.dart';

class CreateDocumentFab extends StatelessWidget {
  const CreateDocumentFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateOptions(context),
      backgroundColor: AppTheme.primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
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
              title: const Text('New document'),
              subtitle: const Text('Create a blank document'),
              onTap: () {
                Navigator.pop(context);
                _createNewDocument(context);
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Colors.orange,
                ),
              ),
              title: const Text('Choose template'),
              subtitle: const Text('Start with a template'),
              onTap: () {
                Navigator.pop(context);
                AppRouter.goToTemplates(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _createNewDocument(BuildContext context) async {
    final provider = context.read<DocumentProvider>();
    try {
      final documentId = await provider.createDocument(title: 'Untitled document');
      if (context.mounted) {
        AppRouter.goToEditor(context, documentId: documentId);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}