import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();

  factory EncryptionService() {
    return _instance;
  }

  EncryptionService._internal();

  Future<encrypt_lib.Encrypter> _getEncrypter(String password, String salt) async {
    final key = await _deriveKey(password, salt);
    return encrypt_lib.Encrypter(encrypt_lib.AES(key));
  }

  Future<encrypt_lib.Key> _deriveKey(String password, String salt) async {
    final saltBytes = Uint8List.fromList(salt.codeUnits);
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
      ..init(Pbkdf2Parameters(saltBytes, 100000, 32));
    return encrypt_lib.Key(pbkdf2.process(Uint8List.fromList(password.codeUnits)));
  }

  Future<String> encrypt(String data, String password, String salt) async {
    final encrypter = await _getEncrypter(password, salt);
    final iv = encrypt_lib.IV.fromSecureRandom(16);
    final encrypted = encrypter.encrypt(data, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  Future<String> decrypt(String data, String password, String salt) async {
    final encrypter = await _getEncrypter(password, salt);
    final parts = data.split(':');
    final iv = encrypt_lib.IV.fromBase64(parts[0]);
    final encrypted = encrypt_lib.Encrypted.fromBase64(parts[1]);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}