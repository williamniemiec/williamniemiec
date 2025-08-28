class AppConstants {
  // App Information
  static const String appName = 'Booking.com';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.booking.com/v1';
  static const String apiKey = 'your_api_key_here';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String recentSearchesKey = 'recent_searches';
  static const String wishlistKey = 'wishlist';
  
  // Service Types
  static const String serviceStays = 'stays';
  static const String serviceFlights = 'flights';
  static const String serviceCarRental = 'car_rental';
  static const String serviceAttractions = 'attractions';
  static const String serviceTaxis = 'taxis';
  
  // Property Types
  static const List<String> propertyTypes = [
    'Hotel',
    'Apartment',
    'Vacation Rental',
    'Hostel',
    'B&B',
    'Resort',
    'Villa',
    'Guesthouse',
  ];
  
  // Amenities
  static const List<String> amenities = [
    'Free WiFi',
    'Free Parking',
    'Swimming Pool',
    'Fitness Center',
    'Pet Friendly',
    'Air Conditioning',
    'Restaurant',
    'Room Service',
    'Spa',
    'Business Center',
    'Airport Shuttle',
    'Non-smoking Rooms',
  ];
  
  // Filter Options
  static const List<String> starRatings = ['1', '2', '3', '4', '5'];
  static const List<String> priceRanges = [
    'Under \$50',
    '\$50 - \$100',
    '\$100 - \$200',
    '\$200 - \$300',
    'Over \$300',
  ];
  
  // Booking Policies
  static const String freeCancellation = 'Free Cancellation';
  static const String bookNowPayLater = 'Book Now, Pay Later';
  static const String instantConfirmation = 'Instant Confirmation';
  
  // Default Values
  static const int defaultPageSize = 20;
  static const int maxGuestsPerRoom = 8;
  static const int maxRoomsPerBooking = 5;
  
  // Image Placeholders
  static const String placeholderImage = 'assets/images/placeholder.png';
  static const String defaultProfileImage = 'assets/images/default_profile.png';
  
  // Colors (as hex strings for consistency)
  static const String primaryBlue = '#003580';
  static const String secondaryBlue = '#0071c2';
  static const String accentOrange = '#ff8c00';
  static const String successGreen = '#008009';
  static const String warningYellow = '#ffb700';
  static const String errorRed = '#d4111a';
}