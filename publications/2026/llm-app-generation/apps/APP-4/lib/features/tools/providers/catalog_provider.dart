import 'package:flutter/foundation.dart';
import '../../../shared/models/catalog.dart';

class CatalogProvider extends ChangeNotifier {
  List<CatalogItem> _catalogItems = [];
  bool _isLoading = false;
  String? _error;

  List<CatalogItem> get catalogItems => _catalogItems;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCatalogItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load sample catalog items
      _catalogItems = _getSampleCatalogItems();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCatalogItem(CatalogItem item) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      _catalogItems.add(item);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCatalogItem(CatalogItem item) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final index = _catalogItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _catalogItems[index] = item.copyWith(updatedAt: DateTime.now());
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCatalogItem(String itemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      _catalogItems.removeWhere((item) => item.id == itemId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<CatalogItem> getCatalogItemsByCategory(String category) {
    return _catalogItems.where((item) => item.category == category).toList();
  }

  List<String> getCategories() {
    final categories = _catalogItems.map((item) => item.category).toSet().toList();
    categories.sort();
    return categories;
  }

  List<CatalogItem> searchCatalogItems(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _catalogItems.where((item) {
      return item.name.toLowerCase().contains(lowercaseQuery) ||
             item.description.toLowerCase().contains(lowercaseQuery) ||
             item.category.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<CatalogItem> _getSampleCatalogItems() {
    final now = DateTime.now();
    return [
      CatalogItem(
        id: 'item_1',
        name: 'Premium Coffee Beans',
        description: 'High-quality arabica coffee beans, freshly roasted',
        price: 24.99,
        currency: 'USD',
        productCode: 'COFFEE001',
        imageUrls: ['https://example.com/coffee1.jpg'],
        category: 'Food & Beverage',
        isAvailable: true,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      CatalogItem(
        id: 'item_2',
        name: 'Organic Green Tea',
        description: 'Premium organic green tea leaves from mountain regions',
        price: 18.50,
        currency: 'USD',
        productCode: 'TEA001',
        imageUrls: ['https://example.com/tea1.jpg'],
        category: 'Food & Beverage',
        isAvailable: true,
        createdAt: now.subtract(const Duration(days: 8)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      CatalogItem(
        id: 'item_3',
        name: 'Handmade Ceramic Mug',
        description: 'Beautiful handcrafted ceramic mug, perfect for coffee or tea',
        price: 32.00,
        currency: 'USD',
        productCode: 'MUG001',
        imageUrls: ['https://example.com/mug1.jpg'],
        category: 'Home & Garden',
        isAvailable: true,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(hours: 12)),
      ),
      CatalogItem(
        id: 'item_4',
        name: 'Business Consultation',
        description: '1-hour business strategy consultation session',
        price: 150.00,
        currency: 'USD',
        productCode: 'CONSULT001',
        imageUrls: [],
        category: 'Professional Services',
        isAvailable: true,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now.subtract(const Duration(hours: 6)),
      ),
    ];
  }
}