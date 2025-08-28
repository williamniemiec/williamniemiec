import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/property.dart';
import '../models/search.dart';
import '../../core/constants/app_constants.dart';

class PropertyService {
  static final PropertyService _instance = PropertyService._internal();
  factory PropertyService() => _instance;
  PropertyService._internal();

  final List<Property> _mockProperties = [];
  List<String> _wishlist = [];

  // Initialize service with mock data
  Future<void> initialize() async {
    if (_mockProperties.isEmpty) {
      _generateMockProperties();
    }
    await _loadWishlist();
  }

  // Search properties based on criteria
  Future<SearchResult> searchProperties(SearchCriteria criteria, {int page = 1}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Filter properties based on criteria
    List<Property> filteredProperties = _mockProperties.where((property) {
      // Basic location filter (simplified)
      if (!property.city.toLowerCase().contains(criteria.destination.toLowerCase()) &&
          !property.country.toLowerCase().contains(criteria.destination.toLowerCase()) &&
          !property.name.toLowerCase().contains(criteria.destination.toLowerCase())) {
        return false;
      }

      // Apply filters
      final filters = criteria.filters;
      
      // Price filter
      if (filters.minPrice != null && property.lowestPrice < filters.minPrice!) {
        return false;
      }
      if (filters.maxPrice != null && property.lowestPrice > filters.maxPrice!) {
        return false;
      }

      // Star rating filter
      if (filters.starRatings.isNotEmpty && !filters.starRatings.contains(property.starRating)) {
        return false;
      }

      // Property type filter
      if (filters.propertyTypes.isNotEmpty && !filters.propertyTypes.contains(property.type)) {
        return false;
      }

      // Amenities filter
      if (filters.amenities.isNotEmpty) {
        bool hasRequiredAmenities = filters.amenities.every(
          (amenity) => property.amenities.contains(amenity)
        );
        if (!hasRequiredAmenities) return false;
      }

      // Review score filter
      if (filters.minReviewScore != null && property.reviewScore < filters.minReviewScore!) {
        return false;
      }

      // Booking policy filters
      if (filters.freeCancellation && !property.freeCancellation) {
        return false;
      }
      if (filters.bookNowPayLater && !property.bookNowPayLater) {
        return false;
      }

      return true;
    }).toList();

    // Sort results
    _sortProperties(filteredProperties, criteria.filters.sortBy);

    // Pagination
    const pageSize = AppConstants.defaultPageSize;
    final startIndex = (page - 1) * pageSize;
    final endIndex = min(startIndex + pageSize, filteredProperties.length);
    
    final paginatedResults = filteredProperties.sublist(
      startIndex,
      endIndex,
    );

    return SearchResult(
      results: paginatedResults,
      totalCount: filteredProperties.length,
      currentPage: page,
      totalPages: (filteredProperties.length / pageSize).ceil(),
      hasMore: endIndex < filteredProperties.length,
      searchCriteria: criteria,
    );
  }

