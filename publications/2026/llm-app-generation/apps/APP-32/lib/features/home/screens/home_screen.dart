import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers/product_provider.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/providers/wishlist_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/product.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/flash_sale_banner.dart';
import '../widgets/home_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar
          const HomeAppBar(),
          
          // Main Content
          SliverToBoxAdapter(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flash Sale Banner
                    if (productProvider.flashSaleProducts.isNotEmpty)
                      const FlashSaleBanner(),
                    
                    // Promotional Banners
                    _buildPromotionalBanners(),
                    
                    const SizedBox(height: 16),
                    
                    // Categories
                    _buildCategoriesSection(),
                    
                    const SizedBox(height: 24),
                    
                    // New Arrivals
                    if (productProvider.newArrivals.isNotEmpty)
                      _buildProductSection(
                        title: 'New Arrivals',
                        products: productProvider.newArrivals,
                        onSeeAll: () => context.go('/shop?filter=new'),
                      ),
                    
                    // Trending Now
                    if (productProvider.trendingProducts.isNotEmpty)
                      _buildProductSection(
                        title: 'Trending Now',
                        products: productProvider.trendingProducts,
                        onSeeAll: () => context.go('/shop?filter=trending'),
                      ),
                    
                    // Featured Products
                    if (productProvider.featuredProducts.isNotEmpty)
                      _buildProductSection(
                        title: 'Featured',
                        products: productProvider.featuredProducts,
                        onSeeAll: () => context.go('/shop?filter=featured'),
                      ),
                    
                    // Flash Sale Products
                    if (productProvider.flashSaleProducts.isNotEmpty)
                      _buildProductSection(
                        title: 'Flash Sale',
                        products: productProvider.flashSaleProducts,
                        onSeeAll: () => context.go('/shop?filter=flash'),
                        isFlashSale: true,
                      ),
                    
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBanners() {
    final banners = [
      {
        'image': 'https://via.placeholder.com/800x300/FF69B4/FFFFFF?text=Summer+Sale+50%+OFF',
        'title': 'Summer Sale',
        'subtitle': 'Up to 50% OFF',
      },
      {
        'image': 'https://via.placeholder.com/800x300/87CEEB/FFFFFF?text=New+Collection',
        'title': 'New Collection',
        'subtitle': 'Fresh styles just in',
      },
      {
        'image': 'https://via.placeholder.com/800x300/FFD93D/000000?text=Free+Shipping',
        'title': 'Free Shipping',
        'subtitle': 'On orders over \$35',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 180,
      child: PageView.builder(
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: banner['image']!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.borderColor,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.borderColor,
                      child: const Icon(Icons.error),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          banner['subtitle']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Shop by Category',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.mainCategories.length,
            itemBuilder: (context, index) {
              final category = AppConstants.mainCategories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CategoryChip(
                  label: category,
                  onTap: () => context.go('/shop?category=$category'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductSection({
    required String title,
    required List<Product> products,
    required VoidCallback onSeeAll,
    bool isFlashSale = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isFlashSale ? AppTheme.accentColor : null,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 160,
                  child: ProductCard(
                    product: product,
                    onTap: () => context.go('/product/${product.id}'),
                    showFlashSaleTimer: isFlashSale,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}