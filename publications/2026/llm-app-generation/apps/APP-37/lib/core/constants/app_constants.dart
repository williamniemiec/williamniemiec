class AppConstants {
  // App Information
  static const String appName = 'Uber';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.uber.com/v1';
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
  
  // Map Configuration
  static const double defaultZoom = 15.0;
  static const double maxZoom = 20.0;
  static const double minZoom = 10.0;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Ride Types
  static const List<String> rideTypes = [
    'UberX',
    'Comfort',
    'UberXL',
    'Black',
    'Premier',
    'Green',
    'Pet'
  ];
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'Credit Card',
    'Debit Card',
    'PayPal',
    'Apple Pay',
    'Google Pay',
    'Uber Cash'
  ];
  
  // Trip Status
  static const String tripRequested = 'requested';
  static const String tripAccepted = 'accepted';
  static const String tripDriverArriving = 'driver_arriving';
  static const String tripInProgress = 'in_progress';
  static const String tripCompleted = 'completed';
  static const String tripCancelled = 'cancelled';
  
  // Error Messages
  static const String networkError = 'Network connection error. Please try again.';
  static const String locationError = 'Unable to get your location. Please enable location services.';
  static const String noDriversError = 'No drivers available in your area. Please try again later.';
  static const String paymentError = 'Payment failed. Please check your payment method.';
  
  // Success Messages
  static const String tripBooked = 'Your ride has been booked successfully!';
  static const String tripCompletedMessage = 'Trip completed. Thank you for riding with Uber!';
  static const String profileUpdated = 'Profile updated successfully!';
}

class AppImages {
  static const String _basePath = 'assets/images/';
  
  // Logos
  static const String logo = '${_basePath}uber_logo.png';
  static const String logoWhite = '${_basePath}uber_logo_white.png';
  
  // Vehicle Types
  static const String uberX = '${_basePath}uber_x.png';
  static const String comfort = '${_basePath}comfort.png';
  static const String uberXL = '${_basePath}uber_xl.png';
  static const String black = '${_basePath}black.png';
  static const String premier = '${_basePath}premier.png';
  static const String green = '${_basePath}green.png';
  static const String pet = '${_basePath}pet.png';
  
  // Onboarding
  static const String onboarding1 = '${_basePath}onboarding_1.png';
  static const String onboarding2 = '${_basePath}onboarding_2.png';
  static const String onboarding3 = '${_basePath}onboarding_3.png';
  
  // Placeholders
  static const String userPlaceholder = '${_basePath}user_placeholder.png';
  static const String driverPlaceholder = '${_basePath}driver_placeholder.png';
}

class AppIcons {
  static const String _basePath = 'assets/icons/';
  
  // Navigation
  static const String home = '${_basePath}home.svg';
  static const String services = '${_basePath}services.svg';
  static const String activity = '${_basePath}activity.svg';
  static const String account = '${_basePath}account.svg';
  
  // Map
  static const String currentLocation = '${_basePath}current_location.svg';
  static const String destination = '${_basePath}destination.svg';
  static const String pickup = '${_basePath}pickup.svg';
  
  // Safety
  static const String emergency = '${_basePath}emergency.svg';
  static const String share = '${_basePath}share.svg';
  static const String safety = '${_basePath}safety.svg';
}

class AppAnimations {
  static const String _basePath = 'assets/animations/';
  
  static const String loading = '${_basePath}loading.json';
  static const String searching = '${_basePath}searching.json';
  static const String carMoving = '${_basePath}car_moving.json';
  static const String success = '${_basePath}success.json';
  static const String error = '${_basePath}error.json';
}