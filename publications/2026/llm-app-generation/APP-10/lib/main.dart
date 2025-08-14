import 'package:flutter/material.dart';
import 'package:aegis_vault/screens/onboarding/onboarding_screen.dart';
import 'package:aegis_vault/screens/vault/main_vault_screen.dart';
import 'package:aegis_vault/services/secure_storage_service.dart';
import 'package:aegis_vault/services/rasp_service.dart';
import 'package:aegis_vault/screens/jailbreak_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final raspService = RaspService();
  final isJailbroken = await raspService.isJailbroken();
  if (isJailbroken) {
    runApp(const JailbreakApp());
    return;
  }

  final secureStorageService = SecureStorageService();
  final masterPasswordHash = await secureStorageService.read('master_password_hash');
  runApp(AegisVaultApp(isFirstTime: masterPasswordHash == null));
}

class AegisVaultApp extends StatelessWidget {
  final bool isFirstTime;

  const AegisVaultApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aegis Vault',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[900],
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.white,
          secondary: Colors.tealAccent,
        ),
      ),
      home: isFirstTime ? const OnboardingScreen() : const MainVaultScreen(),
    );
  }
}

class JailbreakApp extends StatelessWidget {
  const JailbreakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: JailbreakScreen(),
    );
  }
}
