import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../constants/app_constants.dart';
import '../models/subscription.dart';
import '../models/user.dart';
import 'storage_service.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final StorageService _storageService = StorageService();
  
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  
  // Product IDs
  static const Set<String> _productIds = {
    AppConstants.weeklySubscriptionId,
    AppConstants.monthlySubscriptionId,
    AppConstants.lifetimeSubscriptionId,
  };

  List<ProductDetails> _products = [];
  Subscription? _currentSubscription;

  // Getters
  List<ProductDetails> get products => _products;
  Subscription? get currentSubscription => _currentSubscription;
  bool get isPremium => _currentSubscription?.isPremium ?? false;

  Future<void> initialize() async {
    try {
      // Check if in-app purchases are available
      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        debugPrint('In-app purchases not available');
        return;
      }

      // Load current subscription from storage
      _currentSubscription = await _storageService.getSubscription();
      
      // If no subscription exists, create a free one
      if (_currentSubscription == null) {
        _currentSubscription = Subscription.createFree();
        await _storageService.saveSubscription(_currentSubscription!);
      }

      // Load available products
      await _loadProducts();

      // Listen to purchase updates
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) {
          debugPrint('Purchase stream error: $error');
        },
      );

      // Restore previous purchases
      await _restorePurchases();

      debugPrint('SubscriptionService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing SubscriptionService: $e');
    }
  }

  Future<void> _loadProducts() async {
    try {
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found: ${response.notFoundIDs}');
      }

      _products = response.productDetails;
      debugPrint('Loaded ${_products.length} products');
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  Future<bool> purchaseSubscription(String productId) async {
    try {
      ProductDetails? product;
      try {
        product = _products.firstWhere((p) => p.id == productId);
      } catch (e) {
        throw Exception('Product not found: $productId');
      }

      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      
      bool success;
      if (productId == AppConstants.lifetimeSubscriptionId) {
        success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        success = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }

      debugPrint('Purchase initiated for $productId: $success');
      return success;
    } catch (e) {
      debugPrint('Error purchasing subscription: $e');
      throw SubscriptionException('Failed to purchase subscription: ${e.toString()}');
    }
  }

  Future<void> _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      await _handlePurchaseUpdate(purchaseDetails);
    }
  }

  Future<void> _handlePurchaseUpdate(PurchaseDetails purchaseDetails) async {
    try {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          debugPrint('Purchase pending: ${purchaseDetails.productID}');
          break;
          
        case PurchaseStatus.purchased:
          debugPrint('Purchase successful: ${purchaseDetails.productID}');
          await _processPurchase(purchaseDetails);
          break;
          
        case PurchaseStatus.error:
          debugPrint('Purchase error: ${purchaseDetails.error}');
          break;
          
        case PurchaseStatus.restored:
          debugPrint('Purchase restored: ${purchaseDetails.productID}');
          await _processPurchase(purchaseDetails);
          break;
          
        case PurchaseStatus.canceled:
          debugPrint('Purchase canceled: ${purchaseDetails.productID}');
          break;
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    } catch (e) {
      debugPrint('Error handling purchase update: $e');
    }
  }

  Future<void> _processPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final String productId = purchaseDetails.productID;
      final SubscriptionType type = _getSubscriptionType(productId);
      
      DateTime? endDate;
      if (type == SubscriptionType.weekly) {
        endDate = DateTime.now().add(const Duration(days: 7));
      } else if (type == SubscriptionType.monthly) {
        endDate = DateTime.now().add(const Duration(days: 30));
      }
      // Lifetime has no end date

      final subscription = Subscription(
        id: purchaseDetails.purchaseID ?? DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        status: SubscriptionStatus.active,
        startDate: DateTime.now(),
        endDate: endDate,
        productId: productId,
        transactionId: purchaseDetails.purchaseID,
        price: _getProductPrice(productId),
        currency: 'USD', // This should come from the product details
      );

      _currentSubscription = subscription;
      await _storageService.saveSubscription(subscription);
      
      debugPrint('Subscription processed successfully: ${subscription.displayName}');
    } catch (e) {
      debugPrint('Error processing purchase: $e');
      throw SubscriptionException('Failed to process purchase');
    }
  }

  SubscriptionType _getSubscriptionType(String productId) {
    switch (productId) {
      case AppConstants.weeklySubscriptionId:
        return SubscriptionType.weekly;
      case AppConstants.monthlySubscriptionId:
        return SubscriptionType.monthly;
      case AppConstants.lifetimeSubscriptionId:
        return SubscriptionType.lifetime;
      default:
        return SubscriptionType.free;
    }
  }

  double? _getProductPrice(String productId) {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      return double.tryParse(product.price.replaceAll(RegExp(r'[^\d.]'), ''));
    } catch (e) {
      return null;
    }
  }

  Future<void> _restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
      debugPrint('Purchases restored');
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  // Usage limit checking
  bool canUseFeature(String featureType) {
    if (isPremium) return true;

    final dailyUsage = _storageService.getDailyUsageCount(featureType);
    
    switch (featureType) {
      case 'chatAnalysis':
        return dailyUsage < AppConstants.dailyFreeAnalyses;
      case 'profileRoast':
        return dailyUsage < AppConstants.dailyFreeRoasts;
      case 'bioGenerator':
        return dailyUsage < AppConstants.dailyFreeBios;
      case 'rizzGenerator':
        return dailyUsage < AppConstants.dailyFreeRizz;
      default:
        return false;
    }
  }

  int getRemainingUsage(String featureType) {
    if (isPremium) return -1; // Unlimited

    final dailyUsage = _storageService.getDailyUsageCount(featureType);
    
    switch (featureType) {
      case 'chatAnalysis':
        return (AppConstants.dailyFreeAnalyses - dailyUsage).clamp(0, AppConstants.dailyFreeAnalyses);
      case 'profileRoast':
        return (AppConstants.dailyFreeRoasts - dailyUsage).clamp(0, AppConstants.dailyFreeRoasts);
      case 'bioGenerator':
        return (AppConstants.dailyFreeBios - dailyUsage).clamp(0, AppConstants.dailyFreeBios);
      case 'rizzGenerator':
        return (AppConstants.dailyFreeRizz - dailyUsage).clamp(0, AppConstants.dailyFreeRizz);
      default:
        return 0;
    }
  }

  Future<void> recordFeatureUsage(String featureType) async {
    await _storageService.incrementDailyUsage(featureType);
    await _storageService.incrementUsageCount(featureType);
  }

  // Subscription management
  Future<void> cancelSubscription() async {
    try {
      if (_currentSubscription != null) {
        final canceledSubscription = _currentSubscription!.copyWith(
          status: SubscriptionStatus.cancelled,
        );
        
        _currentSubscription = canceledSubscription;
        await _storageService.saveSubscription(canceledSubscription);
        
        debugPrint('Subscription cancelled');
      }
    } catch (e) {
      debugPrint('Error cancelling subscription: $e');
      throw SubscriptionException('Failed to cancel subscription');
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      if (_currentSubscription == null) return;

      // Check if subscription has expired
      if (!_currentSubscription!.isActive && 
          _currentSubscription!.status == SubscriptionStatus.active) {
        final expiredSubscription = _currentSubscription!.copyWith(
          status: SubscriptionStatus.expired,
        );
        
        _currentSubscription = expiredSubscription;
        await _storageService.saveSubscription(expiredSubscription);
        
        debugPrint('Subscription expired');
      }
    } catch (e) {
      debugPrint('Error checking subscription status: $e');
    }
  }

  // Get product details
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (e) {
      return null;
    }
  }

  String getProductPrice(String productId) {
    final product = getProduct(productId);
    return product?.price ?? 'N/A';
  }

  String getProductTitle(String productId) {
    final product = getProduct(productId);
    return product?.title ?? 'Unknown Product';
  }

  String getProductDescription(String productId) {
    final product = getProduct(productId);
    return product?.description ?? 'No description available';
  }

  void dispose() {
    _subscription?.cancel();
  }
}

class SubscriptionException implements Exception {
  final String message;
  SubscriptionException(this.message);

  @override
  String toString() => 'SubscriptionException: $message';
}