import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/template.dart';
import '../widgets/design_format_card.dart';
import '../widgets/template_card.dart';
import '../widgets/recent_design_card.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0,
              title: Row(
                children: [
                  Text(
                    'Canva',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement notifications
                    },
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implement profile menu
                    },
                    icon: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: SearchBarWidget(
                  controller: _searchController,
                  onSearch: _handleSearch,
                ),
              ),
            ),

            // Create a Design Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a design',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _designFormats.length,
                        separatorBuilder: (context, index) => 
                            const SizedBox(width: AppConstants.smallPadding),
                        itemBuilder: (context, index) {
                          final format = _designFormats[index];
                          return DesignFormatCard(
                            title: format['title'] as String,
                            subtitle: format['subtitle'] as String,
                            icon: format['icon'] as IconData,
                            onTap: () => _createNewDesign(format['format'] as String),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppConstants.largePadding)),

            // Recent Designs Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent designs',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to all designs
                      },
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Designs Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _recentDesigns.length,
                    separatorBuilder: (context, index) => 
                        const SizedBox(width: AppConstants.smallPadding),
                    itemBuilder: (context, index) {
                      final design = _recentDesigns[index];
                      return RecentDesignCard(
                        title: design['title'] as String,
                        format: design['format'] as String,
                        thumbnailUrl: design['thumbnail'] as String?,
                        lastModified: design['lastModified'] as DateTime,
                        onTap: () => _openDesign(design['id'] as String),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppConstants.largePadding)),

            // Templates Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended templates',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/templates'),
                      child: const Text('Browse all'),
                    ),
                  ],
                ),
              ),
            ),

            // Templates Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
              ),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppConstants.smallPadding,
                crossAxisSpacing: AppConstants.smallPadding,
                childCount: _featuredTemplates.length,
                itemBuilder: (context, index) {
                  final template = _featuredTemplates[index];
                  return TemplateCard(
                    title: template['title'] as String,
                    category: template['category'] as String,
                    thumbnailUrl: template['thumbnail'] as String,
                    isPremium: template['isPremium'] as bool,
                    onTap: () => _useTemplate(template['id'] as String),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppConstants.largePadding)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateMenu(context),
        icon: const Icon(Icons.add),
        label: const Text('Create'),
      ),
    );
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      // TODO: Implement search functionality
      debugPrint('Searching for: $query');
    }
  }

  void _createNewDesign(String format) {
    context.push('/editor/new/$format');
  }

  void _openDesign(String designId) {
    context.push('/editor/$designId');
  }

  void _useTemplate(String templateId) {
    // TODO: Create design from template
    debugPrint('Using template: $templateId');
  }

  void _showCreateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Text(
                'What will you design today?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: AppConstants.smallPadding,
                  mainAxisSpacing: AppConstants.smallPadding,
                ),
                itemCount: _designFormats.length,
                itemBuilder: (context, index) {
                  final format = _designFormats[index];
                  return DesignFormatCard(
                    title: format['title'] as String,
                    subtitle: format['subtitle'] as String,
                    icon: format['icon'] as IconData,
                    onTap: () {
                      Navigator.pop(context);
                      _createNewDesign(format['format'] as String);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mock data
  final List<Map<String, dynamic>> _designFormats = [
    {
      'title': 'Instagram Post',
      'subtitle': '1080 × 1080 px',
      'icon': Icons.photo,
      'format': 'instagram_post',
    },
    {
      'title': 'Instagram Story',
      'subtitle': '1080 × 1920 px',
      'icon': Icons.photo_library,
      'format': 'instagram_story',
    },
    {
      'title': 'Presentation',
      'subtitle': '1920 × 1080 px',
      'icon': Icons.slideshow,
      'format': 'presentation',
    },
    {
      'title': 'Flyer',
      'subtitle': '2480 × 3508 px',
      'icon': Icons.description,
      'format': 'flyer',
    },
    {
      'title': 'Logo',
      'subtitle': '500 × 500 px',
      'icon': Icons.star,
      'format': 'logo',
    },
    {
      'title': 'Business Card',
      'subtitle': '1050 × 600 px',
      'icon': Icons.credit_card,
      'format': 'business_card',
    },
  ];

  final List<Map<String, dynamic>> _recentDesigns = [
    {
      'id': '1',
      'title': 'Summer Sale Flyer',
      'format': 'Flyer',
      'thumbnail': null,
      'lastModified': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'title': 'Instagram Post',
      'format': 'Social Media',
      'thumbnail': null,
      'lastModified': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '3',
      'title': 'Business Presentation',
      'format': 'Presentation',
      'thumbnail': null,
      'lastModified': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  final List<Map<String, dynamic>> _featuredTemplates = [
    {
      'id': '1',
      'title': 'Modern Business Card',
      'category': 'Business',
      'thumbnail': 'https://via.placeholder.com/300x200',
      'isPremium': false,
    },
    {
      'id': '2',
      'title': 'Social Media Post',
      'category': 'Social Media',
      'thumbnail': 'https://via.placeholder.com/300x400',
      'isPremium': true,
    },
    {
      'id': '3',
      'title': 'Event Flyer',
      'category': 'Marketing',
      'thumbnail': 'https://via.placeholder.com/300x350',
      'isPremium': false,
    },
    {
      'id': '4',
      'title': 'Presentation Template',
      'category': 'Business',
      'thumbnail': 'https://via.placeholder.com/300x250',
      'isPremium': true,
    },
  ];
}