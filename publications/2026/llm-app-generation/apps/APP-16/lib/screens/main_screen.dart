import 'package:flutter/material.dart';
import 'tracker_screen.dart';
import 'history_screen.dart';
import 'stats_screen.dart';
import 'insights_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TrackerScreen(),
    const HistoryScreen(),
    const StatsScreen(),
    const InsightsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Tracker',
      tooltip: 'Blood Pressure Tracker',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'History',
      tooltip: 'Reading History',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.analytics),
      label: 'Stats',
      tooltip: 'Statistics & Charts',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.lightbulb),
      label: 'Insights',
      tooltip: 'Health Insights',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: _bottomNavItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}