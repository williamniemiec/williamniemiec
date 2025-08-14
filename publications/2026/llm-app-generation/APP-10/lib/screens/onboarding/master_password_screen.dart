import 'package:flutter/material.dart';
import 'package:aegis_vault/utils/app_constants.dart';
import 'package:aegis_vault/widgets/custom_text_field.dart';
import 'package:aegis_vault/widgets/password_strength_indicator.dart';
import 'package:aegis_vault/services/password_strength_service.dart';
import 'package:aegis_vault/services/auth_service.dart';

class MasterPasswordScreen extends StatefulWidget {
  final VoidCallback onNext;

  const MasterPasswordScreen({super.key, required this.onNext});

  @override
  _MasterPasswordScreenState createState() => _MasterPasswordScreenState();
}

class _MasterPasswordScreenState extends State<MasterPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  double _passwordStrength = 0;
  bool _passwordsMatch = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
    _confirmPasswordController.addListener(_checkPasswordsMatch);
  }

  void _updatePasswordStrength() {
    setState(() {
      _passwordStrength =
          PasswordStrengthService.calculateStrength(_passwordController.text);
    });
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Create Master Password', style: kTitleStyle),
            const SizedBox(height: kDefaultPadding),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Master Password',
              obscureText: true,
            ),
            const SizedBox(height: kDefaultPadding),
            PasswordStrengthIndicator(strength: _passwordStrength),
            const SizedBox(height: kDefaultPadding),
            CustomTextField(
              controller: _confirmPasswordController,
              labelText: 'Confirm Password',
              obscureText: true,
            ),
            const SizedBox(height: kDefaultPadding * 2),
            ElevatedButton(
              onPressed: _passwordsMatch && !_isLoading
                  ? () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _authService
                          .createMasterPassword(_passwordController.text);
                      setState(() {
                        _isLoading = false;
                      });
                      widget.onNext();
                    }
                  : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}