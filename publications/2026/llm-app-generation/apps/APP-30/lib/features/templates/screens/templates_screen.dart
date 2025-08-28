import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/document_provider.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/template.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Choose template'),
        backgroundColor: AppTheme.toolbarColor,
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final categories = ['All', ...AppConstants.templateCategories];
          final filteredTemplates = _selectedCategory == 'All'
              ? provider.templates
              : provider.templates
                  .where((template) => template.category == _selectedCategory)
                  .toList();

          return Column(
            children: [
              // Category filter
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.primaryColor,
                      ),
                    );
                  },
                ),
              ),

              // Templates grid
              Expanded(
                child: filteredTemplates.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredTemplates.length,
                        itemBuilder: (context, index) {
                          final template = filteredTemplates[index];
                          return _buildTemplateCard(template);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
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
            'No templates found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try selecting a different category',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.hintTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(DocumentTemplate template) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _useTemplate(template),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTemplateColor(template.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTemplateIcon(template.category),
                  color: _getTemplateColor(template.category),
                  size: 24,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Template name
              Text(
                template.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // Template description
              Expanded(
                child: Text(
                  template.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTemplateColor(template.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  template.category,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getTemplateColor(template.category),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTemplateIcon(String category) {
    switch (category) {
      case 'Resume':
        return Icons.person;
      case 'Letter':
        return Icons.mail;
      case 'Report':
        return Icons.assessment;
      case 'Proposal':
        return Icons.business;
      case 'Invoice':
        return Icons.receipt;
      case 'Meeting Notes':
        return Icons.event_note;
      case 'Project Plan':
        return Icons.timeline;
      case 'Blank Document':
      default:
        return Icons.description;
    }
  }

  Color _getTemplateColor(String category) {
    switch (category) {
      case 'Resume':
        return Colors.blue;
      case 'Letter':
        return Colors.green;
      case 'Report':
        return Colors.orange;
      case 'Proposal':
        return Colors.purple;
      case 'Invoice':
        return Colors.red;
      case 'Meeting Notes':
        return Colors.teal;
      case 'Project Plan':
        return Colors.indigo;
      case 'Blank Document':
      default:
        return AppTheme.primaryColor;
    }
  }

  void _useTemplate(DocumentTemplate template) async {
    final provider = context.read<DocumentProvider>();
    
    try {
      final document = await provider.createDocumentFromTemplate(template.id);
      if (mounted) {
        AppRouter.goToEditor(context, documentId: document.id);
      }
    } catch (e) {
      if (mounted) {
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