import 'package:flutter/foundation.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/models/user.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _state == AuthState.authenticated;

  /// Initialize the auth provider and check if user is already logged in
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          _currentUser = user;
          _setState(AuthState.authenticated);
        } else {
          _setState(AuthState.unauthenticated);
        }
      } else {
        _setState(AuthState.unauthenticated);
      }
    } catch (e) {
      _setError('Erro ao inicializar autenticação: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Initiates login with Gov.br
  Future<bool> loginWithGovBr() async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.loginWithGovBr();
      if (!success) {
        _setError('Não foi possível abrir a página de autenticação do Gov.br');
        return false;
      }
      
      // The actual authentication will be completed in handleAuthCallback
      return true;
    } catch (e) {
      _setError('Erro ao iniciar login: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Handles the OAuth callback from Gov.br
  Future<bool> handleAuthCallback(String code, String state) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authService.handleAuthCallback(code, state);
      if (success) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          _currentUser = user;
          _setState(AuthState.authenticated);
          return true;
        }
      }
      
      _setError('Falha na autenticação com Gov.br');
      return false;
    } catch (e) {
      _setError('Erro durante autenticação: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refreshes the current user data
  Future<void> refreshUserData() async {
    if (!isAuthenticated) return;

    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    }
  }

  /// Updates user profile information
  Future<bool> updateUserProfile(User updatedUser) async {
    if (!isAuthenticated) return false;

    _setLoading(true);
    _clearError();

    try {
      // In a real app, you would make an API call to update the user profile
      // For now, we'll just update the local data
      _currentUser = updatedUser;
      
      // Save updated user data locally
      await _authService.saveUserData(updatedUser.toJson());
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Erro ao atualizar perfil: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates donor status (organ or blood donor)
  Future<bool> updateDonorStatus({bool? isOrganDonor, bool? isBloodDonor}) async {
    if (!isAuthenticated || _currentUser == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final updatedUser = _currentUser!.copyWith(
        isOrganDonor: isOrganDonor ?? _currentUser!.isOrganDonor,
        isBloodDonor: isBloodDonor ?? _currentUser!.isBloodDonor,
        updatedAt: DateTime.now(),
      );

      return await updateUserProfile(updatedUser);
    } catch (e) {
      _setError('Erro ao atualizar status de doador: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _authService.logout();
      _currentUser = null;
      _setState(AuthState.unauthenticated);
    } catch (e) {
      _setError('Erro ao fazer logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Checks if the current session is still valid
  Future<bool> validateSession() async {
    if (!isAuthenticated) return false;

    try {
      final accessToken = await _authService.getAccessToken();
      if (accessToken == null) {
        await logout();
        return false;
      }

      // Try to refresh token if needed
      final refreshed = await _authService.refreshToken();
      if (!refreshed) {
        await logout();
        return false;
      }

      return true;
    } catch (e) {
      print('Error validating session: $e');
      await logout();
      return false;
    }
  }

  /// Gets the current access token for API calls
  Future<String?> getAccessToken() async {
    return await _authService.getAccessToken();
  }

  /// Makes an authenticated API request
  Future<dynamic> makeAuthenticatedRequest(
    String url, {
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await _authService.authenticatedRequest(
        url,
        method: method,
        headers: headers,
        body: body,
      );

      if (response == null) {
        // Token might have expired and refresh failed
        if (isAuthenticated) {
          await logout();
        }
        return null;
      }

      return response;
    } catch (e) {
      print('Error making authenticated request: $e');
      return null;
    }
  }

  // Private helper methods
  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = AuthState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = _currentUser != null ? AuthState.authenticated : AuthState.unauthenticated;
    }
    notifyListeners();
  }

  /// Simulates a successful login for demo purposes
  Future<bool> simulateLogin() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Create a mock user for demo
      final mockUser = User(
        id: 'demo_user_123',
        cpf: '123.456.789-00',
        cns: '123456789012345',
        name: 'João Silva Santos',
        email: 'joao.silva@email.com',
        dateOfBirth: DateTime(1985, 5, 15),
        gender: 'Masculino',
        phone: '(61) 99999-9999',
        address: Address(
          street: 'SQN 123 Bloco A',
          number: '123',
          complement: 'Apt 456',
          neighborhood: 'Asa Norte',
          city: 'Brasília',
          state: 'DF',
          zipCode: '70000-000',
        ),
        isOrganDonor: true,
        isBloodDonor: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _currentUser = mockUser;
      _setState(AuthState.authenticated);
      
      // Save mock data locally
      await _authService.saveUserData(mockUser.toJson());
      await _authService.saveTokens({
        'access_token': 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        'refresh_token': 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      });

      return true;
    } catch (e) {
      _setError('Erro na simulação de login: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}