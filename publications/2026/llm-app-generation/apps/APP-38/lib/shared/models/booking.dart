import 'property.dart';
import 'user.dart';

enum BookingStatus {
  confirmed,
  pending,
  cancelled,
  completed,
  noShow,
}

class Booking {
  final String id;
  final String userId;
  final String propertyId;
  final String roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final int numberOfRooms;
  final double totalPrice;
  final double? taxes;
  final double? fees;
  final BookingStatus status;
  final DateTime bookingDate;
  final String confirmationNumber;
  final GuestDetails guestDetails;
  final PaymentDetails paymentDetails;
  final bool freeCancellation;
  final DateTime? cancellationDeadline;
  final String? specialRequests;
  final Property? property; // Optional, for display purposes
  final Room? room; // Optional, for display purposes

  Booking({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.numberOfRooms,
    required this.totalPrice,
    this.taxes,
    this.fees,
    required this.status,
    required this.bookingDate,
    required this.confirmationNumber,
    required this.guestDetails,
    required this.paymentDetails,
    this.freeCancellation = false,
    this.cancellationDeadline,
    this.specialRequests,
    this.property,
    this.room,
  });

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  double get finalPrice {
    return totalPrice + (taxes ?? 0.0) + (fees ?? 0.0);
  }

  bool get canBeCancelled {
    if (!freeCancellation) return false;
    if (cancellationDeadline == null) return true;
    return DateTime.now().isBefore(cancellationDeadline!);
  }

  bool get isUpcoming {
    return status == BookingStatus.confirmed && 
           checkInDate.isAfter(DateTime.now());
  }

  bool get isActive {
    final now = DateTime.now();
    return status == BookingStatus.confirmed &&
           checkInDate.isBefore(now) &&
           checkOutDate.isAfter(now);
  }

  String get statusText {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.noShow:
        return 'No Show';
    }
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      userId: json['userId'] as String,
      propertyId: json['propertyId'] as String,
      roomId: json['roomId'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: DateTime.parse(json['checkOutDate'] as String),
      numberOfGuests: json['numberOfGuests'] as int,
      numberOfRooms: json['numberOfRooms'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      taxes: json['taxes'] as double?,
      fees: json['fees'] as double?,
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.pending,
      ),
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      confirmationNumber: json['confirmationNumber'] as String,
      guestDetails: GuestDetails.fromJson(json['guestDetails']),
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails']),
      freeCancellation: json['freeCancellation'] as bool? ?? false,
      cancellationDeadline: json['cancellationDeadline'] != null
          ? DateTime.parse(json['cancellationDeadline'] as String)
          : null,
      specialRequests: json['specialRequests'] as String?,
      property: json['property'] != null 
          ? Property.fromJson(json['property']) 
          : null,
      room: json['room'] != null 
          ? Room.fromJson(json['room']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'propertyId': propertyId,
      'roomId': roomId,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'numberOfRooms': numberOfRooms,
      'totalPrice': totalPrice,
      'taxes': taxes,
      'fees': fees,
      'status': status.name,
      'bookingDate': bookingDate.toIso8601String(),
      'confirmationNumber': confirmationNumber,
      'guestDetails': guestDetails.toJson(),
      'paymentDetails': paymentDetails.toJson(),
      'freeCancellation': freeCancellation,
      'cancellationDeadline': cancellationDeadline?.toIso8601String(),
      'specialRequests': specialRequests,
      'property': property?.toJson(),
      'room': room?.toJson(),
    };
  }

  Booking copyWith({
    String? id,
    String? userId,
    String? propertyId,
    String? roomId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numberOfGuests,
    int? numberOfRooms,
    double? totalPrice,
    double? taxes,
    double? fees,
    BookingStatus? status,
    DateTime? bookingDate,
    String? confirmationNumber,
    GuestDetails? guestDetails,
    PaymentDetails? paymentDetails,
    bool? freeCancellation,
    DateTime? cancellationDeadline,
    String? specialRequests,
    Property? property,
    Room? room,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      propertyId: propertyId ?? this.propertyId,
      roomId: roomId ?? this.roomId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      totalPrice: totalPrice ?? this.totalPrice,
      taxes: taxes ?? this.taxes,
      fees: fees ?? this.fees,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      confirmationNumber: confirmationNumber ?? this.confirmationNumber,
      guestDetails: guestDetails ?? this.guestDetails,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      freeCancellation: freeCancellation ?? this.freeCancellation,
      cancellationDeadline: cancellationDeadline ?? this.cancellationDeadline,
      specialRequests: specialRequests ?? this.specialRequests,
      property: property ?? this.property,
      room: room ?? this.room,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Booking(id: $id, confirmationNumber: $confirmationNumber, status: $statusText)';
  }
}

class GuestDetails {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? country;

  GuestDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.country,
  });

  String get fullName => '$firstName $lastName';

  factory GuestDetails.fromJson(Map<String, dynamic> json) {
    return GuestDetails(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'country': country,
    };
  }

  @override
  String toString() {
    return 'GuestDetails(fullName: $fullName, email: $email)';
  }
}

class PaymentDetails {
  final String method; // 'credit_card', 'paypal', 'bank_transfer', etc.
  final String? cardLastFour;
  final String? cardType;
  final bool isPaid;
  final DateTime? paymentDate;
  final String? transactionId;

  PaymentDetails({
    required this.method,
    this.cardLastFour,
    this.cardType,
    this.isPaid = false,
    this.paymentDate,
    this.transactionId,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      method: json['method'] as String,
      cardLastFour: json['cardLastFour'] as String?,
      cardType: json['cardType'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'] as String)
          : null,
      transactionId: json['transactionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'cardLastFour': cardLastFour,
      'cardType': cardType,
      'isPaid': isPaid,
      'paymentDate': paymentDate?.toIso8601String(),
      'transactionId': transactionId,
    };
  }

  @override
  String toString() {
    return 'PaymentDetails(method: $method, isPaid: $isPaid)';
  }
}