import 'package:flutter/material.dart';
import 'package:nfc_tag_commander/screens/history_tab.dart';
import 'package:nfc_tag_commander/screens/read_tab.dart';
import 'package:nfc_tag_commander/screens/write_tab.dart';
import 'package:nfc_tag_commander/services/history_service.dart';
import 'package:nfc_tag_commander/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryService(),
      child: MaterialApp(
        title: 'NFC Tag Commander',
        theme: AppTheme.lightTheme,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ReadTab(),
    WriteTab(),
    HistoryTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Tag Commander'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.nfc),
            label: 'Read',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Write',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
