import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';
import '../../shared/models/user.dart';

class AuthService {
  static const String _baseUrl = AppConstants.govBrBaseUrl;
  static const String _clientId = AppConstants.govBrClientId;
  static const String _redirectUri = AppConstants.govBrRedirectUri;
  static const String _scope = AppConstants.govBrScope;

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  SharedPreferences? _prefs;

  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Initiates the Gov.br OAuth flow
  Future<bool> loginWithGovBr() async {
    try {
      final authUrl = _buildAuthUrl();
      
      if (await canLaunchUrl(Uri.parse(authUrl))) {
        await launchUrl(
          Uri.parse(authUrl),
          mode: LaunchMode.externalApplication,
        );
        return true;
      } else {
        throw Exception('Could not launch Gov.br authentication URL');
      }
    } catch (e) {
      print('Error launching Gov.br auth: $e');
      return false;
    }
  }

  /// Builds the Gov.br OAuth authorization URL
  String _buildAuthUrl() {
    final params = {
      'response_type': 'code',
      'client_id': _clientId,
      'redirect_uri': _redirectUri,
      'scope': _scope,
      'state': _generateState(),
    };

    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$_baseUrl/oauth/authorize?$queryString';
  }

  /// Generates a random state parameter for OAuth security
  String _generateState() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Handles the OAuth callback and exchanges code for tokens
  Future<bool> handleAuthCallback(String code, String state) async {
    try {
      final tokenResponse = await _exchangeCodeForTokens(code);
      if (tokenResponse != null) {
        await saveTokens(tokenResponse);
        
        // Fetch user data
        final userData = await _fetchUserData(tokenResponse['access_token']);
        if (userData != null) {
          await saveUserData(userData);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error handling auth callback: $e');
      return false;
    }
  }

  /// Exchanges authorization code for access and refresh tokens
  Future<Map<String, dynamic>?> _exchangeCodeForTokens(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/oauth/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'grant_type': 'authorization_code',
          'client_id': _clientId,
          'code': code,
          'redirect_uri': _redirectUri,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Token exchange failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error exchanging code for tokens: $e');
      return null;
    }
  }

  /// Fetches user data from Gov.br using access token
  Future<Map<String, dynamic>?> _fetchUserData(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/oauth/userinfo'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('User data fetch failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  /// Saves authentication tokens to secure storage
  Future<void> saveTokens(Map<String, dynamic> tokens) async {
    await _initPrefs();
    await _prefs!.setString(AppConstants.accessTokenKey, tokens['access_token']);
    if (tokens['refresh_token'] != null) {
      await _prefs!.setString(AppConstants.refreshTokenKey, tokens['refresh_token']);
    }
    await _prefs!.setBool(AppConstants.isLoggedInKey, true);
  }

  /// Saves user data to local storage
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _initPrefs();
    
    // Transform Gov.br user data to our User model format
    final user = _transformGovBrUserData(userData);
    await _prefs!.setString(AppConstants.userDataKey, json.encode(user.toJson()));
  }

  /// Transforms Gov.br user data to our User model
  User _transformGovBrUserData(Map<String, dynamic> govBrData) {
    // This is a mock transformation - in real implementation,
    // you would need to map Gov.br fields to your User model
    return User(
      id: govBrData['sub'] ?? '',
      cpf: govBrData['cpf'] ?? '',
      cns: govBrData['cns'] ?? _generateMockCNS(),
      name: govBrData['name'] ?? '',
      email: govBrData['email'] ?? '',
      dateOfBirth: DateTime.tryParse(govBrData['birthdate'] ?? '') ?? DateTime.now(),
      gender: govBrData['gender'] ?? 'Não informado',
      phone: govBrData['phone_number'] ?? '',
      address: _createMockAddress(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Generates a mock CNS number for demo purposes
  String _generateMockCNS() {
    return '${DateTime.now().millisecondsSinceEpoch}'.substring(0, 15);
  }

  /// Creates a mock address for demo purposes
  Address _createMockAddress() {
    return Address(
      street: 'Rua das Flores',
      number: '123',
      neighborhood: 'Centro',
      city: 'Brasília',
      state: 'DF',
      zipCode: '70000-000',
    );
  }

  /// Gets the current access token
  Future<String?> getAccessToken() async {
    await _initPrefs();
    return _prefs!.getString(AppConstants.accessTokenKey);
  }

  /// Gets the current refresh token
  Future<String?> getRefreshToken() async {
    await _initPrefs();
    return _prefs!.getString(AppConstants.refreshTokenKey);
  }

  /// Gets the current user data
  Future<User?> getCurrentUser() async {
    await _initPrefs();
    final userDataString = _prefs!.getString(AppConstants.userDataKey);
    if (userDataString != null) {
      final userData = json.decode(userDataString) as Map<String, dynamic>;
      return User.fromJson(userData);
    }
    return null;
  }

  /// Checks if user is currently logged in
  Future<bool> isLoggedIn() async {
    await _initPrefs();
    return _prefs!.getBool(AppConstants.isLoggedInKey) ?? false;
  }

  /// Refreshes the access token using refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$_baseUrl/oauth/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'grant_type': 'refresh_token',
          'client_id': _clientId,
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final tokens = json.decode(response.body) as Map<String, dynamic>;
        await saveTokens(tokens);
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  /// Logs out the user and clears all stored data
  Future<void> logout() async {
    await _initPrefs();
    await _prefs!.remove(AppConstants.accessTokenKey);
    await _prefs!.remove(AppConstants.refreshTokenKey);
    await _prefs!.remove(AppConstants.userDataKey);
    await _prefs!.setBool(AppConstants.isLoggedInKey, false);
  }

  /// Makes authenticated API requests
  Future<http.Response?> authenticatedRequest(
    String url, {
    String method = 'GET',
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final authHeaders = {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...?headers,
      };

      http.Response response;
      final uri = Uri.parse(url);

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: authHeaders);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: authHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: authHeaders,
            body: body != null ? json.encode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: authHeaders);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Handle token expiration
      if (response.statusCode == 401) {
        final refreshed = await refreshToken();
        if (refreshed) {
          // Retry the request with new token
          return authenticatedRequest(url, method: method, headers: headers, body: body);
        } else {
          // Refresh failed, user needs to login again
          await logout();
          return null;
        }
      }

      return response;
    } catch (e) {
      print('Error making authenticated request: $e');
      return null;
    }
  }
}