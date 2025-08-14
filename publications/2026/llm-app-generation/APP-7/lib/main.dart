import 'package:flutter/material.dart';
import 'package:guardian_firewall/screens/activity_log_screen.dart';
import 'package:guardian_firewall/screens/dashboard_screen.dart';
import 'package:guardian_firewall/screens/firewall_screen.dart';

void main() {
  runApp(const GuardianFirewallApp());
}

class GuardianFirewallApp extends StatelessWidget {
  const GuardianFirewallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guardian Firewall',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const DashboardScreen(),
    const FirewallScreen(),
    const ActivityLogScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: 'Firewall',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity',
          ),
        ],
      ),
    );
  }
}
