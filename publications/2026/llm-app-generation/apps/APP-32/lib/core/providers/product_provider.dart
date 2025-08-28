import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../shared/models/product.dart';
import '../constants/app_constants.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<Product> _trendingProducts = [];
  List<Product> _newArrivals = [];
  List<Product> _flashSaleProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get trendingProducts => _trendingProducts;
  List<Product> get newArrivals => _newArrivals;
  List<Product> get flashSaleProducts => _flashSaleProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProductProvider() {
    _loadProductsFromStorage();
    _generateMockProducts();
  }

  // Load products from storage
  Future<void> _loadProductsFromStorage() async {
    try {
      final productsBox = Hive.box('products');
      final productsData = productsBox.get('all_products');
      
      if (productsData != null) {
        final List<dynamic> productsList = productsData;
        _products = productsList
            .map((product) => Product.fromJson(Map<String, dynamic>.from(product)))
            .toList();
        _categorizeProducts();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading products from storage: $e');
    }
  }

  // Save products to storage
  Future<void> _saveProductsToStorage() async {
    try {
      final productsBox = Hive.box('products');
      final productsData = _products.map((product) => product.toJson()).toList();
      await productsBox.put('all_products', productsData);
    } catch (e) {
      debugPrint('Error saving products to storage: $e');
    }
  }

  // Generate mock products for demo
  void _generateMockProducts() {
    if (_products.isNotEmpty) return;

    final mockProducts = <Product>[
      // Women's Dresses
      Product(
        id: '1',
        name: 'Floral Summer Dress',
        description: 'Beautiful floral print dress perfect for summer occasions',
        price: 29.99,
        originalPrice: 49.99,
        images: ['https://via.placeholder.com/400x600/FF69B4/FFFFFF?text=Floral+Dress'],
        category: 'Women',
        subCategory: 'Dresses',
        availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
        availableColors: ['Pink', 'Blue', 'White'],
        rating: 4.5,
        reviewCount: 128,
        isOnSale: true,
        discountPercentage: 40,
        brand: 'SHEIN',
        material: '100% Polyester',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
        isFeatured: true,
        isTrending: true,
        stockQuantity: 50,
      ),
      Product(
        id: '2',
        name: 'Casual T-Shirt',
        description: 'Comfortable cotton t-shirt for everyday wear',
        price: 12.99,
        images: ['https://via.placeholder.com/400x600/87CEEB/FFFFFF?text=T-Shirt'],
        category: 'Women',
        subCategory: 'Tops',
        availableSizes: ['XS', 'S', 'M', 'L', 'XL'],
        availableColors: ['White', 'Black', 'Gray', 'Pink'],
        rating: 4.2,
        reviewCount: 89,
        brand: 'SHEIN',
        material: '100% Cotton',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
        isNewArrival: true,
        stockQuantity: 100,
      ),
      Product(
        id: '3',
        name: 'Denim Jeans',
        description: 'Classic high-waisted denim jeans',
        price: 39.99,
        originalPrice: 59.99,
        images: ['https://via.placeholder.com/400x600/4169E1/FFFFFF?text=Denim+Jeans'],
        category: 'Women',
        subCategory: 'Bottoms',
        availableSizes: ['24', '26', '28', '30', '32'],
        availableColors: ['Blue', 'Black', 'Light Blue'],
        rating: 4.7,
        reviewCount: 203,
        isOnSale: true,
        discountPercentage: 33,
        brand: 'SHEIN',
        material: '98% Cotton, 2% Elastane',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now(),
        isFeatured: true,
        stockQuantity: 75,
      ),
      Product(
        id: '4',
        name: 'Flash Sale Sneakers',
        description: 'Trendy sneakers at an amazing flash sale price',
        price: 24.99,
        originalPrice: 79.99,
        images: ['https://via.placeholder.com/400x600/FF6347/FFFFFF?text=Sneakers'],
        category: 'Shoes',
        subCategory: 'Sneakers',
        availableSizes: ['5', '6', '7', '8', '9', '10'],
        availableColors: ['White', 'Black', 'Pink'],
        rating: 4.3,
        reviewCount: 156,
        isFlashSale: true,
        flashSaleEndTime: DateTime.now().add(const Duration(hours: 2)),
        discountPercentage: 69,
        brand: 'SHEIN',
        material: 'Synthetic',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
        stockQuantity: 30,
      ),
      Product(
        id: '5',
        name: 'Cozy Sweater',
        description: 'Warm and comfortable sweater for cold days',
        price: 34.99,
        images: ['https://via.placeholder.com/400x600/DDA0DD/FFFFFF?text=Sweater'],
        category: 'Women',
        subCategory: 'Outerwear',
        availableSizes: ['S', 'M', 'L', 'XL'],
        availableColors: ['Beige', 'Gray', 'Pink', 'Brown'],
        rating: 4.6,
        reviewCount: 94,
        brand: 'SHEIN',
        material: '60% Acrylic, 40% Cotton',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
        isTrending: true,
        stockQuantity: 60,
      ),
    ];

    _products = mockProducts;
    _categorizeProducts();
    _saveProductsToStorage();
    notifyListeners();
  }

  // Categorize products
  void _categorizeProducts() {
    _featuredProducts = _products.where((p) => p.isFeatured).toList();
    _trendingProducts = _products.where((p) => p.isTrending).toList();
    _newArrivals = _products.where((p) => p.isNewArrival).toList();
    _flashSaleProducts = _products.where((p) => p.isFlashSale).toList();
  }

  // Fetch products (simulate API call)
  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would fetch from API
      _generateMockProducts();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch products';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    final lowercaseQuery = query.toLowerCase();
    return _products.where((product) =>
        product.name.toLowerCase().contains(lowercaseQuery) ||
        product.description.toLowerCase().contains(lowercaseQuery) ||
        product.category.toLowerCase().contains(lowercaseQuery) ||
        product.subCategory.toLowerCase().contains(lowercaseQuery) ||
        product.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))
    ).toList();
  }

  // Filter products
  List<Product> filterProducts({
    String? category,
    String? subCategory,
    double? minPrice,
    double? maxPrice,
    List<String>? colors,
    List<String>? sizes,
    double? minRating,
    bool? isOnSale,
    String? sortBy,
  }) {
    var filteredProducts = List<Product>.from(_products);

    // Apply filters
    if (category != null) {
      filteredProducts = filteredProducts.where((p) => p.category == category).toList();
    }
    
    if (subCategory != null) {
      filteredProducts = filteredProducts.where((p) => p.subCategory == subCategory).toList();
    }
    
    if (minPrice != null) {
      filteredProducts = filteredProducts.where((p) => p.price >= minPrice).toList();
    }
    
    if (maxPrice != null) {
      filteredProducts = filteredProducts.where((p) => p.price <= maxPrice).toList();
    }
    
    if (colors != null && colors.isNotEmpty) {
      filteredProducts = filteredProducts.where((p) =>
          p.availableColors.any((color) => colors.contains(color))
      ).toList();
    }
    
    if (sizes != null && sizes.isNotEmpty) {
      filteredProducts = filteredProducts.where((p) =>
          p.availableSizes.any((size) => sizes.contains(size))
      ).toList();
    }
    
    if (minRating != null) {
      filteredProducts = filteredProducts.where((p) => p.rating >= minRating).toList();
    }
    
    if (isOnSale == true) {
      filteredProducts = filteredProducts.where((p) => p.isOnSale).toList();
    }

    // Apply sorting
    if (sortBy != null) {
      switch (sortBy) {
        case 'Price: Low to High':
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'Price: High to Low':
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Newest':
          filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case 'Best Selling':
          filteredProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
          break;
        case 'Customer Rating':
          filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        default: // Recommended
          break;
      }
    }

    return filteredProducts;
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  // Get related products
  List<Product> getRelatedProducts(String productId, {int limit = 4}) {
    final product = getProductById(productId);
    if (product == null) return [];

    return _products
        .where((p) => 
            p.id != productId && 
            (p.category == product.category || p.subCategory == product.subCategory))
        .take(limit)
        .toList();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}