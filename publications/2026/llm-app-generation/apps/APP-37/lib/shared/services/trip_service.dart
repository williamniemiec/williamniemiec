import 'dart:async';
import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/trip.dart';
import '../models/location.dart';
import '../models/user.dart';

class TripService {
  static final TripService _instance = TripService._internal();
  factory TripService() => _instance;
  TripService._internal();

  final _uuid = const Uuid();
  final List<Trip> _trips = [];
  final List<Driver> _availableDrivers = [];
  
  StreamController<Trip>? _currentTripController;
  StreamController<List<RideOption>>? _rideOptionsController;
  
  Trip? _currentTrip;

  Stream<Trip> get currentTripStream {
    _currentTripController ??= StreamController<Trip>.broadcast();
    return _currentTripController!.stream;
  }

  Stream<List<RideOption>> get rideOptionsStream {
    _rideOptionsController ??= StreamController<List<RideOption>>.broadcast();
    return _rideOptionsController!.stream;
  }

  Trip? get currentTrip => _currentTrip;

  /// Initialize service with mock data
  void initialize() {
    _initializeMockDrivers();
  }

  /// Get ride options for a trip
  Future<List<RideOption>> getRideOptions(Location pickup, Location destination) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final distance = _calculateDistance(pickup, destination);
    final baseTime = (distance * 2.5).round(); // Rough estimate: 2.5 minutes per km

    final options = [
      RideOption(
        type: RideType.uberX,
        name: 'UberX',
        description: 'Affordable, everyday rides',
        estimatedFare: _calculateFare(distance, 1.0),
        estimatedTime: baseTime,
        capacity: 4,
        iconPath: 'assets/images/uber_x.png',
      ),
      RideOption(
        type: RideType.comfort,
        name: 'Comfort',
        description: 'Newer cars with extra legroom',
        estimatedFare: _calculateFare(distance, 1.3),
        estimatedTime: baseTime + 2,
        capacity: 4,
        iconPath: 'assets/images/comfort.png',
      ),
      RideOption(
        type: RideType.uberXL,
        name: 'UberXL',
        description: 'Affordable rides for groups up to 6',
        estimatedFare: _calculateFare(distance, 1.7),
        estimatedTime: baseTime + 3,
        capacity: 6,
        iconPath: 'assets/images/uber_xl.png',
      ),
      RideOption(
        type: RideType.black,
        name: 'Black',
        description: 'Premium rides in luxury cars',
        estimatedFare: _calculateFare(distance, 2.5),
        estimatedTime: baseTime + 1,
        capacity: 4,
        iconPath: 'assets/images/black.png',
      ),
      RideOption(
        type: RideType.green,
        name: 'Green',
        description: 'Eco-friendly rides in hybrid or electric cars',
        estimatedFare: _calculateFare(distance, 1.1),
        estimatedTime: baseTime + 1,
        capacity: 4,
        iconPath: 'assets/images/green.png',
      ),
    ];

