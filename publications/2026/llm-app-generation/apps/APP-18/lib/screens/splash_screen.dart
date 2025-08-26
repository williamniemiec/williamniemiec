import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToMain();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.splashScreenDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  void _navigateToMain() {
    Future.delayed(AppConstants.splashScreenDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pinterest Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.shadowColorDark,
                            blurRadius: AppTheme.elevationLarge,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.push_pin,
                        size: 60,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    // App Name
                    const Text(
                      AppConstants.appName,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeHeading,
                        fontWeight: AppTheme.fontWeightBold,
                        color: AppTheme.white,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    // App Description
                    const Text(
                      AppConstants.appDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTheme.fontSizeMedium,
                        fontWeight: AppTheme.fontWeightRegular,
                        color: AppTheme.white,
                        fontFamily: AppTheme.fontFamily,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                    // Loading Indicator
                    const SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
                        strokeWidth: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}