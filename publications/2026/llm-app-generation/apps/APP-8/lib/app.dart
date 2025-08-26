import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'features/learn/screens/learn_screen.dart';
import 'features/stories/screens/stories_screen.dart';
import 'features/practice/screens/practice_screen.dart';
import 'features/leaderboards/screens/leaderboards_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'shared/widgets/custom_bottom_navigation_bar.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const LearnScreen(),
    const StoriesScreen(),
    const PracticeScreen(),
    const LeaderboardsScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.school_outlined),
      activeIcon: Icon(Icons.school),
      label: 'Learn',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.book_outlined),
      activeIcon: Icon(Icons.book),
      label: 'Stories',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.fitness_center_outlined),
      activeIcon: Icon(Icons.fitness_center),
      label: 'Practice',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.leaderboard_outlined),
      activeIcon: Icon(Icons.leaderboard),
      label: 'Leagues',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navigationItems,
        onTap: _onTabTapped,
      ),
    );
  }
}