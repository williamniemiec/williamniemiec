import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/health_article.dart';

class ArticleCard extends StatelessWidget {
  final HealthArticle article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumSpacing),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category and read time
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.smallSpacing,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(article.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(article.category),
                          size: 16,
                          color: _getCategoryColor(article.category),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          article.category.displayName,
                          style: TextStyle(
                            color: _getCategoryColor(article.category),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article.readTimeMinutes} min',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.mediumSpacing),
              
              // Article title
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              
              // Article summary
              Text(
                article.summary,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Tags if available
              if (article.tags.isNotEmpty) ...[
                const SizedBox(height: AppConstants.mediumSpacing),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: article.tags.take(3).map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  )).toList(),
                ),
              ],
              
              // Read more indicator
              const SizedBox(height: AppConstants.smallSpacing),
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Read more',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(ArticleCategory category) {
    switch (category) {
      case ArticleCategory.bloodPressure:
        return Colors.red[400]!;
      case ArticleCategory.diet:
        return Colors.green[400]!;
      case ArticleCategory.exercise:
        return Colors.blue[400]!;
      case ArticleCategory.lifestyle:
        return Colors.purple[400]!;
      case ArticleCategory.medication:
        return Colors.orange[400]!;
      case ArticleCategory.general:
        return Colors.teal[400]!;
    }
  }

  IconData _getCategoryIcon(ArticleCategory category) {
    switch (category) {
      case ArticleCategory.bloodPressure:
        return Icons.favorite;
      case ArticleCategory.diet:
        return Icons.restaurant;
      case ArticleCategory.exercise:
        return Icons.fitness_center;
      case ArticleCategory.lifestyle:
        return Icons.self_improvement;
      case ArticleCategory.medication:
        return Icons.medication;
      case ArticleCategory.general:
        return Icons.health_and_safety;
    }
  }
}