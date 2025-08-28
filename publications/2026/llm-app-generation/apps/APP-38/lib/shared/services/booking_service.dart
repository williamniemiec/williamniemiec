import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/booking.dart';
import '../models/property.dart';
import '../models/user.dart';
import '../../core/constants/app_constants.dart';

class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final List<Booking> _mockBookings = [];
  final _uuid = const Uuid();

  // Initialize service
  Future<void> initialize() async {
    // Load any stored bookings or generate mock data
    await _loadStoredBookings();
  }

  // Create a new booking
  Future<BookingResult> createBooking({
    required String userId,
    required Property property,
    required Room room,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfGuests,
    required int numberOfRooms,
    required GuestDetails guestDetails,
    required PaymentDetails paymentDetails,
    String? specialRequests,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Validate booking data
      if (checkInDate.isAfter(checkOutDate)) {
        return BookingResult.failure('Check-in date must be before check-out date');
      }

      if (numberOfGuests > room.maxOccupancy * numberOfRooms) {
        return BookingResult.failure('Too many guests for selected room type');
      }

      if (room.availableRooms < numberOfRooms) {
        return BookingResult.failure('Not enough rooms available');
      }

      // Calculate pricing
      final numberOfNights = checkOutDate.difference(checkInDate).inDays;
      final basePrice = room.pricePerNight * numberOfRooms * numberOfNights;
      final taxes = basePrice * 0.12; // 12% tax
      final fees = 25.0; // Booking fee

      // Generate confirmation number
      final confirmationNumber = _generateConfirmationNumber();

      // Create booking
      final booking = Booking(
        id: _uuid.v4(),
        userId: userId,
        propertyId: property.id,
        roomId: room.id,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        numberOfGuests: numberOfGuests,
        numberOfRooms: numberOfRooms,
        totalPrice: basePrice,
        taxes: taxes,
        fees: fees,
        status: BookingStatus.confirmed,
        bookingDate: DateTime.now(),
        confirmationNumber: confirmationNumber,
        guestDetails: guestDetails,
        paymentDetails: paymentDetails.copyWith(
          isPaid: true,
          paymentDate: DateTime.now(),
          transactionId: _uuid.v4(),
        ),
        freeCancellation: room.freeCancellation,
        cancellationDeadline: room.freeCancellation 
            ? checkInDate.subtract(const Duration(days: 1))
            : null,
        specialRequests: specialRequests,
        property: property,
        room: room,
      );

      // Store booking
      _mockBookings.add(booking);
      await _saveBookings();

      return BookingResult.success(booking);
    } catch (e) {
      return BookingResult.failure('Booking failed: ${e.toString()}');
    }
  }

  // Get user bookings
  Future<List<Booking>> getUserBookings(String userId, {BookingStatus? status}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    var userBookings = _mockBookings.where((booking) => booking.userId == userId);

    if (status != null) {
      userBookings = userBookings.where((booking) => booking.status == status);
    }

    // Sort by booking date (newest first)
    final sortedBookings = userBookings.toList();
    sortedBookings.sort((a, b) => b.bookingDate.compareTo(a.bookingDate));

    return sortedBookings;
  }

  // Get booking by ID
  Future<Booking?> getBookingById(String bookingId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockBookings.firstWhere((booking) => booking.id == bookingId);
    } catch (e) {
      return null;
    }
  }

  // Get booking by confirmation number
  Future<Booking?> getBookingByConfirmationNumber(String confirmationNumber) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockBookings.firstWhere(
        (booking) => booking.confirmationNumber == confirmationNumber
      );
    } catch (e) {
      return null;
    }
  }

  // Cancel booking
  Future<BookingResult> cancelBooking(String bookingId, String reason) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final bookingIndex = _mockBookings.indexWhere((booking) => booking.id == bookingId);
      if (bookingIndex == -1) {
        return BookingResult.failure('Booking not found');
      }

      final booking = _mockBookings[bookingIndex];

      // Check if cancellation is allowed
      if (!booking.canBeCancelled) {
        return BookingResult.failure('This booking cannot be cancelled');
      }

      // Update booking status
      final cancelledBooking = booking.copyWith(
        status: BookingStatus.cancelled,
      );

      _mockBookings[bookingIndex] = cancelledBooking;
      await _saveBookings();

      return BookingResult.success(cancelledBooking);
    } catch (e) {
      return BookingResult.failure('Cancellation failed: ${e.toString()}');
    }
  }

  // Modify booking
  Future<BookingResult> modifyBooking({
    required String bookingId,
    DateTime? newCheckInDate,
    DateTime? newCheckOutDate,
    int? newNumberOfGuests,
    int? newNumberOfRooms,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final bookingIndex = _mockBookings.indexWhere((booking) => booking.id == bookingId);
      if (bookingIndex == -1) {
        return BookingResult.failure('Booking not found');
      }

      final booking = _mockBookings[bookingIndex];

      // Check if modification is allowed
      if (booking.status != BookingStatus.confirmed) {
        return BookingResult.failure('Only confirmed bookings can be modified');
      }

      // Create modified booking
      final modifiedBooking = booking.copyWith(
        checkInDate: newCheckInDate ?? booking.checkInDate,
        checkOutDate: newCheckOutDate ?? booking.checkOutDate,
        numberOfGuests: newNumberOfGuests ?? booking.numberOfGuests,
        numberOfRooms: newNumberOfRooms ?? booking.numberOfRooms,
      );

      _mockBookings[bookingIndex] = modifiedBooking;
      await _saveBookings();

      return BookingResult.success(modifiedBooking);
    } catch (e) {
      return BookingResult.failure('Modification failed: ${e.toString()}');
    }
  }

  // Get upcoming bookings
  Future<List<Booking>> getUpcomingBookings(String userId) async {
    final allBookings = await getUserBookings(userId);
    return allBookings.where((booking) => booking.isUpcoming).toList();
  }

  // Get past bookings
  Future<List<Booking>> getPastBookings(String userId) async {
    final allBookings = await getUserBookings(userId);
    return allBookings.where((booking) => 
      booking.status == BookingStatus.completed ||
      (booking.checkOutDate.isBefore(DateTime.now()) && 
       booking.status == BookingStatus.confirmed)
    ).toList();
  }

  // Get cancelled bookings
  Future<List<Booking>> getCancelledBookings(String userId) async {
    return await getUserBookings(userId, status: BookingStatus.cancelled);
  }

  // Check room availability
  Future<bool> checkRoomAvailability({
    required String propertyId,
    required String roomId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfRooms,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Check for conflicting bookings
    final conflictingBookings = _mockBookings.where((booking) =>
      booking.propertyId == propertyId &&
      booking.roomId == roomId &&
      booking.status == BookingStatus.confirmed &&
      !(checkOutDate.isBefore(booking.checkInDate) || 
        checkInDate.isAfter(booking.checkOutDate))
    );

    final bookedRooms = conflictingBookings.fold<int>(
      0, 
      (sum, booking) => sum + booking.numberOfRooms
    );

    // Assume each room type has 5 total rooms available
    const totalRoomsAvailable = 5;
    return (bookedRooms + numberOfRooms) <= totalRoomsAvailable;
  }

  // Generate booking statistics
  Future<BookingStats> getBookingStats(String userId) async {
    final allBookings = await getUserBookings(userId);
    
    final totalBookings = allBookings.length;
    final completedBookings = allBookings.where((b) => b.status == BookingStatus.completed).length;
    final cancelledBookings = allBookings.where((b) => b.status == BookingStatus.cancelled).length;
    final totalSpent = allBookings.fold<double>(0, (sum, booking) => sum + booking.finalPrice);
    
    return BookingStats(
      totalBookings: totalBookings,
      completedBookings: completedBookings,
      cancelledBookings: cancelledBookings,
      totalSpent: totalSpent,
    );
  }

  // Private helper methods
  String _generateConfirmationNumber() {
    final random = Random();
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';
    
    String result = '';
    // 2 letters
    for (int i = 0; i < 2; i++) {
      result += letters[random.nextInt(letters.length)];
    }
    // 6 numbers
    for (int i = 0; i < 6; i++) {
      result += numbers[random.nextInt(numbers.length)];
    }
    
    return result;
  }

  Future<void> _loadStoredBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = prefs.getString('stored_bookings');
    
    if (bookingsJson != null) {
      try {
        final List<dynamic> bookingsList = jsonDecode(bookingsJson);
        _mockBookings.clear();
        _mockBookings.addAll(
          bookingsList.map((json) => Booking.fromJson(json)).toList()
        );
      } catch (e) {
        // Clear invalid stored data
        await prefs.remove('stored_bookings');
      }
    }
  }

  Future<void> _saveBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsJson = jsonEncode(
      _mockBookings.map((booking) => booking.toJson()).toList()
    );
    await prefs.setString('stored_bookings', bookingsJson);
  }
}

