import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/template.dart';
import '../../home/widgets/template_card.dart';
import '../../home/widgets/search_bar_widget.dart';

class TemplateBrowserScreen extends StatefulWidget {
  const TemplateBrowserScreen({super.key});

  @override
  State<TemplateBrowserScreen> createState() => _TemplateBrowserScreenState();
}

class _TemplateBrowserScreenState extends State<TemplateBrowserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
    );
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Templates'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement filter
            },
            icon: const Icon(Icons.tune),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: SearchBarWidget(
                  controller: _searchController,
                  onSearch: _handleSearch,
                  hintText: 'Search templates...',
                ),
              ),
              // Category Tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                tabs: _categories.map((category) => Tab(text: category)).toList(),
                onTap: (index) {
                  setState(() {
                    _selectedCategory = _categories[index];
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((category) => _buildTemplateGrid(category)).toList(),
      ),
    );
  }

  Widget _buildTemplateGrid(String category) {
    final templates = _getTemplatesForCategory(category);
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: AppConstants.smallPadding,
        crossAxisSpacing: AppConstants.smallPadding,
        itemCount: templates.length,
        itemBuilder: (context, index) {
          final template = templates[index];
          return TemplateCard(
            title: template['title'] as String,
            category: template['category'] as String,
            thumbnailUrl: template['thumbnail'] as String,
            isPremium: template['isPremium'] as bool,
            onTap: () => _useTemplate(template['id'] as String),
          );
        },
      ),
    );
  }

  void _handleSearch(String query) {
    // TODO: Implement search functionality
    debugPrint('Searching templates for: $query');
  }

  void _useTemplate(String templateId) {
    // TODO: Create design from template
    debugPrint('Using template: $templateId');
    Navigator.pop(context);
  }

  List<Map<String, dynamic>> _getTemplatesForCategory(String category) {
    if (category == 'All') {
      return _allTemplates;
    }
    return _allTemplates.where((template) => template['category'] == category).toList();
  }

  final List<String> _categories = [
    'All',
    'Social Media',
    'Marketing',
    'Business',
    'Personal',
    'Education',
    'Events',
  ];

  final List<Map<String, dynamic>> _allTemplates = [
    {
      'id': '1',
      'title': 'Modern Instagram Post',
      'category': 'Social Media',
      'thumbnail': 'https://via.placeholder.com/300x400',
      'isPremium': false,
    },
    {
      'id': '2',
      'title': 'Business Flyer',
      'category': 'Marketing',
      'thumbnail': 'https://via.placeholder.com/300x350',
      'isPremium': true,
    },
    {
      'id': '3',
      'title': 'Event Invitation',
      'category': 'Events',
      'thumbnail': 'https://via.placeholder.com/300x450',
      'isPremium': false,
    },
    {
      'id': '4',
      'title': 'Business Card',
      'category': 'Business',
      'thumbnail': 'https://via.placeholder.com/300x200',
      'isPremium': true,
    },
    {
      'id': '5',
      'title': 'Instagram Story',
      'category': 'Social Media',
      'thumbnail': 'https://via.placeholder.com/300x500',
      'isPremium': false,
    },
    {
      'id': '6',
      'title': 'Presentation Template',
      'category': 'Business',
      'thumbnail': 'https://via.placeholder.com/300x250',
      'isPremium': true,
    },
    {
      'id': '7',
      'title': 'Birthday Invitation',
      'category': 'Personal',
      'thumbnail': 'https://via.placeholder.com/300x400',
      'isPremium': false,
    },
    {
      'id': '8',
      'title': 'Educational Poster',
      'category': 'Education',
      'thumbnail': 'https://via.placeholder.com/300x350',
      'isPremium': true,
    },
    {
      'id': '9',
      'title': 'Facebook Cover',
      'category': 'Social Media',
      'thumbnail': 'https://via.placeholder.com/300x150',
      'isPremium': false,
    },
    {
      'id': '10',
      'title': 'Wedding Invitation',
      'category': 'Events',
      'thumbnail': 'https://via.placeholder.com/300x450',
      'isPremium': true,
    },
  ];
}