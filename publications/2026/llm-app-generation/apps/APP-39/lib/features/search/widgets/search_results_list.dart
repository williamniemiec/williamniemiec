import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/search_result.dart';
import '../../../shared/services/search_service.dart';
import 'ai_overview_card.dart';

class SearchResultsList extends StatefulWidget {
  final List<SearchResult> results;
  final String query;
  final bool showAIOverview;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.query,
    this.showAIOverview = false,
  });

  @override
  State<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
  String? _aiOverview;
  bool _isLoadingAI = false;

  @override
  void initState() {
    super.initState();
    if (widget.showAIOverview && widget.query.isNotEmpty) {
      _loadAIOverview();
    }
  }

  @override
  void didUpdateWidget(SearchResultsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showAIOverview && 
        widget.query != oldWidget.query && 
        widget.query.isNotEmpty) {
      _loadAIOverview();
    }
  }

  Future<void> _loadAIOverview() async {
    setState(() {
      _isLoadingAI = true;
    });

    try {
      final overview = await SearchService().getAIOverview(widget.query);
      if (mounted) {
        setState(() {
          _aiOverview = overview;
          _isLoadingAI = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingAI = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      itemCount: _getItemCount(),
      itemBuilder: (context, index) {
        // AI Overview Card
        if (widget.showAIOverview && index == 0) {
          if (_isLoadingAI) {
            return const AIOverviewCard(
              isLoading: true,
            );
          } else if (_aiOverview != null) {
            return AIOverviewCard(
              overview: _aiOverview!,
              query: widget.query,
            );
          }
          return const SizedBox.shrink();
        }

        // Search Results
        final resultIndex = widget.showAIOverview ? index - 1 : index;
        if (resultIndex >= widget.results.length) return null;

        final result = widget.results[resultIndex];
        return SearchResultCard(
          result: result,
          onTap: () => _openResult(result),
        );
      },
    );
  }

  int _getItemCount() {
    int count = widget.results.length;
    if (widget.showAIOverview) {
      count += 1; // For AI overview
    }
    return count;
  }

  void _openResult(SearchResult result) async {
    final uri = Uri.parse(result.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class SearchResultCard extends StatelessWidget {
  final SearchResult result;
  final VoidCallback onTap;

  const SearchResultCard({
    super.key,
    required this.result,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // URL and Favicon
              Row(
                children: [
                  if (result.favicon != null)
                    CachedNetworkImage(
                      imageUrl: result.favicon!,
                      width: 16,
                      height: 16,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.public,
                        size: 16,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  if (result.favicon != null)
                    const SizedBox(width: AppConstants.smallPadding),
                  Expanded(
                    child: Text(
                      _formatUrl(result.url),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Result type indicator
                  if (result.type != SearchResultType.web)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.smallPadding,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(result.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        result.type.name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getTypeColor(result.type),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.smallPadding),

              // Title
              Text(
                result.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppConstants.smallPadding),

              // Description
              Text(
                result.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              // Thumbnail for videos/images
              if (result.thumbnail != null) ...[
                const SizedBox(height: AppConstants.defaultPadding),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  child: CachedNetworkImage(
                    imageUrl: result.thumbnail!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 120,
                      color: AppTheme.surfaceColor,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 120,
                      color: AppTheme.surfaceColor,
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url;
    }
  }

  Color _getTypeColor(SearchResultType type) {
    switch (type) {
      case SearchResultType.image:
        return AppTheme.primaryGreen;
      case SearchResultType.video:
        return AppTheme.primaryRed;
      case SearchResultType.news:
        return AppTheme.primaryBlue;
      case SearchResultType.shopping:
        return AppTheme.primaryYellow;
      case SearchResultType.maps:
        return AppTheme.primaryGreen;
      default:
        return AppTheme.textSecondary;
    }
  }
}