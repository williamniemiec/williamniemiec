import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class AIOverviewCard extends StatefulWidget {
  final String? overview;
  final String? query;
  final bool isLoading;

  const AIOverviewCard({
    super.key,
    this.overview,
    this.query,
    this.isLoading = false,
  });

  @override
  State<AIOverviewCard> createState() => _AIOverviewCardState();
}

class _AIOverviewCardState extends State<AIOverviewCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingCard();
    }

    if (widget.overview == null || widget.overview!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  'AI Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showInfoDialog(context),
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedCrossFade(
                  firstChild: Text(
                    widget.overview!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondChild: Text(
                    widget.overview!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: AppConstants.shortAnimation,
                ),
                
                if (widget.overview!.length > 150) ...[
                  const SizedBox(height: AppConstants.smallPadding),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Show less' : 'Show more',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Text(
                  'Generative AI is experimental.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _showFeedbackDialog(context, true),
                      icon: const Icon(
                        Icons.thumb_up_outlined,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      tooltip: 'Good response',
                    ),
                    IconButton(
                      onPressed: () => _showFeedbackDialog(context, false),
                      icon: const Icon(
                        Icons.thumb_down_outlined,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      tooltip: 'Poor response',
                    ),
                    IconButton(
                      onPressed: () => _shareOverview(),
                      icon: const Icon(
                        Icons.share,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      tooltip: 'Share',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  'AI Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Loading shimmer
            Shimmer.fromColors(
              baseColor: AppTheme.textTertiary.withOpacity(0.3),
              highlightColor: AppTheme.textTertiary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            Text(
              'Generating AI overview...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About AI Overview'),
        content: const Text(
          'AI Overview provides AI-generated summaries of information from across the web. '
          'These responses are experimental and may not always be accurate. '
          'Always verify important information from reliable sources.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context, bool isPositive) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPositive ? 'Good response?' : 'Poor response?'),
        content: Text(
          isPositive
              ? 'Thanks for your feedback! This helps us improve AI Overview.'
              : 'Thanks for your feedback. What could be improved about this response?',
        ),
        actions: [
          if (!isPositive)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Skip'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isPositive ? 'You\'re welcome' : 'Send feedback'),
          ),
        ],
      ),
    );
  }

  void _shareOverview() {
    // In a real app, you would use share_plus package
    // Share.share('AI Overview: ${widget.overview}');
  }
}