class BookingResult {
  final bool isSuccess;
  final Booking? booking;
  final String? message;
  final String? error;

  BookingResult._({
    required this.isSuccess,
    this.booking,
    this.message,
    this.error,
  });

  factory BookingResult.success(Booking booking, {String? message}) {
    return BookingResult._(
      isSuccess: true,
      booking: booking,
      message: message,
    );
  }

  factory BookingResult.failure(String error) {
    return BookingResult._(
      isSuccess: false,
      error: error,
    );
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'BookingResult.success(booking: ${booking?.confirmationNumber})';
    } else {
      return 'BookingResult.failure(error: $error)';
    }
  }
}

class BookingStats {
  final int totalBookings;
  final int completedBookings;
  final int cancelledBookings;
  final double totalSpent;

  BookingStats({
    required this.totalBookings,
    required this.completedBookings,
    required this.cancelledBookings,
    required this.totalSpent,
  });

  double get completionRate {
    if (totalBookings == 0) return 0.0;
    return completedBookings / totalBookings;
  }

  double get cancellationRate {
    if (totalBookings == 0) return 0.0;
    return cancelledBookings / totalBookings;
  }

  @override
  String toString() {
    return 'BookingStats(total: $totalBookings, completed: $completedBookings, spent: \$${totalSpent.toStringAsFixed(2)})';
  }
}

extension PaymentDetailsExtension on PaymentDetails {
  PaymentDetails copyWith({
    String? method,
    String? cardLastFour,
    String? cardType,
    bool? isPaid,
    DateTime? paymentDate,
    String? transactionId,
  }) {
    return PaymentDetails(
      method: method ?? this.method,
      cardLastFour: cardLastFour ?? this.cardLastFour,
      cardType: cardType ?? this.cardType,
      isPaid: isPaid ?? this.isPaid,
      paymentDate: paymentDate ?? this.paymentDate,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}