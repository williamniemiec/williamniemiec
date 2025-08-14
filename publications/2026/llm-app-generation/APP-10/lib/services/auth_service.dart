import 'dart:math';
import 'package:aegis_vault/services/encryption_service.dart';
import 'package:aegis_vault/services/secure_storage_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final SecureStorageService _secureStorageService = SecureStorageService();
  final EncryptionService _encryptionService = EncryptionService();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> createMasterPassword(String password) async {
    final salt = _generateSalt();
    final hashedPassword = await _encryptionService.encrypt(password, password, salt);
    await _secureStorageService.write('master_password_hash', hashedPassword);
    await _secureStorageService.write('salt', salt);
  }

  Future<bool> verifyMasterPassword(String password) async {
    final hashedPassword = await _secureStorageService.read('master_password_hash');
    final salt = await _secureStorageService.read('salt');

    if (hashedPassword == null || salt == null) {
      return false;
    }

    final decryptedPassword = await _encryptionService.decrypt(hashedPassword, password, salt);
    return decryptedPassword == password;
  }

  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (index) => random.nextInt(256));
    return String.fromCharCodes(saltBytes);
  }
}