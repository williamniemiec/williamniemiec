import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../shared/models/user.dart';

class LocationProvider extends ChangeNotifier {
  Address? _currentAddress;
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;
  bool _locationPermissionGranted = false;

  Address? get currentAddress => _currentAddress;
  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get locationPermissionGranted => _locationPermissionGranted;

  Future<void> requestLocationPermission() async {
    _setLoading(true);
    _error = null;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = 'Serviços de localização estão desabilitados.';
        _setLoading(false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Permissão de localização negada.';
          _setLoading(false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Permissão de localização negada permanentemente.';
        _setLoading(false);
        return;
      }

      _locationPermissionGranted = true;
      await getCurrentLocation();
    } catch (e) {
      _error = 'Erro ao solicitar permissão de localização.';
      _setLoading(false);
    }
  }

  Future<void> getCurrentLocation() async {
    if (!_locationPermissionGranted) {
      await requestLocationPermission();
      return;
    }

    _setLoading(true);
    _error = null;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        
        _currentAddress = Address(
          id: 'current_location',
          label: 'Localização Atual',
          street: placemark.street ?? '',
          number: placemark.subThoroughfare ?? '',
          neighborhood: placemark.subLocality ?? '',
          city: placemark.locality ?? '',
          state: placemark.administrativeArea ?? '',
          zipCode: placemark.postalCode ?? '',
          latitude: position.latitude,
          longitude: position.longitude,
          isDefault: false,
        );
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _error = 'Erro ao obter localização atual.';
      _setLoading(false);
    }
  }

  Future<List<Address>> searchAddresses(String query) async {
    if (query.isEmpty) return [];

    try {
      List<Location> locations = await locationFromAddress(query);
      List<Address> addresses = [];

      for (Location location in locations) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark placemark = placemarks.first;
            
            addresses.add(Address(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              label: 'Endereço',
              street: placemark.street ?? '',
              number: placemark.subThoroughfare ?? '',
              neighborhood: placemark.subLocality ?? '',
              city: placemark.locality ?? '',
              state: placemark.administrativeArea ?? '',
              zipCode: placemark.postalCode ?? '',
              latitude: location.latitude,
              longitude: location.longitude,
              isDefault: false,
            ));
          }
        } catch (e) {
          // Skip this location if geocoding fails
          continue;
        }
      }

      return addresses;
    } catch (e) {
      return [];
    }
  }

  Future<Address?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        
        return Address(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          label: 'Endereço',
          street: placemark.street ?? '',
          number: placemark.subThoroughfare ?? '',
          neighborhood: placemark.subLocality ?? '',
          city: placemark.locality ?? '',
          state: placemark.administrativeArea ?? '',
          zipCode: placemark.postalCode ?? '',
          latitude: latitude,
          longitude: longitude,
          isDefault: false,
        );
      }
    } catch (e) {
      // Return null if geocoding fails
    }
    
    return null;
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }

  void setCurrentAddress(Address address) {
    _currentAddress = address;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get delivery time estimate based on distance
  int getEstimatedDeliveryTime(double restaurantLat, double restaurantLon) {
    if (_currentPosition == null) return 30; // Default 30 minutes

    double distance = calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      restaurantLat,
      restaurantLon,
    );

    // Simple calculation: base time + distance factor
    int baseTime = 20; // 20 minutes base
    int distanceTime = (distance / 1000 * 5).round(); // 5 minutes per km
    
    return baseTime + distanceTime;
  }

  // Check if location is within delivery area
  bool isWithinDeliveryArea(double restaurantLat, double restaurantLon, double maxDeliveryDistance) {
    if (_currentPosition == null) return true; // Allow if no location

    double distance = calculateDistance(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      restaurantLat,
      restaurantLon,
    );

    return distance <= maxDeliveryDistance;
  }
}