import 'package:flutter/material.dart';
import '../../features/chats/screens/chats_screen.dart';
import '../../features/updates/screens/updates_screen.dart';
import '../../features/calls/screens/calls_screen.dart';
import '../../features/tools/screens/tools_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatsScreen(),
    const UpdatesScreen(),
    const CallsScreen(),
    const ToolsScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: 'Chats',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.update),
      label: 'Updates',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.call),
      label: 'Calls',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Tools',
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navigationItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}