    _rideOptionsController?.add(options);
    return options;
  }

  /// Request a trip
  Future<Trip> requestTrip({
    required String userId,
    required Location pickup,
    required Location destination,
    required RideType rideType,
    String? paymentMethodId,
    List<Location> waypoints = const [],
  }) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    final trip = Trip(
      id: _uuid.v4(),
      userId: userId,
      pickupLocation: pickup,
      destinationLocation: destination,
      waypoints: waypoints,
      rideType: rideType,
      status: TripStatus.requested,
      requestedAt: DateTime.now(),
      paymentMethodId: paymentMethodId,
      distance: _calculateDistance(pickup, destination),
      estimatedDuration: (_calculateDistance(pickup, destination) * 2.5).round(),
      estimatedFare: _calculateFareForRideType(
        _calculateDistance(pickup, destination),
        rideType,
      ),
    );

    _trips.add(trip);
    _currentTrip = trip;
    _currentTripController?.add(trip);

    // Simulate driver matching
    _simulateDriverMatching(trip);

    return trip;
  }

  /// Cancel current trip
  Future<void> cancelTrip(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final tripIndex = _trips.indexWhere((t) => t.id == tripId);
    if (tripIndex != -1) {
      final trip = _trips[tripIndex];
      final cancelledTrip = trip.copyWith(
        status: TripStatus.cancelled,
        completedAt: DateTime.now(),
      );
      
      _trips[tripIndex] = cancelledTrip;
      
      if (_currentTrip?.id == tripId) {
        _currentTrip = null;
      }
      
      _currentTripController?.add(cancelledTrip);
    }
  }

  /// Rate trip
  Future<void> rateTrip(String tripId, int rating, {String? feedback, double? tip}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final tripIndex = _trips.indexWhere((t) => t.id == tripId);
    if (tripIndex != -1) {
      final trip = _trips[tripIndex];
      final ratedTrip = trip.copyWith(
        rating: rating,
        feedback: feedback,
        tip: tip,
      );
      
      _trips[tripIndex] = ratedTrip;
      _currentTripController?.add(ratedTrip);
    }
  }

  /// Get trip history
  Future<List<Trip>> getTripHistory(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _trips.where((trip) => trip.userId == userId).toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  /// Get trip by ID
  Future<Trip?> getTripById(String tripId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _trips.firstWhere((trip) => trip.id == tripId);
    } catch (e) {
      return null;
    }
  }

  /// Simulate driver matching and trip progression
  void _simulateDriverMatching(Trip trip) {
    Timer(const Duration(seconds: 3), () {
      if (_currentTrip?.id == trip.id && _currentTrip?.status == TripStatus.requested) {
        final driver = _getRandomDriver();
        final acceptedTrip = trip.copyWith(
          status: TripStatus.accepted,
          acceptedAt: DateTime.now(),
          driverId: driver.id,
          driver: driver,
        );
        
        _updateTrip(acceptedTrip);
        _simulateDriverArrival(acceptedTrip);
      }
    });
  }

  void _simulateDriverArrival(Trip trip) {
    Timer(const Duration(seconds: 8), () {
      if (_currentTrip?.id == trip.id && _currentTrip?.status == TripStatus.accepted) {
        final arrivingTrip = trip.copyWith(status: TripStatus.driverArriving);
        _updateTrip(arrivingTrip);
        _simulateTripStart(arrivingTrip);
      }
    });
  }

  void _simulateTripStart(Trip trip) {
    Timer(const Duration(seconds: 5), () {
      if (_currentTrip?.id == trip.id && _currentTrip?.status == TripStatus.driverArriving) {
        final startedTrip = trip.copyWith(
          status: TripStatus.inProgress,
          startedAt: DateTime.now(),
        );
        _updateTrip(startedTrip);
        _simulateTripCompletion(startedTrip);
      }
    });
  }

  void _simulateTripCompletion(Trip trip) {
    final estimatedDuration = trip.estimatedDuration ?? 10;
    Timer(Duration(seconds: estimatedDuration), () {
      if (_currentTrip?.id == trip.id && _currentTrip?.status == TripStatus.inProgress) {
        final completedTrip = trip.copyWith(
          status: TripStatus.completed,
          completedAt: DateTime.now(),
          actualFare: trip.estimatedFare,
          actualDuration: estimatedDuration,
        );
        _updateTrip(completedTrip);
      }
    });
  }

  void _updateTrip(Trip trip) {
    final tripIndex = _trips.indexWhere((t) => t.id == trip.id);
    if (tripIndex != -1) {
      _trips[tripIndex] = trip;
      _currentTrip = trip;
      _currentTripController?.add(trip);
    }
  }

  double _calculateDistance(Location from, Location to) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
    final double lat1Rad = from.latitude * (pi / 180);
    final double lat2Rad = to.latitude * (pi / 180);
    final double deltaLatRad = (to.latitude - from.latitude) * (pi / 180);
    final double deltaLonRad = (to.longitude - from.longitude) * (pi / 180);

    final double a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLonRad / 2) * sin(deltaLonRad / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _calculateFare(double distance, double multiplier) {
    const double baseFare = 2.50;
    const double perKmRate = 1.20;
    const double minimumFare = 5.00;
    
    final fare = (baseFare + (distance * perKmRate)) * multiplier;
    return max(fare, minimumFare);
  }

  double _calculateFareForRideType(double distance, RideType rideType) {
    double multiplier;
    switch (rideType) {
      case RideType.uberX:
        multiplier = 1.0;
        break;
      case RideType.comfort:
        multiplier = 1.3;
        break;
      case RideType.uberXL:
        multiplier = 1.7;
        break;
      case RideType.black:
        multiplier = 2.5;
        break;
      case RideType.premier:
        multiplier = 3.0;
        break;
      case RideType.green:
        multiplier = 1.1;
        break;
      case RideType.pet:
        multiplier = 1.2;
        break;
    }
    return _calculateFare(distance, multiplier);
  }

  Driver _getRandomDriver() {
    final random = Random();
    return _availableDrivers[random.nextInt(_availableDrivers.length)];
  }

  void _initializeMockDrivers() {
    _availableDrivers.addAll([
      Driver(
        id: _uuid.v4(),
        firstName: 'John',
        lastName: 'Smith',
        rating: 4.8,
        totalTrips: 1250,
        phoneNumber: '+1234567890',
        vehicle: const Vehicle(
          make: 'Toyota',
          model: 'Camry',
          year: '2020',
          color: 'Silver',
          licensePlate: 'ABC-1234',
        ),
      ),
      Driver(
        id: _uuid.v4(),
        firstName: 'Maria',
        lastName: 'Garcia',
        rating: 4.9,
        totalTrips: 890,
        phoneNumber: '+1234567891',
        vehicle: const Vehicle(
          make: 'Honda',
          model: 'Civic',
          year: '2021',
          color: 'Blue',
          licensePlate: 'XYZ-5678',
        ),
      ),
      Driver(
        id: _uuid.v4(),
        firstName: 'David',
        lastName: 'Johnson',
        rating: 4.7,
        totalTrips: 2100,
        phoneNumber: '+1234567892',
        vehicle: const Vehicle(
          make: 'Nissan',
          model: 'Altima',
          year: '2019',
          color: 'Black',
          licensePlate: 'DEF-9012',
        ),
      ),
    ]);
  }

  void dispose() {
    _currentTripController?.close();
    _rideOptionsController?.close();
    _currentTripController = null;
    _rideOptionsController = null;
  }
}