import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../screens/lens_screen.dart';

class LensResultsOverlay extends StatelessWidget {
  final List<LensResult> results;
  final String mode;
  final VoidCallback onClose;

  const LensResultsOverlay({
    super.key,
    required this.results,
    required this.mode,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: Stack(
        children: [
          // Bounding boxes overlay
          ...results.map((result) => _buildBoundingBox(result)),
          
          // Results bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.borderRadius),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.textTertiary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      children: [
                        Icon(
                          _getModeIcon(mode),
                          color: AppTheme.primaryBlue,
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Text(
                          '$mode Results',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                  
                  // Results list
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final result = results[index];
                        return _buildResultItem(context, result);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoundingBox(LensResult result) {
    return Positioned(
      left: result.boundingBox.left,
      top: result.boundingBox.top,
      width: result.boundingBox.width,
      height: result.boundingBox.height,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: _getResultColor(result.type),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getResultColor(result.type),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${(result.confidence * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(BuildContext context, LensResult result) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getResultColor(result.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getResultIcon(result.type),
            color: _getResultColor(result.type),
          ),
        ),
        title: Text(
          result.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(result.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.verified,
                  size: 16,
                  color: _getResultColor(result.type),
                ),
                const SizedBox(width: 4),
                Text(
                  '${(result.confidence * 100).toInt()}% confident',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _handleResultTap(context, result),
      ),
    );
  }

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'Search':
        return Icons.search;
      case 'Translate':
        return Icons.translate;
      case 'Text':
        return Icons.text_fields;
      case 'Homework':
        return Icons.school;
      case 'Shopping':
        return Icons.shopping_bag;
      default:
        return Icons.search;
    }
  }

  IconData _getResultIcon(LensResultType type) {
    switch (type) {
      case LensResultType.object:
        return Icons.category;
      case LensResultType.text:
        return Icons.text_fields;
      case LensResultType.translation:
        return Icons.translate;
      case LensResultType.product:
        return Icons.shopping_bag;
      case LensResultType.landmark:
        return Icons.location_on;
      case LensResultType.plant:
        return Icons.local_florist;
      case LensResultType.animal:
        return Icons.pets;
      default:
        return Icons.help;
    }
  }

  Color _getResultColor(LensResultType type) {
    switch (type) {
      case LensResultType.object:
        return AppTheme.primaryBlue;
      case LensResultType.text:
        return AppTheme.primaryGreen;
      case LensResultType.translation:
        return AppTheme.primaryRed;
      case LensResultType.product:
        return AppTheme.primaryYellow;
      case LensResultType.landmark:
        return AppTheme.primaryBlue;
      case LensResultType.plant:
        return AppTheme.primaryGreen;
      case LensResultType.animal:
        return Colors.orange;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _handleResultTap(BuildContext context, LensResult result) {
    switch (result.type) {
      case LensResultType.translation:
        _showTranslationDialog(context, result);
        break;
      case LensResultType.text:
        _showTextDialog(context, result);
        break;
      case LensResultType.product:
        _showProductDialog(context, result);
        break;
      default:
        _showGenericDialog(context, result);
    }
  }

  void _showTranslationDialog(BuildContext context, LensResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Translation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Original: "Sample text"'),
            const SizedBox(height: 8),
            Text('Translation: "${result.description}"'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Copy to clipboard
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _showTextDialog(BuildContext context, LensResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Recognition'),
        content: Text(result.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Copy to clipboard
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, LensResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shopping Results'),
        content: Text(result.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Open shopping results
            },
            child: const Text('View Products'),
          ),
        ],
      ),
    );
  }

  void _showGenericDialog(BuildContext context, LensResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(result.title),
        content: Text(result.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Search for more info
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}