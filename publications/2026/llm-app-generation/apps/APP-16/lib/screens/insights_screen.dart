import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/health_article.dart';
import '../services/database_service.dart';
import '../widgets/article_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  List<HealthArticle> _articles = [];
  List<HealthArticle> _filteredArticles = [];
  ArticleCategory? _selectedCategory;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final articles = await DatabaseService().getAllHealthArticles();
      setState(() {
        _articles = articles;
        _filteredArticles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load articles: $e';
        _isLoading = false;
      });
    }
  }

  void _filterArticles(ArticleCategory? category) {
    setState(() {
      _selectedCategory = category;
      if (category == null) {
        _filteredArticles = _articles;
      } else {
        _filteredArticles = _articles.where((article) => article.category == category).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Insights'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadArticles,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          _buildCategoryFilter(),
          
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing),
      child: Row(
        children: [
          Text(
            'Category:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // All categories chip
                  Padding(
                    padding: const EdgeInsets.only(right: AppConstants.smallSpacing),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: _selectedCategory == null,
                      onSelected: (selected) {
                        if (selected) {
                          _filterArticles(null);
                        }
                      },
                    ),
                  ),
                  // Individual category chips
                  ...ArticleCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppConstants.smallSpacing),
                      child: FilterChip(
                        label: Text(category.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            _filterArticles(category);
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_filteredArticles.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadArticles,
      child: Column(
        children: [
          // Health tip of the day
          _buildHealthTipOfTheDay(),
          
          // Articles list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.mediumSpacing),
              itemCount: _filteredArticles.length,
              itemBuilder: (context, index) {
                final article = _filteredArticles[index];
                return ArticleCard(
                  article: article,
                  onTap: () => _showArticleDetail(article),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTipOfTheDay() {
    // Get a random tip or the first article
    final tipArticle = _articles.isNotEmpty ? _articles.first : null;
    
    if (tipArticle == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(AppConstants.mediumSpacing),
      child: Card(
        color: Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.blue[700],
                    size: AppConstants.mediumIconSize,
                  ),
                  const SizedBox(width: AppConstants.smallSpacing),
                  Text(
                    'Health Tip of the Day',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              Text(
                tipArticle.summary,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppConstants.smallSpacing),
              TextButton(
                onPressed: () => _showArticleDetail(tipArticle),
                child: const Text('Read More'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          Text(
            'No articles found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            _selectedCategory != null
                ? 'No articles in this category'
                : 'No health articles available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          Text(
            'Error loading articles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          ElevatedButton(
            onPressed: _loadArticles,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showArticleDetail(HealthArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.mediumBorderRadius),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(AppConstants.mediumSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.mediumSpacing),
                
                // Article header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.smallSpacing,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                      ),
                      child: Text(
                        article.category.displayName,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${article.readTimeMinutes} min read',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.smallSpacing),
                
                // Article title
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.smallSpacing),
                
                // Article summary
                Text(
                  article.summary,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: AppConstants.mediumSpacing),
                
                // Article content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      article.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                
                // Tags if available
                if (article.tags.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.mediumSpacing),
                  Wrap(
                    spacing: AppConstants.smallSpacing,
                    runSpacing: 4,
                    children: article.tags.map((tag) => Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.grey[100],
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}