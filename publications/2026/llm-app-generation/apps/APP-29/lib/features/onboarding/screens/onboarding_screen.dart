import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../chat/screens/chat_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to ChatGPT',
      description: 'Your AI assistant for instant answers, creative inspiration, and personalized learning.',
      icon: Icons.chat_bubble_outline,
      color: AppTheme.primaryColor,
    ),
    OnboardingPage(
      title: 'Voice Conversations',
      description: 'Have natural, real-time voice conversations with ChatGPT using advanced speech recognition.',
      icon: Icons.mic_outlined,
      color: AppTheme.successColor,
    ),
    OnboardingPage(
      title: 'Image Analysis',
      description: 'Upload photos for AI analysis, transcription, and detailed explanations of what you see.',
      icon: Icons.photo_camera_outlined,
      color: AppTheme.secondaryColor,
    ),
    OnboardingPage(
      title: 'Image Generation',
      description: 'Create stunning, original images from text descriptions using DALL-E integration.',
      icon: Icons.palette_outlined,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppTheme.primaryColor
                      : AppTheme.textTertiary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          if (_currentPage == _pages.length - 1) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _completeOnboarding(),
                child: const Text('Get Started'),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _completeOnboarding(),
              child: const Text('Skip for now'),
            ),
          ] else ...[
            Row(
              children: [
                TextButton(
                  onPressed: () => _completeOnboarding(),
                  child: const Text('Skip'),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _completeOnboarding() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.completeOnboarding();
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ChatScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}