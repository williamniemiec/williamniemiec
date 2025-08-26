import 'package:flutter/foundation.dart';
import '../../../shared/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  // Mock authentication - in a real app, this would connect to a backend
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock user data
      _currentUser = User(
        id: '1',
        name: 'João Silva',
        email: email,
        phone: '+55 11 99999-9999',
        profileImage: 'https://via.placeholder.com/150',
        addresses: [
          Address(
            id: '1',
            label: 'Casa',
            street: 'Rua das Flores',
            number: '123',
            complement: 'Apto 45',
            neighborhood: 'Centro',
            city: 'São Paulo',
            state: 'SP',
            zipCode: '01234-567',
            latitude: -23.5505,
            longitude: -46.6333,
            isDefault: true,
          ),
        ],
        paymentMethods: [
          PaymentMethod(
            id: '1',
            type: PaymentType.creditCard,
            label: 'Cartão de Crédito **** 1234',
            cardNumber: '1234',
            cardBrand: 'Visa',
            isDefault: true,
          ),
          PaymentMethod(
            id: '2',
            type: PaymentType.pix,
            label: 'PIX',
            isDefault: false,
          ),
        ],
        isClubeMember: false,
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao fazer login. Tente novamente.';
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _setLoading(true);
    _error = null;

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        addresses: [],
        paymentMethods: [],
        isClubeMember: false,
      );

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erro ao criar conta. Tente novamente.';
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void addAddress(Address address) {
    if (_currentUser != null) {
      final updatedAddresses = List<Address>.from(_currentUser!.addresses);
      
      // If this is the first address or marked as default, make it default
      if (updatedAddresses.isEmpty || address.isDefault) {
        // Remove default from other addresses
        updatedAddresses.forEach((addr) {
          if (addr.isDefault) {
            updatedAddresses[updatedAddresses.indexOf(addr)] = Address(
              id: addr.id,
              label: addr.label,
              street: addr.street,
              number: addr.number,
              complement: addr.complement,
              neighborhood: addr.neighborhood,
              city: addr.city,
              state: addr.state,
              zipCode: addr.zipCode,
              latitude: addr.latitude,
              longitude: addr.longitude,
              isDefault: false,
            );
          }
        });
      }
      
      updatedAddresses.add(address);
      
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        addresses: updatedAddresses,
        paymentMethods: _currentUser!.paymentMethods,
        isClubeMember: _currentUser!.isClubeMember,
        clubeExpiryDate: _currentUser!.clubeExpiryDate,
      );
      
      notifyListeners();
    }
  }

  void removeAddress(String addressId) {
    if (_currentUser != null) {
      final updatedAddresses = _currentUser!.addresses
          .where((addr) => addr.id != addressId)
          .toList();
      
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        addresses: updatedAddresses,
        paymentMethods: _currentUser!.paymentMethods,
        isClubeMember: _currentUser!.isClubeMember,
        clubeExpiryDate: _currentUser!.clubeExpiryDate,
      );
      
      notifyListeners();
    }
  }

  void addPaymentMethod(PaymentMethod paymentMethod) {
    if (_currentUser != null) {
      final updatedPaymentMethods = List<PaymentMethod>.from(_currentUser!.paymentMethods);
      
      // If this is marked as default, remove default from others
      if (paymentMethod.isDefault) {
        updatedPaymentMethods.forEach((method) {
          if (method.isDefault) {
            updatedPaymentMethods[updatedPaymentMethods.indexOf(method)] = PaymentMethod(
              id: method.id,
              type: method.type,
              label: method.label,
              cardNumber: method.cardNumber,
              cardBrand: method.cardBrand,
              isDefault: false,
            );
          }
        });
      }
      
      updatedPaymentMethods.add(paymentMethod);
      
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        addresses: _currentUser!.addresses,
        paymentMethods: updatedPaymentMethods,
        isClubeMember: _currentUser!.isClubeMember,
        clubeExpiryDate: _currentUser!.clubeExpiryDate,
      );
      
      notifyListeners();
    }
  }

  void removePaymentMethod(String paymentMethodId) {
    if (_currentUser != null) {
      final updatedPaymentMethods = _currentUser!.paymentMethods
          .where((method) => method.id != paymentMethodId)
          .toList();
      
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        addresses: _currentUser!.addresses,
        paymentMethods: updatedPaymentMethods,
        isClubeMember: _currentUser!.isClubeMember,
        clubeExpiryDate: _currentUser!.clubeExpiryDate,
      );
      
      notifyListeners();
    }
  }

  void subscribeToClube() {
    if (_currentUser != null) {
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profileImage: _currentUser!.profileImage,
        addresses: _currentUser!.addresses,
        paymentMethods: _currentUser!.paymentMethods,
        isClubeMember: true,
        clubeExpiryDate: DateTime.now().add(const Duration(days: 30)),
      );
      
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}