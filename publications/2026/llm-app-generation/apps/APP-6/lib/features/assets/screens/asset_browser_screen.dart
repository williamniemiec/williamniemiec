import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/asset.dart';
import '../../home/widgets/search_bar_widget.dart';
import '../widgets/asset_card.dart';

class AssetBrowserScreen extends StatefulWidget {
  const AssetBrowserScreen({super.key});

  @override
  State<AssetBrowserScreen> createState() => _AssetBrowserScreenState();
}

class _AssetBrowserScreenState extends State<AssetBrowserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  AssetType _selectedType = AssetType.photo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _assetTypes.length,
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
        title: const Text('Assets'),
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
                  hintText: 'Search photos, graphics, icons...',
                ),
              ),
              // Asset Type Tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                tabs: _assetTypes.map((type) => Tab(
                  icon: Icon(type.icon, size: 20),
                  text: type.displayName,
                )).toList(),
                onTap: (index) {
                  setState(() {
                    _selectedType = _assetTypes[index];
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _assetTypes.map((type) => _buildAssetGrid(type)).toList(),
      ),
    );
  }

  Widget _buildAssetGrid(AssetType type) {
    final assets = _getAssetsForType(type);
    
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: type == AssetType.photo ? 2 : 3,
          childAspectRatio: type == AssetType.photo ? 0.8 : 1.0,
          crossAxisSpacing: AppConstants.smallPadding,
          mainAxisSpacing: AppConstants.smallPadding,
        ),
        itemCount: assets.length,
        itemBuilder: (context, index) {
          final asset = assets[index];
          return AssetCard(
            title: asset['title'] as String,
            thumbnailUrl: asset['thumbnail'] as String,
            type: type,
            isPremium: asset['isPremium'] as bool,
            onTap: () => _useAsset(asset['id'] as String),
          );
        },
      ),
    );
  }

  void _handleSearch(String query) {
    // TODO: Implement search functionality
    debugPrint('Searching assets for: $query');
  }

  void _useAsset(String assetId) {
    // TODO: Add asset to current design
    debugPrint('Using asset: $assetId');
    Navigator.pop(context);
  }

  List<Map<String, dynamic>> _getAssetsForType(AssetType type) {
    return _mockAssets[type] ?? [];
  }

  final List<AssetType> _assetTypes = [
    AssetType.photo,
    AssetType.graphic,
    AssetType.icon,
    AssetType.shape,
    AssetType.sticker,
  ];

  final Map<AssetType, List<Map<String, dynamic>>> _mockAssets = {
    AssetType.photo: [
      {
        'id': 'photo_1',
        'title': 'Nature Landscape',
        'thumbnail': 'https://via.placeholder.com/300x400',
        'isPremium': false,
      },
      {
        'id': 'photo_2',
        'title': 'Business Meeting',
        'thumbnail': 'https://via.placeholder.com/300x350',
        'isPremium': true,
      },
      {
        'id': 'photo_3',
        'title': 'Coffee Cup',
        'thumbnail': 'https://via.placeholder.com/300x450',
        'isPremium': false,
      },
      {
        'id': 'photo_4',
        'title': 'City Skyline',
        'thumbnail': 'https://via.placeholder.com/300x300',
        'isPremium': true,
      },
    ],
    AssetType.graphic: [
      {
        'id': 'graphic_1',
        'title': 'Abstract Shape',
        'thumbnail': 'https://via.placeholder.com/200x200',
        'isPremium': false,
      },
      {
        'id': 'graphic_2',
        'title': 'Geometric Pattern',
        'thumbnail': 'https://via.placeholder.com/200x200',
        'isPremium': true,
      },
      {
        'id': 'graphic_3',
        'title': 'Watercolor Splash',
        'thumbnail': 'https://via.placeholder.com/200x200',
        'isPremium': false,
      },
      {
        'id': 'graphic_4',
        'title': 'Line Art',
        'thumbnail': 'https://via.placeholder.com/200x200',
        'isPremium': true,
      },
    ],
    AssetType.icon: [
      {
        'id': 'icon_1',
        'title': 'Home Icon',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
      {
        'id': 'icon_2',
        'title': 'User Icon',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
      {
        'id': 'icon_3',
        'title': 'Heart Icon',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': true,
      },
      {
        'id': 'icon_4',
        'title': 'Star Icon',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
    ],
    AssetType.shape: [
      {
        'id': 'shape_1',
        'title': 'Circle',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
      {
        'id': 'shape_2',
        'title': 'Rectangle',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
      {
        'id': 'shape_3',
        'title': 'Triangle',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
      {
        'id': 'shape_4',
        'title': 'Arrow',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': true,
      },
    ],
    AssetType.sticker: [
      {
        'id': 'sticker_1',
        'title': 'Emoji Smile',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
      {
        'id': 'sticker_2',
        'title': 'Speech Bubble',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': true,
      },
      {
        'id': 'sticker_3',
        'title': 'Crown',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': true,
      },
      {
        'id': 'sticker_4',
        'title': 'Lightning',
        'thumbnail': 'https://via.placeholder.com/100x100',
        'isPremium': false,
      },
    ],
  };
}