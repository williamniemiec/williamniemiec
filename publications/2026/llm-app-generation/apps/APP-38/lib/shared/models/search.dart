class SearchCriteria {
  final String destination;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final int numberOfRooms;
  final String serviceType; // stays, flights, car_rental, etc.
  final SearchFilters filters;

  SearchCriteria({
    required this.destination,
    required this.checkInDate,
    required this.checkOutDate,
    this.numberOfGuests = 2,
    this.numberOfRooms = 1,
    this.serviceType = 'stays',
    this.filters = const SearchFilters(),
  });

  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  bool get isValid {
    return destination.isNotEmpty &&
           checkInDate.isBefore(checkOutDate) &&
           numberOfGuests > 0 &&
           numberOfRooms > 0;
  }

  factory SearchCriteria.fromJson(Map<String, dynamic> json) {
    return SearchCriteria(
      destination: json['destination'] as String,
      checkInDate: DateTime.parse(json['checkInDate'] as String),
      checkOutDate: DateTime.parse(json['checkOutDate'] as String),
      numberOfGuests: json['numberOfGuests'] as int? ?? 2,
      numberOfRooms: json['numberOfRooms'] as int? ?? 1,
      serviceType: json['serviceType'] as String? ?? 'stays',
      filters: json['filters'] != null 
          ? SearchFilters.fromJson(json['filters'])
          : const SearchFilters(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'numberOfGuests': numberOfGuests,
      'numberOfRooms': numberOfRooms,
      'serviceType': serviceType,
      'filters': filters.toJson(),
    };
  }

  SearchCriteria copyWith({
    String? destination,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numberOfGuests,
    int? numberOfRooms,
    String? serviceType,
    SearchFilters? filters,
  }) {
    return SearchCriteria(
      destination: destination ?? this.destination,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      serviceType: serviceType ?? this.serviceType,
      filters: filters ?? this.filters,
    );
  }

  @override
  String toString() {
    return 'SearchCriteria(destination: $destination, checkIn: $checkInDate, checkOut: $checkOutDate)';
  }
}

class SearchFilters {
  final double? minPrice;
  final double? maxPrice;
  final List<int> starRatings;
  final List<String> propertyTypes;
  final List<String> amenities;
  final double? minReviewScore;
  final bool freeCancellation;
  final bool bookNowPayLater;
  final bool breakfastIncluded;
  final String sortBy; // price_low, price_high, rating, distance
  final int? maxDistanceKm;

  const SearchFilters({
    this.minPrice,
    this.maxPrice,
    this.starRatings = const [],
    this.propertyTypes = const [],
    this.amenities = const [],
    this.minReviewScore,
    this.freeCancellation = false,
    this.bookNowPayLater = false,
    this.breakfastIncluded = false,
    this.sortBy = 'recommended',
    this.maxDistanceKm,
  });

  bool get hasActiveFilters {
    return minPrice != null ||
           maxPrice != null ||
           starRatings.isNotEmpty ||
           propertyTypes.isNotEmpty ||
           amenities.isNotEmpty ||
           minReviewScore != null ||
           freeCancellation ||
           bookNowPayLater ||
           breakfastIncluded ||
           maxDistanceKm != null;
  }

  int get activeFilterCount {
    int count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (starRatings.isNotEmpty) count++;
    if (propertyTypes.isNotEmpty) count++;
    if (amenities.isNotEmpty) count++;
    if (minReviewScore != null) count++;
    if (freeCancellation) count++;
    if (bookNowPayLater) count++;
    if (breakfastIncluded) count++;
    if (maxDistanceKm != null) count++;
    return count;
  }

  factory SearchFilters.fromJson(Map<String, dynamic> json) {
    return SearchFilters(
      minPrice: json['minPrice'] as double?,
      maxPrice: json['maxPrice'] as double?,
      starRatings: List<int>.from(json['starRatings'] as List? ?? []),
      propertyTypes: List<String>.from(json['propertyTypes'] as List? ?? []),
      amenities: List<String>.from(json['amenities'] as List? ?? []),
      minReviewScore: json['minReviewScore'] as double?,
      freeCancellation: json['freeCancellation'] as bool? ?? false,
      bookNowPayLater: json['bookNowPayLater'] as bool? ?? false,
      breakfastIncluded: json['breakfastIncluded'] as bool? ?? false,
      sortBy: json['sortBy'] as String? ?? 'recommended',
      maxDistanceKm: json['maxDistanceKm'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'starRatings': starRatings,
      'propertyTypes': propertyTypes,
      'amenities': amenities,
      'minReviewScore': minReviewScore,
      'freeCancellation': freeCancellation,
      'bookNowPayLater': bookNowPayLater,
      'breakfastIncluded': breakfastIncluded,
      'sortBy': sortBy,
      'maxDistanceKm': maxDistanceKm,
    };
  }

  SearchFilters copyWith({
    double? minPrice,
    double? maxPrice,
    List<int>? starRatings,
    List<String>? propertyTypes,
    List<String>? amenities,
    double? minReviewScore,
    bool? freeCancellation,
    bool? bookNowPayLater,
    bool? breakfastIncluded,
    String? sortBy,
    int? maxDistanceKm,
  }) {
    return SearchFilters(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      starRatings: starRatings ?? this.starRatings,
      propertyTypes: propertyTypes ?? this.propertyTypes,
      amenities: amenities ?? this.amenities,
      minReviewScore: minReviewScore ?? this.minReviewScore,
      freeCancellation: freeCancellation ?? this.freeCancellation,
      bookNowPayLater: bookNowPayLater ?? this.bookNowPayLater,
      breakfastIncluded: breakfastIncluded ?? this.breakfastIncluded,
      sortBy: sortBy ?? this.sortBy,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
    );
  }

  SearchFilters clearAll() {
    return const SearchFilters();
  }

  @override
  String toString() {
    return 'SearchFilters(activeFilters: $activeFilterCount, sortBy: $sortBy)';
  }
}

class SearchResult {
  final List<dynamic> results; // Can be Property, Flight, etc.
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final SearchCriteria searchCriteria;

  SearchResult({
    required this.results,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.searchCriteria,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json, SearchCriteria criteria) {
    return SearchResult(
      results: json['results'] as List,
      totalCount: json['totalCount'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      hasMore: json['hasMore'] as bool,
      searchCriteria: criteria,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results,
      'totalCount': totalCount,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'searchCriteria': searchCriteria.toJson(),
    };
  }

  @override
  String toString() {
    return 'SearchResult(totalCount: $totalCount, currentPage: $currentPage)';
  }
}

class RecentSearch {
  final String destination;
  final DateTime searchDate;
  final String serviceType;

  RecentSearch({
    required this.destination,
    required this.searchDate,
    required this.serviceType,
  });

  factory RecentSearch.fromJson(Map<String, dynamic> json) {
    return RecentSearch(
      destination: json['destination'] as String,
      searchDate: DateTime.parse(json['searchDate'] as String),
      serviceType: json['serviceType'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destination': destination,
      'searchDate': searchDate.toIso8601String(),
      'serviceType': serviceType,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecentSearch && 
           other.destination == destination &&
           other.serviceType == serviceType;
  }

  @override
  int get hashCode => destination.hashCode ^ serviceType.hashCode;

  @override
  String toString() {
    return 'RecentSearch(destination: $destination, serviceType: $serviceType)';
  }
}