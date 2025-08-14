import 'dart:convert';
import 'package:aegis_vault/models/vault_item.dart';
import 'package:aegis_vault/services/encryption_service.dart';
import 'package:aegis_vault/services/secure_storage_service.dart';
import 'package:uuid/uuid.dart';

class VaultService {
  static final VaultService _instance = VaultService._internal();
  final SecureStorageService _secureStorageService = SecureStorageService();
  final EncryptionService _encryptionService = EncryptionService();
  final Uuid _uuid = const Uuid();

  factory VaultService() {
    return _instance;
  }

  VaultService._internal();

  Future<List<VaultItem>> getVaultItems(String password) async {
    final salt = await _secureStorageService.read('salt');
    if (salt == null) {
      return [];
    }

    final encryptedVault = await _secureStorageService.read('vault');
    if (encryptedVault == null) {
      return [];
    }

    final decryptedVault = await _encryptionService.decrypt(encryptedVault, password, salt);
    final vaultData = jsonDecode(decryptedVault) as List;
    return vaultData.map((item) => VaultItem.fromMap(item)).toList();
  }

  Future<void> addVaultItem(VaultItem item, String password) async {
    final items = await getVaultItems(password);
    items.add(item);
    await _saveVault(items, password);
  }

  Future<void> updateVaultItem(VaultItem item, String password) async {
    final items = await getVaultItems(password);
    final index = items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      items[index] = item;
      await _saveVault(items, password);
    }
  }

  Future<void> deleteVaultItem(String id, String password) async {
    final items = await getVaultItems(password);
    items.removeWhere((item) => item.id == id);
    await _saveVault(items, password);
  }

  Future<void> _saveVault(List<VaultItem> items, String password) async {
    final salt = await _secureStorageService.read('salt');
    if (salt == null) {
      return;
    }

    final vaultData = items.map((item) => item.toMap()).toList();
    final encryptedVault = await _encryptionService.encrypt(jsonEncode(vaultData), password, salt);
    await _secureStorageService.write('vault', encryptedVault);
  }

  String generateId() {
    return _uuid.v4();
  }
}