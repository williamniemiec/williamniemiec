import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/restaurant.dart';
import '../../../shared/models/user.dart';
import '../../auth/providers/auth_provider.dart';
import '../../location/providers/location_provider.dart';
import '../widgets/address_selector.dart';
import '../widgets/category_grid.dart';
import '../widgets/promotional_banner.dart';
import '../widgets/restaurant_carousel.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Restaurant> _restaurants = [];
  List<Restaurant> _featuredRestaurants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simulate loading restaurants data
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _restaurants = _getMockRestaurants();
      _featuredRestaurants = _restaurants.where((r) => r.rating >= 4.5).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar with Address
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                expandedHeight: 120,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                    child: const AddressSelector(),
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.borderGrey),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: AppTheme.textGrey,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Buscar no iFood',
                            style: TextStyle(
                              color: AppTheme.textGrey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Categories
              const SliverToBoxAdapter(
                child: CategoryGrid(),
              ),

              // Promotional Banner
              const SliverToBoxAdapter(
                child: PromotionalBanner(),
              ),

              // Featured Restaurants Carousel
              if (_featuredRestaurants.isNotEmpty)
                SliverToBoxAdapter(
                  child: RestaurantCarousel(
                    title: 'Famosos no iFood',
                    restaurants: _featuredRestaurants,
                  ),
                ),

              // Super Deals Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: RestaurantCarousel(
                    title: 'Super Ofertas',
                    restaurants: _restaurants.where((r) => r.promotions.isNotEmpty).toList(),
                  ),
                ),
              ),

              // All Restaurants Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        'Todos os restaurantes',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => context.push('/search'),
                        child: const Text('Ver todos'),
                      ),
                    ],
                  ),
                ),
              ),

              // All Restaurants List
              if (_isLoading)
                const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final restaurant = _restaurants[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: RestaurantCard(
                          restaurant: restaurant,
                          onTap: () => context.push('/restaurant/${restaurant.id}'),
                        ),
                      );
                    },
                    childCount: _restaurants.length,
                  ),
                ),

              // Bottom padding for floating action button
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Restaurant> _getMockRestaurants() {
    return [
      Restaurant(
        id: '1',
        name: 'McDonald\'s',
        description: 'Lanche, Hambúrguer',
        imageUrl: 'https://via.placeholder.com/300x200',
        logoUrl: 'https://via.placeholder.com/80x80',
        categories: ['Lanche', 'Hambúrguer'],
        rating: 4.5,
        reviewCount: 1250,
        deliveryTime: 25,
        deliveryFee: 3.99,
        minimumOrder: 15.00,
        isOpen: true,
        address: 'Rua Augusta, 123',
        latitude: -23.5505,
        longitude: -46.6333,
        paymentMethods: ['Cartão', 'PIX', 'Dinheiro'],
        promotions: ['Frete Grátis'],
      ),
      Restaurant(
        id: '2',
        name: 'Burger King',
        description: 'Lanche, Hambúrguer',
        imageUrl: 'https://via.placeholder.com/300x200',
        logoUrl: 'https://via.placeholder.com/80x80',
        categories: ['Lanche', 'Hambúrguer'],
        rating: 4.3,
        reviewCount: 890,
        deliveryTime: 30,
        deliveryFee: 4.99,
        minimumOrder: 20.00,
        isOpen: true,
        address: 'Av. Paulista, 456',
        latitude: -23.5615,
        longitude: -46.6565,
        paymentMethods: ['Cartão', 'PIX'],
        promotions: [],
      ),
      Restaurant(
        id: '3',
        name: 'Pizza Hut',
        description: 'Pizza, Italiana',
        imageUrl: 'https://via.placeholder.com/300x200',
        logoUrl: 'https://via.placeholder.com/80x80',
        categories: ['Pizza', 'Italiana'],
        rating: 4.7,
        reviewCount: 2100,
        deliveryTime: 35,
        deliveryFee: 0.0,
        minimumOrder: 25.00,
        isOpen: true,
        address: 'Rua Oscar Freire, 789',
        latitude: -23.5629,
        longitude: -46.6544,
        paymentMethods: ['Cartão', 'PIX', 'Vale-Refeição'],
        promotions: ['20% OFF'],
      ),
      Restaurant(
        id: '4',
        name: 'Subway',
        description: 'Sanduíche, Saudável',
        imageUrl: 'https://via.placeholder.com/300x200',
        logoUrl: 'https://via.placeholder.com/80x80',
        categories: ['Sanduíche', 'Saudável'],
        rating: 4.4,
        reviewCount: 650,
        deliveryTime: 20,
        deliveryFee: 2.99,
        minimumOrder: 12.00,
        isOpen: true,
        address: 'Rua da Consolação, 321',
        latitude: -23.5558,
        longitude: -46.6396,
        paymentMethods: ['Cartão', 'PIX'],
        promotions: [],
      ),
      Restaurant(
        id: '5',
        name: 'Outback Steakhouse',
        description: 'Carnes, Australiana',
        imageUrl: 'https://via.placeholder.com/300x200',
        logoUrl: 'https://via.placeholder.com/80x80',
        categories: ['Carnes', 'Australiana'],
        rating: 4.8,
        reviewCount: 1800,
        deliveryTime: 45,
        deliveryFee: 6.99,
        minimumOrder: 40.00,
        isOpen: true,
        address: 'Shopping Iguatemi',
        latitude: -23.5505,
        longitude: -46.6333,
        paymentMethods: ['Cartão', 'PIX', 'Vale-Refeição'],
        promotions: ['Combo Especial'],
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}