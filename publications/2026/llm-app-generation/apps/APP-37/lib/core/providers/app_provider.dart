import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/user.dart';
import '../../shared/models/location.dart';
import '../../shared/models/trip.dart';
import '../../shared/services/location_service.dart';
import '../../shared/services/trip_service.dart';

// User Provider
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void updateUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

// Current Location Provider
final currentLocationProvider = StateNotifierProvider<CurrentLocationNotifier, Location?>((ref) {
  return CurrentLocationNotifier();
});

class CurrentLocationNotifier extends StateNotifier<Location?> {
  CurrentLocationNotifier() : super(null) {
    _initializeLocation();
  }

  final LocationService _locationService = LocationService();

  void _initializeLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      if (location != null) {
        state = location;
      }
    } catch (e) {
      // Handle error silently for now
    }
  }

  void updateLocation(Location location) {
    state = location;
  }

  Future<void> refreshLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      if (location != null) {
        state = location;
      }
    } catch (e) {
      // Handle error
    }
  }
}

// Destination Provider
final destinationProvider = StateNotifierProvider<DestinationNotifier, Location?>((ref) {
  return DestinationNotifier();
});

class DestinationNotifier extends StateNotifier<Location?> {
  DestinationNotifier() : super(null);

  void setDestination(Location destination) {
    state = destination;
  }

  void clearDestination() {
    state = null;
  }
}

// Current Trip Provider
final currentTripProvider = StateNotifierProvider<CurrentTripNotifier, Trip?>((ref) {
  return CurrentTripNotifier();
});

class CurrentTripNotifier extends StateNotifier<Trip?> {
  CurrentTripNotifier() : super(null) {
    _initializeTrip();
  }

  final TripService _tripService = TripService();

  void _initializeTrip() {
    _tripService.currentTripStream.listen((trip) {
      state = trip;
    });
  }

  void setTrip(Trip trip) {
    state = trip;
  }

  void clearTrip() {
    state = null;
  }

  Future<void> cancelCurrentTrip() async {
    if (state != null) {
      await _tripService.cancelTrip(state!.id);
    }
  }
}

// Ride Options Provider
final rideOptionsProvider = StateNotifierProvider<RideOptionsNotifier, List<RideOption>>((ref) {
  return RideOptionsNotifier();
});

class RideOptionsNotifier extends StateNotifier<List<RideOption>> {
  RideOptionsNotifier() : super([]);

  final TripService _tripService = TripService();

  Future<void> loadRideOptions(Location pickup, Location destination) async {
    try {
      final options = await _tripService.getRideOptions(pickup, destination);
      state = options;
    } catch (e) {
      state = [];
    }
  }

  void clearOptions() {
    state = [];
  }
}

// App State Provider
final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

enum AppScreen {
  home,
  booking,
  trip,
  profile,
}

class AppState {
  final AppScreen currentScreen;
  final bool isLoading;
  final String? error;

  const AppState({
    this.currentScreen = AppScreen.home,
    this.isLoading = false,
    this.error,
  });

  AppState copyWith({
    AppScreen? currentScreen,
    bool? isLoading,
    String? error,
  }) {
    return AppState(
      currentScreen: currentScreen ?? this.currentScreen,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void setScreen(AppScreen screen) {
    state = state.copyWith(currentScreen: screen);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Saved Locations Provider
final savedLocationsProvider = StateNotifierProvider<SavedLocationsNotifier, List<SavedLocation>>((ref) {
  return SavedLocationsNotifier();
});

class SavedLocationsNotifier extends StateNotifier<List<SavedLocation>> {
  SavedLocationsNotifier() : super([]) {
    _loadSavedLocations();
  }

  void _loadSavedLocations() {
    // Mock saved locations
    state = [
      SavedLocation(
        id: '1',
        label: 'Home',
        location: const Location(
          latitude: 37.7749,
          longitude: -122.4194,
          address: '123 Main St, San Francisco, CA',
          name: 'Home',
        ),
      ),
      SavedLocation(
        id: '2',
        label: 'Work',
        location: const Location(
          latitude: 37.7849,
          longitude: -122.4094,
          address: '456 Market St, San Francisco, CA',
          name: 'Work',
        ),
      ),
    ];
  }

  void addSavedLocation(SavedLocation location) {
    state = [...state, location];
  }

  void removeSavedLocation(String id) {
    state = state.where((location) => location.id != id).toList();
  }

  void updateSavedLocation(SavedLocation location) {
    final index = state.indexWhere((l) => l.id == location.id);
    if (index != -1) {
      final newState = [...state];
      newState[index] = location;
      state = newState;
    }
  }
}

// Payment Methods Provider
final paymentMethodsProvider = StateNotifierProvider<PaymentMethodsNotifier, List<PaymentMethod>>((ref) {
  return PaymentMethodsNotifier();
});

class PaymentMethodsNotifier extends StateNotifier<List<PaymentMethod>> {
  PaymentMethodsNotifier() : super([]) {
    _loadPaymentMethods();
  }

  void _loadPaymentMethods() {
    // Mock payment methods
    state = [
      const PaymentMethod(
        id: '1',
        type: 'credit_card',
        displayName: 'Visa •••• 1234',
        last4Digits: '1234',
        brand: 'visa',
        isDefault: true,
      ),
      const PaymentMethod(
        id: '2',
        type: 'credit_card',
        displayName: 'Mastercard •••• 5678',
        last4Digits: '5678',
        brand: 'mastercard',
      ),
    ];
  }

  void addPaymentMethod(PaymentMethod method) {
    state = [...state, method];
  }

  void removePaymentMethod(String id) {
    state = state.where((method) => method.id != id).toList();
  }

  void setDefaultPaymentMethod(String id) {
    state = state.map((method) {
      return method.copyWith(isDefault: method.id == id);
    }).toList();
  }
}