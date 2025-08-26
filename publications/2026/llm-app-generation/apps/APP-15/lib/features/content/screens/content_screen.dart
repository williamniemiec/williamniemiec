import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/content.dart';
import '../widgets/content_filter_bar.dart';
import '../widgets/content_grid_item.dart';
import '../providers/content_provider.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  ContentCategory? _selectedCategory;
  DifficultyLevel? _selectedDifficulty;
  String? _selectedPartner;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ContentProvider>(context, listen: false).loadContent();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabBar(),
            _buildFilterBar(),
            Expanded(
              child: _buildContentGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fitness Content',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover workouts, recipes, and wellness content',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.tune),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppStrings.searchContent,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
        ),
        onChanged: _performSearch,
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: AppTheme.textOnPrimary,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: const [
          Tab(text: AppStrings.allContent),
          Tab(text: AppStrings.videos),
          Tab(text: AppStrings.audio),
          Tab(text: AppStrings.articles),
        ],
        onTap: _onTabChanged,
      ),
    );
  }

  Widget _buildFilterBar() {
    return ContentFilterBar(
      selectedCategory: _selectedCategory,
      selectedDifficulty: _selectedDifficulty,
      selectedPartner: _selectedPartner,
      onCategoryChanged: (category) {
        setState(() {
          _selectedCategory = category;
        });
        _applyFilters();
      },
      onDifficultyChanged: (difficulty) {
        setState(() {
          _selectedDifficulty = difficulty;
        });
        _applyFilters();
      },
      onPartnerChanged: (partner) {
        setState(() {
          _selectedPartner = partner;
        });
        _applyFilters();
      },
      onClearFilters: () {
        setState(() {
          _selectedCategory = null;
          _selectedDifficulty = null;
          _selectedPartner = null;
        });
        _applyFilters();
      },
    );
  }

  Widget _buildContentGrid() {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        if (contentProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (contentProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: 16),
                Text(
                  contentProvider.errorMessage!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => contentProvider.loadContent(),
                  child: const Text(AppStrings.retry),
                ),
              ],
            ),
          );
        }

        final content = contentProvider.filteredContent;

        if (content.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppTheme.textLight,
                ),
                const SizedBox(height: 16),
                Text(
                  AppStrings.noContentFound,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => contentProvider.loadContent(),
          child: GridView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: content.length,
            itemBuilder: (context, index) {
              return ContentGridItem(
                content: content[index],
                onTap: () => _navigateToContentDetail(content[index]),
              );
            },
          ),
        );
      },
    );
  }

  void _performSearch(String query) {
    Provider.of<ContentProvider>(context, listen: false).searchContent(query);
  }

  void _onTabChanged(int index) {
    ContentType? type;
    switch (index) {
      case 0:
        type = null; // All content
        break;
      case 1:
        type = ContentType.video;
        break;
      case 2:
        type = ContentType.audio;
        break;
      case 3:
        type = ContentType.article;
        break;
    }
    
    Provider.of<ContentProvider>(context, listen: false).filterByType(type);
  }

  void _applyFilters() {
    Provider.of<ContentProvider>(context, listen: false).applyFilters(
      category: _selectedCategory,
      difficulty: _selectedDifficulty,
      partner: _selectedPartner,
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(
        selectedCategory: _selectedCategory,
        selectedDifficulty: _selectedDifficulty,
        selectedPartner: _selectedPartner,
        onApply: (category, difficulty, partner) {
          setState(() {
            _selectedCategory = category;
            _selectedDifficulty = difficulty;
            _selectedPartner = partner;
          });
          _applyFilters();
        },
      ),
    );
  }

  void _navigateToContentDetail(Content content) {
    // Navigate to content detail screen
    // This will be implemented when we create the content detail screen
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final ContentCategory? selectedCategory;
  final DifficultyLevel? selectedDifficulty;
  final String? selectedPartner;
  final Function(ContentCategory?, DifficultyLevel?, String?) onApply;

  const _FilterBottomSheet({
    required this.selectedCategory,
    required this.selectedDifficulty,
    required this.selectedPartner,
    required this.onApply,
  });

  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  ContentCategory? _category;
  DifficultyLevel? _difficulty;
  String? _partner;

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
    _difficulty = widget.selectedDifficulty;
    _partner = widget.selectedPartner;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Content',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _category = null;
                    _difficulty = null;
                    _partner = null;
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCategoryFilter(),
          const SizedBox(height: 24),
          _buildDifficultyFilter(),
          const SizedBox(height: 24),
          _buildPartnerFilter(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_category, _difficulty, _partner);
                Navigator.of(context).pop();
              },
              child: const Text('Apply Filters'),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.category,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ContentCategory.values.map((category) {
            final isSelected = _category == category;
            return FilterChip(
              label: Text(category.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _category = selected ? category : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDifficultyFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.difficulty,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: DifficultyLevel.values.map((difficulty) {
            final isSelected = _difficulty == difficulty;
            return FilterChip(
              label: Text(difficulty.name.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _difficulty = selected ? difficulty : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPartnerFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.partner,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.contentPartners.map((partner) {
            final isSelected = _partner == partner;
            return FilterChip(
              label: Text(partner),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _partner = selected ? partner : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}