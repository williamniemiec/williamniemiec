import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/home/screens/home_screen.dart';
import 'features/discover/screens/discover_screen.dart';
import 'features/camera/screens/camera_screen.dart';
import 'features/inbox/screens/inbox_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() {
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoverScreen(),
    const CameraScreen(),
    const InboxScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      // Camera screen - navigate directly without changing bottom nav
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );
      return;
    }
    
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: AppConstants.shortAnimation,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index != 2) { // Skip camera index
            setState(() {
              _currentIndex = index;
            });
          }
        },
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppConstants.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppConstants.backgroundColor,
          selectedItemColor: AppConstants.textPrimaryColor,
          unselectedItemColor: AppConstants.textSecondaryColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: 45,
                height: 30,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppConstants.primaryColor,
                      AppConstants.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Inbox',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
