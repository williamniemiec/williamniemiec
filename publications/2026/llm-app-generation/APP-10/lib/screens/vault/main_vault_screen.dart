import 'package:flutter/material.dart';
import 'package:aegis_vault/services/auth_service.dart';
import 'package:aegis_vault/utils/app_constants.dart';
import 'package:aegis_vault/widgets/custom_text_field.dart';
import 'package:aegis_vault/screens/vault/vault_contents_screen.dart';

class MainVaultScreen extends StatefulWidget {
  const MainVaultScreen({super.key});

  @override
  _MainVaultScreenState createState() => _MainVaultScreenState();
}

class _MainVaultScreenState extends State<MainVaultScreen> {
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Aegis Vault', style: kTitleStyle),
            const SizedBox(height: kDefaultPadding * 2),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Master Password',
              obscureText: true,
            ),
            const SizedBox(height: kDefaultPadding * 2),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });
                      final isAuthenticated = await _authService
                          .verifyMasterPassword(_passwordController.text);
                      setState(() {
                        _isLoading = false;
                      });
                      if (isAuthenticated) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VaultContentsScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid password'),
                          ),
                        );
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}