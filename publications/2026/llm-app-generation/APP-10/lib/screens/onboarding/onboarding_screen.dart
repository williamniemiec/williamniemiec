import 'package:flutter/material.dart';
import 'package:aegis_vault/screens/onboarding/master_password_screen.dart';
import 'package:aegis_vault/screens/onboarding/recovery_key_screen.dart';
import 'package:aegis_vault/screens/onboarding/biometric_setup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<Widget> _onboardingPages;

  @override
  void initState() {
    super.initState();
    _onboardingPages = [
      MasterPasswordScreen(onNext: _goToNextPage),
      RecoveryKeyScreen(onNext: _goToNextPage),
      BiometricSetupScreen(onNext: _goToNextPage),
    ];
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _onboardingPages,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}