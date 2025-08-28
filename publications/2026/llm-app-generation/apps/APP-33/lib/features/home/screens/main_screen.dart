import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import 'home_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../compose/screens/compose_screen.dart';
import '../../activity/screens/activity_screen.dart';
import '../../profile/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const SizedBox.shrink(), // Placeholder for compose (modal)
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // Show compose modal instead of navigating
      _showComposeModal();
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

  void _showComposeModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ComposeScreen(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (index != 2) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        children: _screens,
      ),
      bottomNavigationBar: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).textTheme.bodySmall?.color,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.search_outlined),
                  activeIcon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                    ),
                  ),
                  label: 'Compose',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(Icons.favorite_outline),
                      if (appProvider.unreadActivitiesCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              appProvider.unreadActivitiesCount > 99
                                  ? '99+'
                                  : appProvider.unreadActivitiesCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  activeIcon: Stack(
                    children: [
                      const Icon(Icons.favorite),
                      if (appProvider.unreadActivitiesCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              appProvider.unreadActivitiesCount > 99
                                  ? '99+'
                                  : appProvider.unreadActivitiesCount.toString(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onError,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Activity',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}