import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/product.dart';
import '../../../shared/services/mock_data_service.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/lightning_deals_carousel.dart';
import '../widgets/product_grid.dart';
import '../widgets/flash_sale_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      final products = MockDataService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProducts,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar with Search
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: AppTheme.primaryColor,
                elevation: 0,
                title: Row(
                  children: [
                    Expanded(
                      child: SearchBarWidget(
                        onSearch: (query) {
                          // Navigate to search results
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsScreen(query: query),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                      onPressed: () {
                        // Implement image search
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image search coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Content
              SliverList(
                delegate: SliverChildListDelegate([
                  // Flash Sale Banner
                  const FlashSaleBanner(),
                  
                  // Promotional Banners
                  const PromotionalBanner(),
                  
                  const SizedBox(height: 16),
                  
                  // Lightning Deals Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '⚡ Lightning Deals',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  LightningDealsCarousel(products: _products.take(10).toList()),
                  
                  const SizedBox(height: 24),
                  
                  // For You Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.favorite, color: AppTheme.primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'For You',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Product Grid
                  if (_isLoading)
                    const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    )
                  else
                    ProductGrid(products: _products),
                  
                  const SizedBox(height: 100), // Bottom padding for navigation bar
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Placeholder for search results screen
class SearchResultsScreen extends StatelessWidget {
  final String query;
  
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search: $query'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Search results will be implemented here'),
      ),
    );
  }
}