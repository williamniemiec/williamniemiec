import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../shared/models/user.dart';
import '../constants/app_constants.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadUserFromStorage();
  }

  // Load user from local storage
  Future<void> _loadUserFromStorage() async {
    try {
      final userBox = Hive.box('user');
      final userData = userBox.get(AppConstants.userDataKey);
      
      if (userData != null) {
        _currentUser = User.fromJson(Map<String, dynamic>.from(userData));
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading user from storage: $e');
    }
  }

  // Save user to local storage
  Future<void> _saveUserToStorage() async {
    try {
      final userBox = Hive.box('user');
      if (_currentUser != null) {
        await userBox.put(AppConstants.userDataKey, _currentUser!.toJson());
      }
    } catch (e) {
      debugPrint('Error saving user to storage: $e');
    }
  }

  // Sign in with email and password
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock authentication - in real app, this would call your API
      if (email.isNotEmpty && password.length >= 6) {
        _currentUser = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          firstName: 'John',
          lastName: 'Doe',
          dateOfBirth: DateTime(1990, 1, 1),
          preferences: UserPreferences(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        _isAuthenticated = true;
        await _saveUserToStorage();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Sign in failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up with email and password
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock registration - in real app, this would call your API
      if (email.isNotEmpty && password.length >= 6) {
        _currentUser = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          firstName: firstName,
          lastName: lastName,
          dateOfBirth: dateOfBirth,
          preferences: UserPreferences(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        _isAuthenticated = true;
        await _saveUserToStorage();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Invalid registration data';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock Google sign in
      _currentUser = User(
        id: 'google_user_${DateTime.now().millisecondsSinceEpoch}',
        email: 'user@gmail.com',
        firstName: 'Google',
        lastName: 'User',
        dateOfBirth: DateTime(1990, 1, 1),
        preferences: UserPreferences(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      _isAuthenticated = true;
      await _saveUserToStorage();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Google sign in failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Clear user data from storage
      final userBox = Hive.box('user');
      await userBox.clear();

      // Clear cart and wishlist
      final cartBox = Hive.box('cart');
      final wishlistBox = Hive.box('wishlist');
      await cartBox.clear();
      await wishlistBox.clear();

      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Sign out failed';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user profile
  Future<bool> updateProfile(User updatedUser) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = updatedUser.copyWith(updatedAt: DateTime.now());
      await _saveUserToStorage();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Profile update failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add address
  Future<bool> addAddress(Address address) async {
    if (_currentUser == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final updatedAddresses = List<Address>.from(_currentUser!.addresses);
      
      // If this is the first address or marked as default, make it default
      if (updatedAddresses.isEmpty || address.isDefault) {
        // Remove default from other addresses
        for (int i = 0; i < updatedAddresses.length; i++) {
          updatedAddresses[i] = Address(
            id: updatedAddresses[i].id,
            label: updatedAddresses[i].label,
            firstName: updatedAddresses[i].firstName,
            lastName: updatedAddresses[i].lastName,
            addressLine1: updatedAddresses[i].addressLine1,
            addressLine2: updatedAddresses[i].addressLine2,
            city: updatedAddresses[i].city,
            state: updatedAddresses[i].state,
            zipCode: updatedAddresses[i].zipCode,
            country: updatedAddresses[i].country,
            phoneNumber: updatedAddresses[i].phoneNumber,
            isDefault: false,
          );
        }
      }
      
      updatedAddresses.add(address);
      
      _currentUser = _currentUser!.copyWith(
        addresses: updatedAddresses,
        updatedAt: DateTime.now(),
      );
      
      await _saveUserToStorage();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add address';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add payment method
  Future<bool> addPaymentMethod(PaymentMethod paymentMethod) async {
    if (_currentUser == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final updatedPaymentMethods = List<PaymentMethod>.from(_currentUser!.paymentMethods);
      
      // If this is the first payment method or marked as default, make it default
      if (updatedPaymentMethods.isEmpty || paymentMethod.isDefault) {
        // Remove default from other payment methods
        for (int i = 0; i < updatedPaymentMethods.length; i++) {
          updatedPaymentMethods[i] = PaymentMethod(
            id: updatedPaymentMethods[i].id,
            type: updatedPaymentMethods[i].type,
            cardNumber: updatedPaymentMethods[i].cardNumber,
            cardHolderName: updatedPaymentMethods[i].cardHolderName,
            expiryMonth: updatedPaymentMethods[i].expiryMonth,
            expiryYear: updatedPaymentMethods[i].expiryYear,
            billingAddressId: updatedPaymentMethods[i].billingAddressId,
            isDefault: false,
          );
        }
      }
      
      updatedPaymentMethods.add(paymentMethod);
      
      _currentUser = _currentUser!.copyWith(
        paymentMethods: updatedPaymentMethods,
        updatedAt: DateTime.now(),
      );
      
      await _saveUserToStorage();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add payment method';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Check if user is guest
  bool get isGuest => !_isAuthenticated;
}