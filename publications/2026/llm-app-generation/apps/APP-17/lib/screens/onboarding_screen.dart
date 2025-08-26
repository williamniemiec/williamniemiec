import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final StorageService _storageService = StorageService();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < AppConstants.onboardingTitles.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppConstants.mediumAnimation,
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    await _storageService.saveSetting('has_completed_onboarding', true);
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: AppTheme.defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: AppTheme.labelLarge.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: AppConstants.onboardingTitles.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(index);
                },
              ),
            ),
            
            // Page indicators
            Padding(
              padding: AppTheme.defaultPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  AppConstants.onboardingTitles.length,
                  (index) => _buildPageIndicator(index),
                ),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: AppTheme.defaultPadding,
              child: Row(
                children: [
                  // Back button
                  if (_currentPage > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPage,
                        child: const Text('Back'),
                      ),
                    ),
                  
                  if (_currentPage > 0) const SizedBox(width: 16),
                  
                  // Next/Get Started button
                  Expanded(
                    flex: _currentPage == 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == AppConstants.onboardingTitles.length - 1
                            ? 'Get Started'
                            : 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    return Padding(
      padding: AppTheme.defaultPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: _getGradientForPage(index),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              _getIconForPage(index),
              size: 80,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Title
          Text(
            AppConstants.onboardingTitles[index],
            style: AppTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Description
          Text(
            AppConstants.onboardingDescriptions[index],
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppTheme.primaryColor
            : AppTheme.textTertiary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  LinearGradient _getGradientForPage(int index) {
    switch (index) {
      case 0:
        return AppTheme.primaryGradient;
      case 1:
        return AppTheme.secondaryGradient;
      case 2:
        return AppTheme.accentGradient;
      case 3:
        return AppTheme.primaryGradient;
      default:
        return AppTheme.primaryGradient;
    }
  }

  IconData _getIconForPage(int index) {
    switch (index) {
      case 0:
        return Icons.local_cafe;
      case 1:
        return Icons.chat_bubble_outline;
      case 2:
        return Icons.person_outline;
      case 3:
        return Icons.favorite_outline;
      default:
        return Icons.local_cafe;
    }
  }
}