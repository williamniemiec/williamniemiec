import 'package:flutter/material.dart';
import '../../../shared/models/document.dart';
import '../../../core/theme/app_theme.dart';

class DocumentListItem extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final VoidCallback onMorePressed;

  const DocumentListItem({
    super.key,
    required this.document,
    required this.onTap,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            size: 24,
          ),
        ),
        title: Text(
          document.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              document.formattedLastModified,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
            ),
            if (document.isShared || document.isOfflineAvailable) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  if (document.isShared) ...[
                    Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Shared',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                  if (document.isShared && document.isOfflineAvailable)
                    const SizedBox(width: 12),
                  if (document.isOfflineAvailable) ...[
                    Icon(
                      Icons.offline_pin,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Offline',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMorePressed,
          color: AppTheme.secondaryTextColor,
        ),
        onTap: onTap,
      ),
    );
  }
}