  // Get property by ID
  Future<Property?> getPropertyById(String propertyId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockProperties.firstWhere((property) => property.id == propertyId);
    } catch (e) {
      return null;
    }
  }

  // Get featured properties
  Future<List<Property>> getFeaturedProperties({int limit = 10}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    final featured = _mockProperties.where((property) => 
      property.reviewScore >= 8.5 || property.discountPercentage != null
    ).take(limit).toList();

    return featured;
  }

  // Get properties near location
  Future<List<Property>> getNearbyProperties(double latitude, double longitude, {int limit = 10}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Simple distance calculation (in real app, use proper geolocation)
    final nearby = _mockProperties.map((property) {
      final distance = _calculateDistance(latitude, longitude, property.latitude, property.longitude);
      return MapEntry(property, distance);
    }).toList();

    nearby.sort((a, b) => a.value.compareTo(b.value));
    
    return nearby.take(limit).map((entry) => entry.key).toList();
  }

  // Toggle wishlist
  Future<bool> toggleWishlist(String propertyId) async {
    if (_wishlist.contains(propertyId)) {
      _wishlist.remove(propertyId);
    } else {
      _wishlist.add(propertyId);
    }
    
    await _saveWishlist();
    return _wishlist.contains(propertyId);
  }

  // Get wishlist properties
  Future<List<Property>> getWishlistProperties() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _mockProperties.where((property) => 
      _wishlist.contains(property.id)
    ).toList();
  }

  // Check if property is in wishlist
  bool isInWishlist(String propertyId) {
    return _wishlist.contains(propertyId);
  }

  // Get property reviews (mock)
  Future<List<PropertyReview>> getPropertyReviews(String propertyId, {int page = 1}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Generate mock reviews
    final reviews = List.generate(10, (index) => PropertyReview(
      id: 'review_${propertyId}_$index',
      guestName: _getRandomGuestName(),
      rating: 7.0 + Random().nextDouble() * 3.0,
      comment: _getRandomReviewComment(),
      date: DateTime.now().subtract(Duration(days: Random().nextInt(365))),
      roomType: 'Standard Room',
    ));

    return reviews;
  }

  // Private helper methods
  void _generateMockProperties() {
    final random = Random();
    final cities = ['New York', 'London', 'Paris', 'Tokyo', 'Sydney', 'Barcelona', 'Rome', 'Amsterdam'];
    final countries = ['USA', 'UK', 'France', 'Japan', 'Australia', 'Spain', 'Italy', 'Netherlands'];
    
    for (int i = 0; i < 50; i++) {
      final cityIndex = random.nextInt(cities.length);
      final city = cities[cityIndex];
      final country = countries[cityIndex];
      
      final property = Property(
        id: 'property_$i',
        name: _getRandomPropertyName(),
        description: _getRandomDescription(),
        type: AppConstants.propertyTypes[random.nextInt(AppConstants.propertyTypes.length)],
        starRating: 1 + random.nextInt(5),
        reviewScore: 6.0 + random.nextDouble() * 4.0,
        reviewCount: 50 + random.nextInt(500),
        address: '${100 + random.nextInt(900)} ${_getRandomStreetName()}',
        city: city,
        country: country,
        latitude: -90 + random.nextDouble() * 180,
        longitude: -180 + random.nextDouble() * 360,
        images: List.generate(5, (index) => 'https://picsum.photos/800/600?random=${i}_$index'),
        amenities: _getRandomAmenities(),
        rooms: _generateMockRooms(random),
        freeCancellation: random.nextBool(),
        bookNowPayLater: random.nextBool(),
        instantConfirmation: random.nextBool(),
        discountPercentage: random.nextBool() ? 10.0 + random.nextDouble() * 30.0 : null,
        geniusDiscount: random.nextBool() ? '10% Genius discount' : null,
      );
      
      _mockProperties.add(property);
    }
  }

  List<Room> _generateMockRooms(Random random) {
    final roomCount = 1 + random.nextInt(4);
    return List.generate(roomCount, (index) {
      final basePrice = 50.0 + random.nextDouble() * 300.0;
      final hasDiscount = random.nextBool();
      
      return Room(
        id: 'room_${random.nextInt(10000)}_$index',
        name: _getRandomRoomName(),
        description: 'Comfortable room with modern amenities',
        maxOccupancy: 1 + random.nextInt(4),
        pricePerNight: basePrice,
        originalPrice: hasDiscount ? basePrice * 1.2 : null,
        bedType: ['Single', 'Double', 'Queen', 'King'][random.nextInt(4)],
        roomSize: 15.0 + random.nextDouble() * 35.0,
        amenities: _getRandomRoomAmenities(),
        freeCancellation: random.nextBool(),
        breakfastIncluded: random.nextBool(),
        refundable: random.nextBool(),
        availableRooms: 1 + random.nextInt(5),
      );
    });
  }

  void _sortProperties(List<Property> properties, String sortBy) {
    switch (sortBy) {
      case 'price_low':
        properties.sort((a, b) => a.lowestPrice.compareTo(b.lowestPrice));
        break;
      case 'price_high':
        properties.sort((a, b) => b.lowestPrice.compareTo(a.lowestPrice));
        break;
      case 'rating':
        properties.sort((a, b) => b.reviewScore.compareTo(a.reviewScore));
        break;
      case 'distance':
        // Would need user location for proper distance sorting
        break;
      default: // recommended
        properties.sort((a, b) {
          // Sort by a combination of rating and review count
          final scoreA = a.reviewScore * (1 + a.reviewCount / 1000);
          final scoreB = b.reviewScore * (1 + b.reviewCount / 1000);
          return scoreB.compareTo(scoreA);
        });
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simplified distance calculation (Haversine formula would be more accurate)
    final deltaLat = lat2 - lat1;
    final deltaLon = lon2 - lon1;
    return sqrt(deltaLat * deltaLat + deltaLon * deltaLon);
  }

  Future<void> _loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistJson = prefs.getString(AppConstants.wishlistKey);
    if (wishlistJson != null) {
      _wishlist = List<String>.from(jsonDecode(wishlistJson));
    }
  }

  Future<void> _saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.wishlistKey, jsonEncode(_wishlist));
  }

  // Mock data generators
  String _getRandomPropertyName() {
    final prefixes = ['Grand', 'Royal', 'Imperial', 'Luxury', 'Premium', 'Elite', 'Boutique'];
    final types = ['Hotel', 'Resort', 'Suites', 'Inn', 'Lodge', 'Palace'];
    final suffixes = ['Plaza', 'Tower', 'Gardens', 'Spa', 'Club', 'Residence'];
    
    final random = Random();
    return '${prefixes[random.nextInt(prefixes.length)]} ${types[random.nextInt(types.length)]} ${suffixes[random.nextInt(suffixes.length)]}';
  }

  String _getRandomDescription() {
    return 'Experience luxury and comfort at this exceptional property. Featuring modern amenities, excellent service, and prime location.';
  }

  String _getRandomStreetName() {
    final streets = ['Main St', 'Oak Ave', 'Park Blvd', 'First St', 'Broadway', 'Market St'];
    return streets[Random().nextInt(streets.length)];
  }

  List<String> _getRandomAmenities() {
    final random = Random();
    final availableAmenities = List<String>.from(AppConstants.amenities);
    availableAmenities.shuffle(random);
    return availableAmenities.take(3 + random.nextInt(5)).toList();
  }

  String _getRandomRoomName() {
    final types = ['Standard', 'Deluxe', 'Superior', 'Executive', 'Premium', 'Suite'];
    return '${types[Random().nextInt(types.length)]} Room';
  }

  List<String> _getRandomRoomAmenities() {
    final amenities = ['Air Conditioning', 'Free WiFi', 'TV', 'Mini Bar', 'Safe', 'Balcony'];
    final random = Random();
    amenities.shuffle(random);
    return amenities.take(2 + random.nextInt(3)).toList();
  }

  String _getRandomGuestName() {
    final names = ['John D.', 'Sarah M.', 'Mike R.', 'Emma L.', 'David W.', 'Lisa K.'];
    return names[Random().nextInt(names.length)];
  }

  String _getRandomReviewComment() {
    final comments = [
      'Great location and excellent service!',
      'Clean rooms and friendly staff.',
      'Perfect for business travel.',
      'Amazing breakfast and comfortable beds.',
      'Would definitely stay here again.',
    ];
    return comments[Random().nextInt(comments.length)];
  }
}

class PropertyReview {
  final String id;
  final String guestName;
  final double rating;
  final String comment;
  final DateTime date;
  final String roomType;

  PropertyReview({
    required this.id,
    required this.guestName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.roomType,
  });

  @override
  String toString() {
    return 'PropertyReview(guestName: $guestName, rating: $rating)';
  }
}