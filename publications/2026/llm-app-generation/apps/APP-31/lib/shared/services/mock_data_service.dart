import '../models/product.dart';
import '../models/user.dart';
import '../models/coupon.dart';
import '../models/order.dart';

class MockDataService {
  static List<Product> getProducts() {
    return [
      Product(
        id: '1',
        name: 'Wireless Bluetooth Earbuds',
        description: 'High-quality wireless earbuds with noise cancellation and long battery life. Perfect for music lovers and professionals.',
        price: 29.99,
        originalPrice: 79.99,
        images: [
          'https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb?w=400',
          'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
        ],
        category: 'Electronics',
        rating: 4.5,
        reviewCount: 1234,
        tags: ['wireless', 'bluetooth', 'earbuds', 'music'],
        isFreeShipping: true,
        isFlashSale: true,
        flashSaleEndTime: DateTime.now().add(const Duration(hours: 6)),
        stockQuantity: 50,
        variants: [
          ProductVariant(id: '1', name: 'Color', value: 'Black', stockQuantity: 20),
          ProductVariant(id: '2', name: 'Color', value: 'White', stockQuantity: 30),
        ],
        sellerId: 'seller1',
        sellerName: 'TechStore Pro',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Product(
        id: '2',
        name: 'Summer Floral Dress',
        description: 'Beautiful floral print dress perfect for summer occasions. Made with breathable fabric and comfortable fit.',
        price: 24.99,
        originalPrice: 49.99,
        images: [
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400',
          'https://images.unsplash.com/photo-1566479179817-c0b5b4b4b1e5?w=400',
        ],
        category: 'Women\'s Clothing',
        rating: 4.3,
        reviewCount: 567,
        tags: ['dress', 'summer', 'floral', 'fashion'],
        isFreeShipping: true,
        isFlashSale: false,
        stockQuantity: 25,
        variants: [
          ProductVariant(id: '3', name: 'Size', value: 'S', stockQuantity: 5),
          ProductVariant(id: '4', name: 'Size', value: 'M', stockQuantity: 10),
          ProductVariant(id: '5', name: 'Size', value: 'L', stockQuantity: 10),
        ],
        sellerId: 'seller2',
        sellerName: 'Fashion Hub',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Product(
        id: '3',
        name: 'Smart Fitness Watch',
        description: 'Advanced fitness tracker with heart rate monitoring, GPS, and waterproof design. Track your health 24/7.',
        price: 89.99,
        originalPrice: 199.99,
        images: [
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400',
          'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400',
        ],
        category: 'Electronics',
        rating: 4.7,
        reviewCount: 2341,
        tags: ['smartwatch', 'fitness', 'health', 'gps'],
        isFreeShipping: true,
        isFlashSale: true,
        flashSaleEndTime: DateTime.now().add(const Duration(hours: 12)),
        stockQuantity: 15,
        variants: [
          ProductVariant(id: '6', name: 'Color', value: 'Black', stockQuantity: 8),
          ProductVariant(id: '7', name: 'Color', value: 'Silver', stockQuantity: 7),
        ],
        sellerId: 'seller3',
        sellerName: 'Smart Gadgets',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      Product(
        id: '4',
        name: 'Kitchen Knife Set',
        description: 'Professional 8-piece kitchen knife set with wooden block. Sharp, durable, and perfect for all cooking needs.',
        price: 39.99,
        originalPrice: 89.99,
        images: [
          'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400',
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400',
        ],
        category: 'Home & Kitchen',
        rating: 4.6,
        reviewCount: 892,
        tags: ['kitchen', 'knives', 'cooking', 'professional'],
        isFreeShipping: true,
        isFlashSale: false,
        stockQuantity: 30,
        variants: [],
        sellerId: 'seller4',
        sellerName: 'Kitchen Pro',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Product(
        id: '5',
        name: 'Yoga Mat Premium',
        description: 'Extra thick yoga mat with non-slip surface. Perfect for yoga, pilates, and home workouts.',
        price: 19.99,
        originalPrice: 39.99,
        images: [
          'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
        ],
        category: 'Sports & Outdoors',
        rating: 4.4,
        reviewCount: 445,
        tags: ['yoga', 'fitness', 'exercise', 'mat'],
        isFreeShipping: true,
        isFlashSale: true,
        flashSaleEndTime: DateTime.now().add(const Duration(hours: 3)),
        stockQuantity: 40,
        variants: [
          ProductVariant(id: '8', name: 'Color', value: 'Purple', stockQuantity: 15),
          ProductVariant(id: '9', name: 'Color', value: 'Blue', stockQuantity: 25),
        ],
        sellerId: 'seller5',
        sellerName: 'Fitness World',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      // Add more products...
      Product(
        id: '6',
        name: 'LED Desk Lamp',
        description: 'Adjustable LED desk lamp with USB charging port and touch control. Perfect for office and study.',
        price: 34.99,
        originalPrice: 59.99,
        images: [
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
        ],
        category: 'Home & Kitchen',
        rating: 4.2,
        reviewCount: 234,
        tags: ['lamp', 'led', 'desk', 'office'],
        isFreeShipping: true,
        isFlashSale: false,
        stockQuantity: 22,
        variants: [
          ProductVariant(id: '10', name: 'Color', value: 'White', stockQuantity: 12),
          ProductVariant(id: '11', name: 'Color', value: 'Black', stockQuantity: 10),
        ],
        sellerId: 'seller6',
        sellerName: 'Home Essentials',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  static List<Coupon> getCoupons() {
    return [
      Coupon(
        id: '1',
        code: 'WELCOME10',
        title: '10% Off First Order',
        description: 'Get 10% off your first purchase',
        type: CouponType.percentage,
        value: 10,
        minimumOrderAmount: 25,
        expiryDate: DateTime.now().add(const Duration(days: 30)),
        isUsed: false,
      ),
      Coupon(
        id: '2',
        code: 'FREESHIP',
        title: 'Free Shipping',
        description: 'Free shipping on any order',
        type: CouponType.freeShipping,
        value: 0,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        isUsed: false,
      ),
      Coupon(
        id: '3',
        code: 'SAVE5',
        title: '\$5 Off',
        description: 'Save \$5 on orders over \$30',
        type: CouponType.fixedAmount,
        value: 5,
        minimumOrderAmount: 30,
        expiryDate: DateTime.now().add(const Duration(days: 14)),
        isUsed: false,
      ),
    ];
  }

  static User getMockUser() {
    return User(
      id: 'user1',
      email: 'john.doe@example.com',
      name: 'John Doe',
      profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      phoneNumber: '+1234567890',
      addresses: [
        Address(
          id: 'addr1',
          name: 'Home',
          street: '123 Main Street',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          isDefault: true,
        ),
      ],
      credits: 25.50,
      coupons: getCoupons(),
      totalOrders: 12,
      totalSpent: 456.78,
      joinDate: DateTime.now().subtract(const Duration(days: 90)),
      preferences: UserPreferences(
        notificationsEnabled: true,
        emailMarketing: false,
        language: 'en',
        currency: 'USD',
      ),
    );
  }

  static List<String> getCategories() {
    return [
      'Women\'s Clothing',
      'Men\'s Clothing',
      'Home & Kitchen',
      'Health & Beauty',
      'Electronics',
      'Sports & Outdoors',
      'Toys & Games',
      'Automotive',
      'Books & Media',
      'Jewelry & Accessories',
    ];
  }

  static List<String> getPopularSearches() {
    return [
      'wireless earbuds',
      'summer dress',
      'kitchen gadgets',
      'fitness tracker',
      'home decor',
      'phone case',
      'yoga mat',
      'led lights',
      'bluetooth speaker',
      'skincare',
    ];
  }
}