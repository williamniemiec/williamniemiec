import 'package:flutter/foundation.dart';
import '../../../shared/models/business_profile.dart';

class BusinessProfileProvider extends ChangeNotifier {
  BusinessProfile? _businessProfile;
  bool _isLoading = false;
  String? _error;

  BusinessProfile? get businessProfile => _businessProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBusinessProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load sample business profile or create default one
      _businessProfile = _getDefaultBusinessProfile();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBusinessProfile(BusinessProfile profile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate saving delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      _businessProfile = profile.copyWith(updatedAt: DateTime.now());
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBusinessHours(BusinessHours businessHours) async {
    if (_businessProfile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      _businessProfile = _businessProfile!.copyWith(
        businessHours: businessHours,
        updatedAt: DateTime.now(),
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateLogo(String logoUrl) async {
    if (_businessProfile == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      _businessProfile = _businessProfile!.copyWith(
        logoUrl: logoUrl,
        updatedAt: DateTime.now(),
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  BusinessProfile _getDefaultBusinessProfile() {
    final now = DateTime.now();
    return BusinessProfile(
      id: 'business_1',
      businessName: 'My Business',
      description: 'Welcome to our business! We provide quality products and services.',
      category: 'Retail',
      email: 'contact@mybusiness.com',
      website: 'https://mybusiness.com',
      address: '123 Business Street, City, State 12345',
      businessHours: BusinessHours(
        timezone: 'UTC',
        schedule: {
          'monday': const DayHours(isOpen: true, openTime: '09:00', closeTime: '18:00'),
          'tuesday': const DayHours(isOpen: true, openTime: '09:00', closeTime: '18:00'),
          'wednesday': const DayHours(isOpen: true, openTime: '09:00', closeTime: '18:00'),
          'thursday': const DayHours(isOpen: true, openTime: '09:00', closeTime: '18:00'),
          'friday': const DayHours(isOpen: true, openTime: '09:00', closeTime: '18:00'),
          'saturday': const DayHours(isOpen: true, openTime: '10:00', closeTime: '16:00'),
          'sunday': const DayHours(isOpen: false),
        },
      ),
      isVerified: false,
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now,
    );
  }
}