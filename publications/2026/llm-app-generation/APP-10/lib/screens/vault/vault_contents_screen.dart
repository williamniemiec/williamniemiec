import 'package:flutter/material.dart';
import 'package:aegis_vault/models/vault_item.dart';
import 'package:aegis_vault/services/vault_service.dart';
import 'package:aegis_vault/services/auth_service.dart';

class VaultContentsScreen extends StatefulWidget {
  const VaultContentsScreen({super.key});

  @override
  _VaultContentsScreenState createState() => _VaultContentsScreenState();
}

class _VaultContentsScreenState extends State<VaultContentsScreen> {
  final VaultService _vaultService = VaultService();
  final AuthService _authService = AuthService();
  Future<List<VaultItem>>? _vaultItems;
  String? _password;

  @override
  void initState() {
    super.initState();
    _loadVaultItems();
  }

  Future<void> _loadVaultItems() async {
    // In a real app, you would securely get the password.
    // For now, we'll retrieve it from secure storage for simplicity.
    final password = await _authService.verifyMasterPassword('');
    setState(() {
      _password = '';
      _vaultItems = _vaultService.getVaultItems(_password!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen
            },
          ),
        ],
      ),
      body: FutureBuilder<List<VaultItem>>(
        future: _vaultItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items in vault'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.type.toString()),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show add item dialog
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}