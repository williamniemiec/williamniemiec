import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/restaurant.dart';
import '../../home/widgets/restaurant_card.dart';
import '../widgets/search_filters.dart';
import '../widgets/category_chips.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<Restaurant> _allRestaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  String _selectedCategory = '';
  String _searchQuery = '';
  bool _isLoading = true;
  
  // Filter options
  bool _freeDelivery = false;
  bool _promotions = false;
  double _maxDeliveryTime = 60;
  double _minRating = 0;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
    _searchFocusNode.requestFocus();
  }

  Future<void> _loadRestaurants() async {
    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _allRestaurants = _getMockRestaurants();
      _filteredRestaurants = _allRestaurants;
      _isLoading = false;
    });
  }

  void _filterRestaurants() {
    setState(() {
      _filteredRestaurants = _allRestaurants.where((restaurant) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!restaurant.name.toLowerCase().contains(query) &&
              !restaurant.categories.any((cat) => cat.toLowerCase().contains(query))) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategory.isNotEmpty) {
          if (!restaurant.categories.contains(_selectedCategory)) {
            return false;
          }
        }

        // Free delivery filter
        if (_freeDelivery && restaurant.deliveryFee > 0) {
          return false;
        }

        // Promotions filter
        if (_promotions && restaurant.promotions.isEmpty) {
          return false;
        }

        // Delivery time filter
        if (restaurant.deliveryTime > _maxDeliveryTime) {
          return false;
        }

        // Rating filter
        if (restaurant.rating < _minRating) {
          return false;
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: 40,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: InputDecoration(
              hintText: 'Buscar restaurantes, pratos...',
              hintStyle: TextStyle(color: AppTheme.textGrey),
              prefixIcon: Icon(Icons.search, color: AppTheme.textGrey),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: AppTheme.textGrey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                        _filterRestaurants();
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppTheme.backgroundGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              _filterRestaurants();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFiltersBottomSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Chips
          CategoryChips(
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              _filterRestaurants();
            },
          ),

          // Active Filters
          if (_hasActiveFilters()) _buildActiveFilters(),

          // Results
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredRestaurants.isEmpty
                    ? _buildEmptyState()
                    : _buildRestaurantsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (_freeDelivery) _buildFilterChip('Frete Grátis', () {
              setState(() => _freeDelivery = false);
              _filterRestaurants();
            }),
            if (_promotions) _buildFilterChip('Promoções', () {
              setState(() => _promotions = false);
              _filterRestaurants();
            }),
            if (_minRating > 0) _buildFilterChip('${_minRating.toInt()}+ estrelas', () {
              setState(() => _minRating = 0);
              _filterRestaurants();
            }),
            if (_maxDeliveryTime < 60) _buildFilterChip('Até ${_maxDeliveryTime.toInt()}min', () {
              setState(() => _maxDeliveryTime = 60);
              _filterRestaurants();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: AppTheme.primaryRed.withOpacity(0.1),
        labelStyle: const TextStyle(
          color: AppTheme.primaryRed,
          fontSize: 12,
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
            Icons.search_off,
            size: 64,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum resultado encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente buscar por outro termo ou\najustar os filtros',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredRestaurants.length,
      itemBuilder: (context, index) {
        final restaurant = _filteredRestaurants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RestaurantCard(
            restaurant: restaurant,
            onTap: () => context.push('/restaurant/${restaurant.id}'),
          ),
        );
      },
    );
  }

  bool _hasActiveFilters() {
    return _freeDelivery || _promotions || _minRating > 0 || _maxDeliveryTime < 60;
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SearchFilters(
        freeDelivery: _freeDelivery,
        promotions: _promotions,
        maxDeliveryTime: _maxDeliveryTime,
        minRating: _minRating,
        onFiltersChanged: (freeDelivery, promotions, maxDeliveryTime, minRating) {
          setState(() {
            _freeDelivery = freeDelivery;
            _promotions = promotions;
            _maxDeliveryTime = maxDeliveryTime;
            _minRating = minRating;
          });
          _filterRestaurants();
        },
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
      // Add more mock restaurants...
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}